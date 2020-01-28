----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:40:11 12/05/2019 
-- Design Name: 
-- Module Name:    V_SYNC - Behavioral 
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

entity H_V_SYNC is
    Port ( CLK25MHZ : in  STD_LOGIC;
			  H_SYNC : out STD_LOGIC;
           V_SYNC : out  STD_LOGIC;
			  X : out STD_LOGIC_VECTOR(9 downto 0);
			  Y : out STD_LOGIC_VECTOR(9 downto 0));
end H_V_SYNC;

architecture Behavioral of H_V_SYNC is

constant h_display : integer := 640;
constant h_front_porch : integer := 16;
constant h_sync_pulse : integer := 96;
constant h_back_porch : integer := 48;
constant h_max : integer := h_display + h_front_porch + h_sync_pulse + h_back_porch - 1;

constant v_display : integer := 480;
constant v_front_porch : integer := 10;
constant v_sync_pulse : integer := 2;
constant v_back_porch : integer := 33;
constant v_max : integer := v_display + v_front_porch + v_sync_pulse + v_back_porch - 1;

signal h_counter : integer range 0 to h_max := 0;
signal r_h_sync : std_logic := '0';

signal v_counter : integer range 0 to v_max := 0;
signal r_v_sync : std_logic := '0';

begin

counting : process(CLK25MHZ)
begin
	if rising_edge(CLK25MHZ) then
		if h_counter = h_max then
			h_counter <= 0;
			if v_counter = v_max then
				v_counter <= 0;
			else 
				v_counter <= v_counter + 1;
			end if;
		else 
			h_counter <= h_counter + 1;
		end if;
	end if;
end process;

X <= conv_std_logic_vector(h_counter, X'length);
Y <= conv_std_logic_vector(v_counter, Y'length);

synchro : process(CLK25MHZ)
begin 
	if rising_edge(CLK25MHZ) then
	
		if h_counter >= h_display + h_front_porch and h_counter < h_display + h_front_porch + h_sync_pulse then
			r_h_sync <= '0';
		else 
			r_h_sync <= '1';
		end if;
		
		if v_counter >= v_display + v_front_porch and v_counter < v_display + v_front_porch + v_sync_pulse then
			r_v_sync <= '0';
		else 
			r_v_sync <= '1';
		end if;
		
	end if;
end process;

H_SYNC <= r_h_sync;
V_SYNC <= r_v_sync;

end Behavioral;