----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2023 08:20:40 PM
-- Design Name: 
-- Module Name: mpg - Behavioral
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


--Facem un debouncer pentru butoanele pe care le folosim
entity mpg is
Port (
signal clk:in std_logic;
signal btn:in std_logic;
signal en:out std_logic
 );
end mpg;

architecture Behavioral of mpg is
signal counter:std_logic_vector(15 downto 0):=(others=>'0');

signal Q1:std_logic;
signal Q2:std_logic;
signal Q3:std_logic; 
begin
process(clk)
begin
if clk'event and clk='1' then
    counter<=counter+1;
end if;

--primul bistabil
if clk'event and clk='1' then
    if counter="1111111111111111" then
        Q1<=btn;
    end if;
end if;

-- bistabilele 2 si 3
if clk'event and clk='1' then
Q2<=Q1;
Q3<=Q2;
end if;

end process;

en<=Q2 and (not Q3);
end Behavioral;
