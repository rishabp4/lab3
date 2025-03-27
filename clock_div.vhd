----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_div is
    port (
        clk_in  : in std_logic;
        clk_out : out std_logic
    );
end clock_div;

architecture Behavioral of clock_div is

    signal counter : std_logic_vector(25 downto 0) := (others => '0');
    signal toggle  : std_logic := '0';

begin

    clk_out <= toggle;

    process (clk_in)
    begin
        if rising_edge(clk_in) then
            if unsigned(counter) < 1085 then -- change to match the other frequency 
                counter <= std_logic_vector(unsigned(counter) + 1);
                toggle  <= '0';
            else
                toggle  <= '1';
                counter <= (others => '0');
            end if;
        end if;
    end process;

end Behavioral;
