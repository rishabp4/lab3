----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2025 12:18:30 PM
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
 Port ( 
 txd, clk : in std_logic;
 btn : in std_logic_vector(1 downto 0);
 cts, rts, rxd   : out std_logic
 );
end top;

architecture Behavioral of top is

-- instantiate components
component uart
    port (
    clk, en, send, rx, rst      : in std_logic;
    charSend                    : in std_logic_vector (7 downto 0);
    ready, tx, newChar          : out std_logic;
    charRec                     : out std_logic_vector (7 downto 0)
);
end component;
component sender
  Port ( 
         reset, clk, en, btn, ready  : in std_logic;
         send : out std_logic;
         char : out std_logic_vector( 7 downto 0 )
         );
end component;

component clock_div
    port(
        clk_in : in std_logic;
        clk_out : out std_logic);
end component;

component debounce
    port(
        clk: in std_logic;
        btn: in std_logic;
        dbnc: out std_logic);
end component;


signal u1_to_u4_and_u5_rst, u2_to_u4_btn, u3_to_u4_and_u5_en : std_logic := '0';
signal u5_to_u4_ready, u4_to_u5_send : std_logic := '0';
signal sender_char : std_logic_vector(7 downto 0);
begin

U5 : uart
    port map(
        clk    => clk,
        en     => u3_to_u4_and_u5_en,
        ready  => u5_to_u4_ready,
        rst    => u1_to_u4_and_u5_rst,
        rx     => TXD,
        send   => u4_to_u5_send,
        charSend => sender_char,
        tx     => RXD
    );

U4 : sender
    port map (
        btn => u2_to_u4_btn,
        char   => sender_char,
        clk    => clk,
        en     => u3_to_u4_and_u5_en,
        ready  => u5_to_u4_ready,
        reset    => u1_to_u4_and_u5_rst,
        send   => u4_to_u5_send
    );

U3 : clock_div
    port map (
        clk_in     => clk,
        clk_out => u3_to_u4_and_u5_en
    );

U2 : debounce
    port map(
        btn  => btn(1),
        clk  => clk,
        dbnc => u2_to_u4_btn
    );

U1 : debounce
    port map (
        btn  => btn(0),
        clk  => clk,
        dbnc => u1_to_u4_and_u5_rst
    );






end Behavioral;