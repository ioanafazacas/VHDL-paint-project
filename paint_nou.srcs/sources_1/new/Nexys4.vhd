----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/12/2023 02:45:56 PM
-- Design Name: 
-- Module Name: Nexys4 - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Nexys4 is
Port ( 
signal VGA_R:out std_logic_vector(3 downto 0);
signal VGA_G:out std_logic_vector(3 downto 0);
signal VGA_B:out std_logic_vector(3 downto 0);
signal VGA_HS:out std_logic;
signal VGA_VS:out std_logic;
signal btn:in std_logic_vector(4 downto 0);
signal clk:in std_logic;
signal sw:in std_logic_vector(15 downto 0));
end Nexys4;

architecture Behavioral of Nexys4 is
signal btn_c:std_logic;
signal btn_sus:std_logic;
signal btn_jos:std_logic;
signal btn_st:std_logic;
signal btn_dr:std_logic;

begin

btn_centru:entity WORK.mpg port map
(
btn=>btn(0),
clk=>clk,
en=>btn_c
);
btn_s:entity WORK.mpg port map
(
btn=>btn(1),
clk=>clk,
en=>btn_sus
);
btn_stanga:entity WORK.mpg port map
(
btn=>btn(2),
clk=>clk,
en=>btn_st
);
btn_dreapta:entity WORK.mpg port map
(
btn=>btn(3),
clk=>clk,
en=>btn_dr
);
btn_j:entity WORK.mpg port map
(
btn=>btn(4),
clk=>clk,
en=>btn_jos
);
display:entity WORK.VGA port map
(
clk=>clk,
hsync=>VGA_HS,
vsync=>VGA_VS,
R=>VGA_R,
G=>VGA_G,
B=>VGA_B,
butoane=>btn(3 downto 0),
sw=>sw(11 downto 0),
enter=>btn(0),
print=>sw(15)
);
end Behavioral;
