library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seg7_controller is
    Port(
        -- inputs
        clk : in STD_LOGIC; -- system master clock (100MHz)
        rst : in STD_LOGIC; -- active high reset

        -- 4-bit digit for hex value on 7-segment
        c1 : in STD_LOGIC_VECTOR(3 downto 0);
        c2 : in STD_LOGIC_VECTOR(3 downto 0);
        c3 : in STD_LOGIC_VECTOR(3 downto 0);
        c4 : in STD_LOGIC_VECTOR(3 downto 0);
        c5 : in STD_LOGIC_VECTOR(3 downto 0);
        c6 : in STD_LOGIC_VECTOR(3 downto 0);
        c7 : in STD_LOGIC_VECTOR(3 downto 0);
        c8 : in STD_LOGIC_VECTOR(3 downto 0);

        -- outputs
        anodes : out STD_LOGIC_VECTOR(7 downto 0);
        cathodes: out STD_LOGIC_VECTOR(7 downto 0)
    );
end seg7_controller;

architecture arch of seg7_controller is

    signal pulse_1k : std_logic; -- 1kHz pulse generator output pulse
    signal counter : unsigned(2 downto 0); -- 0 to 7, index for anode and current digit
    signal char : std_logic_vector(3 downto 0); -- hold 4 bit digit for current char index

begin

    pulse : entity work.pulse_gen 
    generic map (counter_size => 28)
    port map (
        clk => clk, 
        rst => rst, 
        trig => x"00186a0", -- 100e3 hex (1kHz pulse)
        pulse => pulse_1k
    ); 

    process (clk, rst)
    begin 
        if (rst = '1') then
            counter <= (others=>'0');
        elsif(rising_edge(clk)) then
            if (pulse_1k = '1') then
                counter <= counter + 1;
                if (counter = 8) then
                    counter <= (others => '0');
                end if;
            end if;
        end if;
        
        -- active low anodes, assign current char
        case counter is
            when "000" =>
                anodes <= "11111110";
                char <= c1;
            when "001" =>
                anodes <= "11111101";
                char <= c2;
            when "010" =>
                anodes <= "11111011";
                char <= c3;
            when "011" =>
                anodes <= "11110111";
                char <= c4;
            when "100" =>
                anodes <= "11101111";
                char <= c5;
            when "101" =>
                anodes <= "11011111";
                char <= c6;
            when "110" =>
                anodes <= "10111111";
                char <= c7;
            when others =>
                anodes <= "01111111";
                char <= c8;
        end case;

        -- 7 segment encoder for cathodes (from lab1, lab2. tutorial)
        case char is 
            when "0000" =>
                cathodes <= "11000000";
            when "0001" =>
                cathodes <= "11111001";
            when "0010" =>
                cathodes <= "10100100";
            when "0011" =>
                cathodes <= "10110000";
            when "0100" =>
                cathodes <= "10011001";
            when "0101" =>
                cathodes <= "10010010";
            when "0110" =>
                cathodes <= "10000010";
            when "0111" =>
                cathodes <= "11111000";
            when "1000" =>
                cathodes <= "10000000";
            when "1001" =>
                cathodes <= "10010000";
            when "1010" =>
                cathodes <= "10001000";
            when "1011" =>
                cathodes <= "10000011";
            when "1100" =>
                cathodes <= "11000110";
            when "1101" =>
                cathodes <= "10100001";
            when "1110" =>
                cathodes <= "10000110";
            when others =>
                cathodes <= "10001110"; 
        end case;
    
    end process;
    
end arch ; -- arch