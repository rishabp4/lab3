--------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


--use UNISIM.VComponents.all;

entity debounce is
    port(
        clk: in STD_LOGIC;
        btn: in STD_LOGIC;
        dbnc: out STD_LOGIC := '0');
end debounce;
architecture Behavioral of debounce is
    signal previous : std_logic := '0';
    signal count : std_logic_vector(21 downto 0)  := (others => '0');
    signal debounced : std_logic := '0';
    begin
    dbnc <= debounced;
    process (clk) begin
 if rising_edge(clk) then
  if btn='1' then
     if unsigned(count) < 2500000 then
         count <= std_logic_vector(unsigned(count) + 1);
          else
         debounced <= '1';
         end if;
     else
   previous <= btn;
 count <= (others => '0');
     debounced <= '0';
   end if;
  end if;


    end process;

 end Behavioral;
