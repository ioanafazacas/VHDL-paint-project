----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/12/2023 02:49:29 PM
-- Design Name: 
-- Module Name: VGA - Behavioral
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

entity VGA is
Port (signal clk:in std_logic;
signal hsync:out std_logic;
signal vsync:out std_logic;
signal R:out std_logic_vector(3 downto 0);
signal G:out std_logic_vector(3 downto 0);
signal B:out std_logic_vector(3 downto 0);
signal butoane:in std_logic_vector(3 downto 0);
signal sw:in std_logic_vector(11 downto 0);
signal enter:in std_logic; --aplasarea unui pixel de culoare pe ecran
signal print:in std_logic --punerea unei imagini pe ecran
);

end VGA;

architecture Behavioral of VGA is
signal HPOS:integer range 0 to 1688:=0;
signal VPOS:integer range 0 to 1066:=0;

signal patrat_x1:integer range 0 to 1688:=800;
signal patrat_y1:integer range 0 to 1688:=500;

signal indexX:integer range 0 to 45;
signal indexY:integer range 0 to 42;
signal draw:std_logic:='0';
signal okey:std_logic;
--signal painting:std_logic:='0'; --desenarea pe ecarn

type memorie_coord is array (0 to 41) of integer;
type memorie_culoare is array (0 to 41) of std_logic_vector(11 downto 0);
signal memorie_coord_x:memorie_coord:=(others=>0);
signal memorie_coord_y:memorie_coord:=(others=>0);
signal memorie_cul:memorie_culoare:=(others=>(others=>'0'));
signal counter_memorie:integer:=0;

type vector_animatie_alb_negru is array(42 downto 0) of std_logic_vector(46 downto 0);                           

signal memorie_fata_curgatoare:vector_animatie_alb_negru:=(0=>"00000000000000000000111111100000000000000000000",
                                                           1=>"00000000000000001111111111111110000000000000000",    
                                                           2=>"00000000000000111111111111111111100000000000000",
                                                           3=>"00000000000011111111111111111111111000000000000",
                                                           4=>"00000000000111111111111111111111111100000000000",
                                                           5=>"00000000001111111111111111111111111110000000000",
                                                           6=>"00000000011111111111111111111111111111000000000",
                                                           7=>"00000000111111110011111111111111111111100000000",
                                                           8=>"00000000111111100001111111111111111111110000000",
                                                           9=>"00000001111111100000111111111111111111110000000",
                                                          10=>"00000001111111100000111111111111111111111000000",
                                                          11=>"00000011111111100001111111100011111111111000000",
                                                          12=>"00000011111111100001111111000001111111111100000",
                                                          13=>"00000011111111111111111111000001111111111100000",
                                                          14=>"00000011111111111111111111000001111111111100000",
                                                          15=>"00000111111111111111111111100001111111111100000",
                                                          16=>"00000111111111111111111111111111111111111110000",
                                                          17=>"00000111111111111111111111111111111111111110000",
                                                          18=>"00000111111111110111111111111111111111111110000",
                                                          19=>"00000011111111110011111111111111111111111110000",
                                                          20=>"00000011111111110000111111111101111111111100000",
                                                          21=>"00000011111111111000000111100001111111111100000",
                                                          22=>"00000011111111111100000000000111111111111100000",
                                                          23=>"00000001111111111111000000001111111111111100000",
                                                          24=>"00000001111111111111111111111111111111111000000",
                                                          25=>"00000001111111111111111111111111111111111000000",
                                                          26=>"00000001111111111111111111111111111111111000000",
                                                          27=>"00000001111111111111111111111111111111111000000",
                                                          28=>"00000001111111111111111111111111111111111000000",
                                                          29=>"00000000001111111111111111111111111101111000000",
                                                          30=>"00000000001110011111111111111111111101111000000",
                                                          31=>"00000000001110011111111111111111111101111000000",
                                                          32=>"00000000001110011111111111111111111101111000000",
                                                          33=>"00000000001110011111111110011111111001110000000",
                                                          34=>"00000000001110001111111110011100000000110000000", 
                                                          35=>"00000000000000000110111110011100000000000000000",  
                                                          36=>"00000000000000000000111110011100000000000000000",
                                                          37=>"00000000000000000000111110011100000000000000000",
                                                          38=>"00000000000000000000111110011100000000000000000",
                                                          39=>"00000000000000000000111110000000000000000000000",
                                                          40=>"00000000000000000000111100000000000000000000000",
                                                          41=>"00000000000000000000011000000000000000000000000",
                                                          42=>"00000000000000000000000000000000000000000000000");
                                                          
begin

--proces de memorare culori si coordonate
process(clk) 
begin
if clk='1' and clk'event then 
    if enter='1' then
        memorie_coord_x(counter_memorie)<=patrat_x1;
        memorie_coord_y(counter_memorie)<=patrat_y1;
        memorie_cul(counter_memorie)<=sw;
        if counter_memorie<2 then
            counter_memorie<=counter_memorie+1;
        else
            counter_memorie<=0;
        end if;
    end if; 
end if;
end process;

--proces desenare imagine
process(clk)
begin
        
