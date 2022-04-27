

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

    freq_sel : in std_logic_vector(2 downto 0);
    sine : out std_logic_vector(15 downto 0)
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

    signal phase : std_logic_vector(7 downto 0);
    signal phase_pulse : std_logic;
    signal raw_sine : std_logic_vector(15 downto 0);
    --signal sine : std_logic_vector(15 downto 0);

begin

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
