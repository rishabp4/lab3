----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/20/2025 07:45:34 PM
-- Design Name: 
-- Module Name: sender - Behavioral
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sender is
Port ( 
 reset, clk, en, btn, ready  : in std_logic;
         send : out std_logic;
         char : out std_logic_vector( 7 downto 0 )
);
end sender;

architecture Behavioral of sender is
type state is (idle, busyA, busyB, busyC);
signal currentState : state := idle;
type asciiString is array(0 to 4) of std_logic_vector(7 downto 0); 
-- rnp77 = 5 characters

signal binCounter : std_logic_vector(2 downto 0) := (others => '0'); 
signal netid : asciiString := (x"72", x"6E", x"70", x"37", x"37"); -- "rnp77" in ASCII

constant n : std_logic_vector(2 downto 0) := "101"; -- binary 5



begin
process(clk)
    begin
if reset = '1' then
-- reset conditions 
currentState <= idle;
send <= '0';
binCounter <= (others => '0');
char <= (others => '0');

end if;

if en ='1' AND rising_edge (clk) then

case CurrentState is
    when busyA =>  currentState <= busyB;
    
    when busyB => 
    currentState <= busyC;
    send <= '0';
    when idle => 
    if  unsigned(binCounter) < unsigned(n)  AND ready = '1' AND btn = '1' then
      binCounter <= std_logic_vector(unsigned(bincounter) + 1);
    char <= NETID(to_integer(unsigned(binCounter))); -- holds NETID("i");
    send<= '1';
    currentState <= busyA; 
    elsif btn = '1' AND ready = '1' AND binCounter=n then
    currentstaTe <= idle;
    binCounter <= (others => '0');
    end if;
    
    when busyC => 
    if btn ='0' AND ready= '1' then 
    currentState  <= idle;
    end if;
    
    when others =>
    send <= '0';
binCounter <= (others => '0');
char <= (others => '0');
currentState  <= idle;

end case; 
end if; 
    end process;
                      
        
    
    

end Behavioral;