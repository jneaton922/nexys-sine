library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity phase_accum is 
    port (
        clk : in std_logic;
        reset : in std_logic;

        sample_pulse : in std_logic;
        phase_count : out std_logic_vector(7 downto 0)
    );
end phase_accum;

architecture arch of phase_accum is
    signal cntr_sig : unsigned(7 downto 0);
begin
    process(clk, reset)
        if (reset = '1') then
            cntr_sig <= (others => '0');
        elsif (rising_edge(clk)) then
            if (sample_pulse = '1') then
                cntr_sig <= cntr_sig + 1;
            end if;
        end if;
    end process;
    phase_count <= cntr_sig;

end arch;   