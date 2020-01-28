----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:49:27 12/18/2019 
-- Design Name: 
-- Module Name:    PWM_SIGNAL - Behavioral 
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

entity PWM_SIGNAL is
port(
		CLK : in std_logic;
		PWM_OUT : out std_logic);
end PWM_SIGNAL;

architecture Behavioral of PWM_SIGNAL is

signal counter_05_sec : integer range 0 to 2499999 := 0;
signal clk_05_sec : std_logic := '0';

signal counter_5khz : integer range 0 to 9999 := 0;
signal clk_5khz : std_logic := '0';

signal width : integer range 0 to 99 := 0;
signal actual_width : integer range 0 to 99 := 0;
signal pwm : std_logic := '0';

begin

clk_5khz_gen : process(CLK) 
begin
if rising_edge(CLK) then
	if counter_5khz < 999 then
		counter_5khz <= counter_5khz + 1;
	else
		counter_5khz <= 0;
		clk_5khz <= not clk_5khz;
	end if;
end if;
end process;

sec_005 : process(CLK)
begin
if rising_edge(CLK) then
	if counter_05_sec < 2499999 then
		counter_05_sec <= counter_05_sec + 1;
	else
		counter_05_sec <= 0;
		clk_05_sec <= not clk_05_sec;
	end if;
end if;
end process;

waving : process(clk_05_sec)
begin
if rising_edge(clk_05_sec) then
	if width < 99 then
		width <= width + 1;
	else 
		width <= 0;
	end if;
end if;
end process;

main : process(clk_5khz)
begin
if rising_edge(clk_5khz) then
	if actual_width < 99 then
		actual_width <= actual_width + 1;
		if actual_width < width then
			pwm <= '0';
		else 
			pwm <= '1';
		end if;
	else
		actual_width <= 0;
		pwm <= '1';
	end if;
end if;
end process;

PWM_OUT <= pwm;

end Behavioral;

