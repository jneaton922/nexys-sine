library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.all;


entity volume is
    Port (
        clk: in std_logic;
        reset:  in std_logic;
        volume_sel : in std_logic_vector(2 downto 0);
        sine : in std_logic_vector(15 downto 0);
        sine_shift : out std_logic_vector(15 downto 0)
    );
end volume;

architecture arch of volume is
    signal sine_inv : std_logic_vector(15 downto 0);
begin
    process (clk, reset)
    begin
        if (reset = '1') then
            sine_shift <= (others => '0');
        elsif (rising_edge(clk)) then
            sine_inv <= sine;
            sine_inv(15) <= not sine(15);
            case volume_sel is
                when "000" =>
                    sine_shift <= (others => '0');
                when "001" => -- 1/7
                    sine_shift <= std_logic_vector(
                        to_unsigned(to_integer(unsigned(sine_inv))*1/7, 16));
                when "010" =>-- 2/7
                    sine_shift <= std_logic_vector(
                        to_unsigned(to_integer(unsigned(sine_inv))*2/7, 16));
                when "011" => -- 3/7
                    sine_shift <= std_logic_vector(
                        to_unsigned(to_integer(unsigned(sine_inv))*3/7, 16));
                when "100" =>-- 4/7
                    sine_shift <= std_logic_vector(
                        to_unsigned(to_integer(unsigned(sine_inv))*4/7, 16));
                when "101" => -- 5/7
                    sine_shift <= std_logic_vector(
                        to_unsigned(to_integer(unsigned(sine_inv))*5/7, 16));
                when "110" =>-- 6/7
                    sine_shift <= std_logic_vector(
                        to_unsigned(to_integer(unsigned(sine_inv))*6/7, 16));
                when others =>
                    sine_shift <= sine_inv;
            end case;
        end if;
    end process;
end arch;