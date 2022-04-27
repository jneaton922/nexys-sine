library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_textio.all;
use IEEE.NUMERIC_STD.ALL;
use work.all;

entity lab7_tb is
end lab7_tb;

architecture sim of lab7_tb is
    signal clk : std_logic;
    signal reset : std_logic;
    signal mono : std_logic;
    signal freq_sel : std_logic_vector(2 downto 0);
    signal volume : std_logic_vector(2 downto 0);
    signal audio_amp_en : std_logic;

begin

	--100MHz clock
	process
	begin
		clk <= '0';
		wait for 5 ns;
		clk <= '1';
		wait for 5 ns;
	end process;

    --Main testbench process
	process
	begin
		reset <= '1';
        wait for 1 ns;
        freq_sel <= "000";
        reset<= '0';

        wait for 3 ms;
        freq_sel <= "101";
        wait for 3 ms;
        freq_sel <= "110";
        wait for 3 ms;
        freq_sel <= "111";
        wait for 3 ms;
        freq_sel <= "001";
        wait for 3 ms;
        freq_sel <= "010";
        wait for 3 ms;
        freq_sel <= "011";
        wait for 3 ms;
    end process;

    dut : entity lab7_top port map (
        clk => clk,
        reset => reset,
        mono => mono,
        freq_sel => freq_sel,
        volume => volume,
        audio_amp_en => audio_amp_en
    );
end sim;