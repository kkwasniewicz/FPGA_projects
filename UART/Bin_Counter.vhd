----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:52:31 12/01/2019 
-- Design Name: 
-- Module Name:    Bin_Counter - Behavioral 
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

entity Bin_Counter is
    Port ( LED : out  STD_LOGIC_VECTOR (7 downto 0);
           CLK : in  STD_LOGIC);
end Bin_Counter;

architecture Behavioral of Bin_Counter is

signal counter : std_logic_vector (25 downto 0) := (others => '0');

begin

LED(7 downto 0) <= counter(25 downto 18);

process(CLK)
begin
if rising_edge(CLK) then
counter <= counter + 1;
end if;
end process;

end Behavioral;

