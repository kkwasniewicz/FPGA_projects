----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:12:58 11/28/2019 
-- Design Name: 
-- Module Name:    Driver - Behavioral 
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

entity Driver is
port(
		IO_P1 : out std_logic_vector(9 downto 3);
		IO_P2 : out std_logic_vector(4 downto 3);
		CLK	: in std_logic);
end Driver;

architecture Behavioral of Driver is

signal segments 		: std_logic_vector(6 downto 0) := (others => '0');
signal anodes 	 		: std_logic_vector(1 downto 0) := (others => '0');
signal flag_khz 		: std_logic := '0';
signal counter  		: integer := 0;
signal counter_khz 	: integer := 0;
signal digit_1  		: integer range 0 to 9 := 0;
signal digit_2  		: integer range 0 to 9 := 0;

function digit2seg (digit : integer range 0 to 9)
	return std_logic_vector is
	variable TEMP : std_logic_vector(6 downto 0);
begin
	case digit is
		when 0 => TEMP := "1111110";
		when 1 => TEMP := "0110000";
		when 2 => TEMP := "1101101";
		when 3 => TEMP := "1111001";
		when 4 => TEMP := "0110011";
		when 5 => TEMP := "1011011";
		when 6 => TEMP := "1011111";
		when 7 => TEMP := "1110000";
		when 8 => TEMP := "1111111";
		when 9 => TEMP := "1111011";
	end case;
	return TEMP;
end;

begin

clock_cycles_1s: process(CLK)
begin 
if rising_edge(CLK) then
	if counter = 100000000 then
		if digit_1 = 9 then
			if digit_2 = 9 then
				digit_2 <= 0;
			else 
				digit_2 <= digit_2 + 1;
			end if;
			digit_1 <= 0;
		else
			digit_1 <= digit_1 + 1;
		end if;
		counter <= 0;
	else 
		counter <= counter + 1;
	end if;
end if;
end process;

khz_1: process(CLK)
begin
if rising_edge(CLK) then
	if counter_khz = 100000 then
		counter_khz <= 0;
		flag_khz <= not flag_khz;
	else 
		counter_khz <= counter_khz + 1;
	end if;
end if;
end process;

mux: process(CLK)
begin
if rising_edge(CLK) then
	case flag_khz is
		when '0' => anodes <= "01";
		when '1' => anodes <= "10";
		when others => anodes <= "00";
	end case;
end if;
end process;

segment_drive: process(CLK)
begin
if rising_edge(CLK) then
	case flag_khz is
		when '0' => segments <= digit2seg(digit_1);
		when '1' => segments <= digit2seg(digit_2);
		when others => segments <= "1010101";
	end case;
end if;
end process;

IO_P1(9 downto 3) <= not segments(6 downto 0);
IO_P2(4 downto 3) <= anodes(1 downto 0);

end Behavioral;