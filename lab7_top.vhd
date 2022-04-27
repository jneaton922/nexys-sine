

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

    volume_sel : in std_logic_vector(2 downto 0);
    freq_sel : in std_logic_vector(2 downto 0);

    audio_amp_en : in std_logic;
    AUD_SD : out std_logic;
    AUD_PWM : out std_logic

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
    signal freq_disp : std_logic_vector(15 downto 0);
    signal vol_disp : std_logic_vector(15 downto 0);

    signal phase : std_logic_vector(7 downto 0);
    signal phase_pulse : std_logic;
    signal raw_sine : std_logic_vector(15 downto 0);
    signal sine_shift : std_logic_vector(15 downto 0);

    signal duty : std_logic_vector(9 downto 0);
    signal pwm_out : std_logic;

begin
  
  AUD_SD <= audio_amp_en;

  seg7 : entity work.seg7_controller port map (
      clk => clk,
      rst => reset,
      c1 => freq_disp(3 downto 0),
      c2 => freq_disp(7 downto 4),
      c3 => freq_disp(11 downto 8),
      c4 => freq_disp(15 downto 12),
      c5 => vol_disp(3 downto 0),
      c6 => vol_disp(7 downto 4),
      c7 => vol_disp(11 downto 8),
      c8 => vol_disp(15 downto 12),
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
    duty => sine_shift(15 downto 6),
    pwm => AUD_PWM
  );

  volume_shift : entity volume 
  port map (
    clk => clk,
    reset => reset,
    volume_sel => volume_sel,
    sine => raw_sine,
    sine_shift => sine_shift
  );

  sine_lut : component sine_lut_dds port map (
    aclk => clk,
    s_axis_phase_tvalid => '1',
    s_axis_phase_tdata => phase,
    m_axis_data_tdata => raw_sine
  );

  volume_disp : process (clk,reset)
  begin
    if (reset = '1') then
      vol_disp <= x"0000";
    elsif(rising_edge(clk)) then
      case volume_sel is
        when "111" =>
          vol_disp <= x"0100";
        when "110" =>
          vol_disp <= x"0086";
        when "101" =>
          vol_disp <= x"0072";
        when "100" =>
          vol_disp <= x"0057";
        when "011" =>
          vol_disp <= x"0043";
        when "010" =>
          vol_disp <= x"0028";
        when "001" =>
          vol_disp <= x"0014";
        when others =>
          vol_disp <= x"0000";
      end case;
    end if;
  end process;

  frequency_disp : process (clk, reset)
  begin
    if (reset = '1') then
      freq_disp <= x"0000";
    elsif(rising_edge(clk)) then
      case freq_sel is
        when "111" =>
          freq_disp <= x"3500";
        when "110" =>
          freq_disp <= x"3000";
        when "101" =>
          freq_disp <= x"2500";
        when "100" =>
          freq_disp <= x"2000";
        when "011" =>
          freq_disp <= x"1500";
        when "010" =>
          freq_disp <= x"1000";
        when "001" =>
          freq_disp <= x"0500";
        when others =>
          freq_disp <= x"0000";
      end case;
    end if;
  end process;
end arch;
