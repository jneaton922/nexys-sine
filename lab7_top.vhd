

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/19/2022 08:31:17 PM
-- Design Name: 
-- Module Name: lab5_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.all;

-- top level entity
entity lab7_top is
  Port (
    clk : in std_logic;
    reset : in std_logic;

    -- 7 segment signals
    SEG7_CATH : out STD_LOGIC_VECTOR (7 downto 0);
    AN : out STD_LOGIC_VECTOR (7 downto 0);

    volume : in std_logic_vector(2 downto 0);
    freq_sel : in std_logic_vector(2 downto 0);

    audio_amp_en : in std_logic;
    AUD_SD : out std_logic;

    mono : out std_logic

  );
end lab7_top;

-- top-level arch
architecture arch of lab7_top is


    component sine_lut_dds
    port (
    aclk: in std_logic;
    s_axis_phase_tvalid : in std_logic;
    s_axis_phase_tdata : in std_logic_vector(7 downto 0); --8 bit PHASE resolution
    m_axis_data_tvalid : out std_logic;
    m_axis_data_tdata: out std_logic_vector(15 downto 0)
    );
    end component;

    -- 4-bit hex for each 7 segment character
    signal c1 :  STD_LOGIC_VECTOR(3 downto 0);
    signal c2 :  STD_LOGIC_VECTOR(3 downto 0);
    signal c3 :  STD_LOGIC_VECTOR(3 downto 0);
    signal c4 :  STD_LOGIC_VECTOR(3 downto 0);
    signal c5 :  STD_LOGIC_VECTOR(3 downto 0);
    signal c6 :  STD_LOGIC_VECTOR(3 downto 0);
    signal c7 :  STD_LOGIC_VECTOR(3 downto 0);
    signal c8 :  STD_LOGIC_VECTOR(3 downto 0);

    signal phase : std_logic_vector(7 downto 0);
    signal phase_pulse : std_logic;
    signal raw_sine : std_logic_vector(15 downto 0);
    signal sine : std_logic_vector(15 downto 0);

    signal duty : std_logic_vector(9 downto 0);
    signal pwm_out : std_logic;

begin
  
    seg7 : entity work.seg7_controller port map (
        clk => clk,
        rst => reset,
        c1 => c1,
        c2 => c2,
        c3 => c3,
        c4 => c4,
        c5 => c5,
        c6 => c6,
        c7 => c7,
        c8 => c8,
        anodes => AN,
        cathodes => SEG7_CATH
    );

    sample_pulse_gen : entity sample_rate port map (
      clk => clk,
      reset => reset,
      freq_sel => freq_sel,
      sample_pulse => phase_pulse
    );

    phase_counter : entity phase_accum port map (
      clk => clk, 
      reset => reset,
      sample_pulse => phase_pulse,
      phase_count => phase
    );

    pwm : entity pwm_gen
    generic map (pwm_resolution => 10)
    port map (
      clk => clk,
      reset => reset,
      duty => sine(15 downto 6),
      pwm => mono
    );

    sine_lut : component sine_lut_dds port map (
      aclk => clk,
      s_axis_phase_tvalid => '1',
      s_axis_phase_tdata => phase,
      m_axis_data_tdata => raw_sine
    );

    process (clk, reset)
    begin
      if (reset = '1') then
        sine <= x"0000";
      elsif (rising_edge(clk)) then
        sine <= raw_sine;
        sine(15) <= not raw_sine(15); 
      end if;
    end process;

end arch;