if clk'event and clk='1' then
if print='1' then        
if (indexX>=0 and indexX<=46) and ( indexY >=0 and indexY<=42) then
                    
    if memorie_fata_curgatoare(indexX)(indexY)='0' then
        R<=(others=>'0');
        G<=(others=>'0');
        B<=(others=>'0');
    else
        R<=(others=>'1');
        G<=(others=>'1');
        B<=(others=>'1');
    end if;
    else
        R<=(others=>'0');
        G<=(others=>'0');
        B<=(others=>'0');
    end if;
            
    if VPOS>=patrat_x1 and VPOS<=patrat_x1+46 then
        if HPOS>=patrat_y1 and HPOS<=patrat_y1+42 then
        indexY<=indexY+1;
             okey<='1';
    else
        indexY<=0;
    if okey='1' then 
        okey<='0';
        indexX<=indexX+1;
    end if;
        R<=(others=>'0');
        G<=(others=>'0');
        B<=(others=>'0');
    end if;
    else 
        indexX<=0;
        R<=(others=>'0');
        G<=(others=>'0');
        B<=(others=>'0');
    end if;



else 

--desenare ecran
if HPOS=patrat_x1 and VPOS=patrat_y1 then
   R<=sw(11 downto 8);
   G<=sw(7 downto 4);
   B<=sw(3 downto 0);
elsif HPOS/=patrat_x1 or VPOS/=patrat_y1 then
   R<=(others=>'0');
   G<=(others=>'0');
   B<=(others=>'0'); 
end if;
if memorie_coord_x(0)=HPOS and memorie_coord_y(0)=VPOS then
R<=memorie_cul(0)(11 downto 8);
G<=memorie_cul(0)(7 downto 4);
B<=memorie_cul(0)(3 downto 0);
end if;
if memorie_coord_x(1)=HPOS and memorie_coord_y(1)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(2)=HPOS and memorie_coord_y(2)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(3)=HPOS and memorie_coord_y(3)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(4)=HPOS and memorie_coord_y(4)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(5)=HPOS and memorie_coord_y(5)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(6)=HPOS and memorie_coord_y(6)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(7)=HPOS and memorie_coord_y(7)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(8)=HPOS and memorie_coord_y(8)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(9)=HPOS and memorie_coord_y(9)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(10)=HPOS and memorie_coord_y(10)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(11)=HPOS and memorie_coord_y(11)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(12)=HPOS and memorie_coord_y(12)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(13)=HPOS and memorie_coord_y(13)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(14)=HPOS and memorie_coord_y(14)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(15)=HPOS and memorie_coord_y(15)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(16)=HPOS and memorie_coord_y(16)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(17)=HPOS and memorie_coord_y(17)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(18)=HPOS and memorie_coord_y(18)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(19)=HPOS and memorie_coord_y(19)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(20)=HPOS and memorie_coord_y(20)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(21)=HPOS and memorie_coord_y(21)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(22)=HPOS and memorie_coord_y(22)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(23)=HPOS and memorie_coord_y(23)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(24)=HPOS and memorie_coord_y(24)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(25)=HPOS and memorie_coord_y(25)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(26)=HPOS and memorie_coord_y(26)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(27)=HPOS and memorie_coord_y(27)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(28)=HPOS and memorie_coord_y(28)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(29)=HPOS and memorie_coord_y(29)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(30)=HPOS and memorie_coord_y(30)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(31)=HPOS and memorie_coord_y(31)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(32)=HPOS and memorie_coord_y(32)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(33)=HPOS and memorie_coord_y(33)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(34)=HPOS and memorie_coord_y(34)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(35)=HPOS and memorie_coord_y(35)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(36)=HPOS and memorie_coord_y(36)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(37)=HPOS and memorie_coord_y(37)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(38)=HPOS and memorie_coord_y(38)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(39)=HPOS and memorie_coord_y(39)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
if memorie_coord_x(40)=HPOS and memorie_coord_y(40)=VPOS then
R<=memorie_cul(1)(11 downto 8);
G<=memorie_cul(1)(7 downto 4);
B<=memorie_cul(1)(3 downto 0);
end if;
-- parcurgerea "canvas-ului"
    if (HPOS<1688) then
        HPOS<=HPOS+1;
    else
        HPOS<=0;
            if VPOS<1066 THEN
                VPOS<=VPOS+1;
            else
                VPOS<=0;
            end if;
    end if;

 --perioada de sincronizare
    if(HPOS>48 and HPOS<160) then 
        hsync<='0';
    else
        hsync<='1';
    end if;
    
    if(VPOS>0 and VPOS<4) then
        vsync<='0';
    else
        vsync<='1';
    end if;
--RGB pt perioada de sincronizare    
    if((HPOS>0 and HPOS<408) or (VPOS>0 and VPOS<42))then 
    R<=(others=>'0');
    G<=(others=>'0');
    B<=(others=>'0');
    end if;

-- miscarea patratelului pe ecarn
if butoane="1000" then
patrat_y1<=patrat_y1-5;
end if;

if butoane="0100" then
patrat_y1<=patrat_y1+5;
end if;

if butoane="0010" then
patrat_x1<=patrat_x1-5;
end if;

if butoane="0001" then
patrat_x1<=patrat_x1+5;
end if;
end if;
end if;
end process;

end Behavioral;
