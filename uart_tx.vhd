----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/15/2025 02:51:35 PM
-- Design Name: 
-- Module Name: uart_tx - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
use IEEE.NUMERIC_STD.ALL;
entity uart_tx is
 Port (
 clk , en , send , rst : in std_logic;
 char : in std_logic_vector (7 downto 0);
 ready , tx : out std_logic
  );
end uart_tx;

architecture Behavioral of uart_tx is

signal shiftReg : std_logic_vector (7 downto 0); -- this holds char
type state is (data, start, idle);
signal currentState : state := idle; -- do I do := 'idle'?
signal count : unsigned(3 downto 0) := (others => '0'); -- 4 bits to count to signal

begin

process(clk)
    begin
if rst = '1' then

tx <= '1'; -- signal for no data transfer
ready <= '1';
end if;

if en ='1' AND rising_edge (clk) then

case currentState is 
when data =>
if count < 8 then  -- can be done using a for loop?
currentState <= data; --   when to use start?
count <= (count + 1);
tx <= shiftReg(0);
shiftReg <= std_logic_vector(shift_right(unsigned(shiftReg), 1));

else 
currentState <= idle; 
end if;

when idle =>

if send = '1' then
currentState <= data; -- go to the data transmit mode 
ready <= '0';
tx <= '0';
shiftReg <= char;

else
count <= (others => '0'); -- reset counter 
ready <= '1';
tx <= '1';
end if; 

when others => 
currentState <= idle;
                      
end case;
end if;
end process;

end Behavioral;