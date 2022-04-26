library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pulse_gen is
    Port (
        clk : in STD_LOGIC;
        rst : in std_logic;
        trig : in unsigned(11 downto 0);
        pulse : out std_logic
    );
end pulse_gen;

architecture arch of pulse_gen is

    signal count : unsigned(26 downto 0);  -- max trigger of 100MHZ system clock == 27 bits
    signal clear : std_logic;

begin
    -- process adapted from "Lab3 Hints" Slide deck
    process (clk, rst)
    begin
        if (rst = '1') then
            count <= (others=> '0');
        elsif (rising_edge(clk)) then
            if (clear = '1') then
                count <= (others => '0');
            else 
                count <= count + 1;
            end if;
        end if;
    end process;
    
    clear <= '1' when (count  = trig) else '0';
    pulse <= clear;

end arch ; -- arch

