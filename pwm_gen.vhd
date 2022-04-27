library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.all;

entity pwm_gen is 
    Generic ( pwm_resolution : integer := 10);
    Port ( 
        clk : in std_logic;
        reset : in std_logic;

        duty : in std_logic_vector(pwm_resolution-1 downto 0);
        pwm : out std_logic
    );
end pwm_gen;

architecture arch of pwm_gen is
    signal cntr_sig : unsigned(pwm_resolution-1 downto 0);
begin
    process (clk, reset)
    begin
        if (reset = '1') then 
            cntr_sig <= (others => '0');
        elsif (rising_edge(clk)) then
            cntr_sig <= cntr_sig + 1;
        end if;
    end process;
    pwm <= '1' when cntr_sig < unsigned(duty) and cntr_sig /= 1023 else '0';
end arch;
