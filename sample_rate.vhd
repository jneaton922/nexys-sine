library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.all;

entity sample_rate is
    port (
        clk : in std_logic;
        reset : in std_logic;

        -- 000 = 0HZ
        -- 001 = 500 Hz
        -- 010 = 1kHZ
        -- 011 = 1.5kHz
        -- 100 = 2kHz
        -- 101 = 2.5kHz
        -- 110 = 3kHz
        -- 111 = 3.5kHz
        freq_sel : in std_logic_vector(2 downto 0);

        sample_pulse : out std_logic -- pulse enable for downstream counter(s)
    );
end sample_rate;

architecture arch of sample_rate is
    signal pulse_trigger : unsigned(11 downto 0);
    signal pulse_reset : std_logic;

begin

    pulse : entity pulse_gen 
    generic map (counter_size => 12)
    port map (
        clk => clk,
        rst => pulse_reset,
        trig => pulse_trigger,
        pulse => sample_pulse
    );

    -- separate reset signal for pulse to accomodate 0 Hz counter case
    pulse_reset <= '1' when freq_sel = "000" else reset;

    -- switch/case of frequencies based on 
    -- 1/freq = 256*10ns*maxsamplecount
    -- max_sample_count = 1/(freq*256*10ns)
    process (clk, reset)
    begin
        if (reset = '1') then
            pulse_trigger <= (others =>'0');
        elsif (rising_edge(clk)) then
            case freq_sel is
                when "001" =>
                    pulse_trigger <= x"30e";
                when "010" => 
                    pulse_trigger <= x"187";
                when "011" =>
                    pulse_trigger <= x"105";
                when "100" =>
                    pulse_trigger <= x"0c4";
                when "101" =>
                    pulse_trigger <= x"09d";
                when "110" =>
                    pulse_trigger <= x"083";
                when "111" =>
                    pulse_trigger <= x"070";
                when others =>
                    pulse_trigger <= x"fff";
            end case;
        end if;
    end process;
end arch;