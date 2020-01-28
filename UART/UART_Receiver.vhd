----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:06:59 11/30/2019 
-- Design Name: 
-- Module Name:    UART_Receiver - Behavioral 
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

entity UART_Receiver is
generic(
			tacts_per_bit 		: integer := 868;
			bits_to_receive 	: integer := 8);
			
port(
			i_CLK 				: in std_logic;
			i_Serial_Data 		: in std_logic;
			o_Data_Done			: out std_logic;
			o_Parallel_Data	: out std_logic_vector (7 downto 0));
			
end UART_Receiver;

architecture Behavioral of UART_Receiver is

type s_State is (s_Idle, s_Start, s_Data, s_Stop, s_Access);
signal r_State : s_State := s_Idle;

signal r_Serial_Data	 			: std_logic := '0';
signal r_Serial_Data_Buffer	: std_logic := '0';

signal r_Counter 		: integer range 0 to tacts_per_bit := 0;
signal r_Data_Index 	: integer range 0 to bits_to_receive := 0;

signal r_Data_Done 		: std_logic := '0';
signal r_Parallel_Data	: std_logic_vector (7 downto 0) := (others => '0');

begin

sampling : process(i_CLK)
begin
if rising_edge(i_CLK) then
	r_Serial_Data_Buffer <= i_Serial_Data;
	r_Serial_Data 			<= r_Serial_Data_Buffer;
end if;
end process;

receiving : process(i_CLK)
begin
if rising_edge(i_CLK) then
	case r_State is
	
		when s_Idle =>
			r_Data_Done <= '0';
			if r_Serial_Data = '0' then
				r_State <= s_Start;
			else
				r_State <= s_Idle;
			end if;
	
		when s_Start =>
			if r_Counter < tacts_per_bit/2 then
				r_Counter <= r_Counter + 1;
			else 
				if r_Serial_Data = '0' then
					r_State <= s_Data;
				end if;
				r_Counter <= 0;
			end if;
	
		when s_Data =>
			if r_Counter < tacts_per_bit then
				r_Counter <= r_Counter + 1;
			else
				r_Counter <= 0;
				if r_Data_Index < bits_to_receive then
					r_Data_Index <= r_Data_Index + 1;
					r_Parallel_Data(r_Data_Index) <= r_Serial_Data;
				else 
					r_Data_Index <= 0;
					r_State <= s_Stop;
				end if;
			end if;
	
		when s_Stop =>
			if r_Counter < tacts_per_bit then
				r_Counter <= r_Counter + 1;
			else
				r_Counter <= 0;
				if r_Serial_Data = '1' then
					r_State <= s_Access;
				end if;
			end if;
	
		when s_Access =>
			r_Data_Done <= '1';
			r_State <= s_Idle;
	
	end case;
end if;
end process;

o_Data_Done <= r_Data_Done;
o_Parallel_Data <= r_Parallel_Data;

end Behavioral;

