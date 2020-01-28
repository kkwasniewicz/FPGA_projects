----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:29:47 12/05/2019 
-- Design Name: 
-- Module Name:    CLK_DIVIDER - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CLK_DIVIDER is
    Port ( CLK : in  STD_LOGIC;
           CLK25MHZ : out  STD_LOGIC);
end CLK_DIVIDER;

architecture Behavioral of CLK_DIVIDER is

signal divided_clk : std_logic := '0';
signal counter : integer range 0 to 1 := 0;

begin

process(CLK)
begin
	if falling_edge(CLK) then
		if counter = 1 then
			counter <= 0;
			divided_clk <= not divided_clk;
		else
			counter <= counter + 1;
		end if;
	end if;
end process;

CLK25MHZ <= divided_clk;

end Behavioral;

