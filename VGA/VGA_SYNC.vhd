----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:12:33 12/05/2019 
-- Design Name: 
-- Module Name:    VGA_SYNC - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_SYNC is
    Port ( CLK : in STD_LOGIC;
           H_SYNC : out STD_LOGIC;
           V_SYNC : out STD_LOGIC;
			  COLORS : out STD_LOGIC_VECTOR(7 downto 0));
end VGA_SYNC;

architecture Behavioral of VGA_SYNC is

component CLK_DIVIDER is
    Port ( CLK : in  STD_LOGIC;
           CLK25MHZ : out  STD_LOGIC);
end component;

component H_V_SYNC is
    Port ( CLK25MHZ : in  STD_LOGIC;
			  H_SYNC : out STD_LOGIC;
           V_SYNC : out  STD_LOGIC;
			  X : out STD_LOGIC_VECTOR(9 downto 0);
			  Y : out STD_LOGIC_VECTOR(9 downto 0));
end component;

signal CLK25MHZ : STD_LOGIC := '0'; 

signal X_POS : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
signal Y_POS : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
signal X_POS_INT : integer := 0;
signal Y_POS_INT : integer := 0;

signal r_H_SYNC : STD_LOGIC := '0';
signal r_V_SYNC : STD_LOGIC := '0';

signal RED : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
signal GREEN : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
signal BLUE : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');

begin

DIVIDER : CLK_DIVIDER port map
(CLK => CLK,
CLK25MHZ => CLK25MHZ);

SYNC : H_V_SYNC port map
(CLK25MHZ => CLK25MHZ,
H_SYNC => r_H_SYNC,
V_SYNC => r_V_SYNC,
X => X_POS,
Y => Y_POS);

X_POS_INT <= conv_integer(unsigned(X_POS));
Y_POS_INT <= conv_integer(unsigned(Y_POS));

disp : process(CLK)
begin
if rising_edge(CLK) then
	if (X_POS_INT < 640) and (Y_POS_INT < 480) then
		if X_POS_INT < 320 then
			RED <= (others => '1');
			GREEN <= (others => '0');
			BLUE <= (others => '0');
		else
			RED <= (others => '0');
			GREEN <= (others => '1');
			BLUE <= (others => '0');
		end if;
	else 
		RED <= (others => '0');
		GREEN <= (others => '0');
		BLUE <= (others => '0');
	end if;
end if;
end process;

V_SYNC <= r_V_SYNC;
H_SYNC <= r_H_SYNC; 

COLORS(7 downto 5) <= RED;
COLORS(4 downto 2) <= GREEN;
COLORS(1 downto 0) <= BLUE;

end Behavioral;

