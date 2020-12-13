library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

library system;

library common;
use common.rgb_p.all;

entity project_main_arty_z7 is 
	port (
		CLOCK_IN 			: in std_logic;
		PUSHBUTTON_IN : in std_logic_vector(3 downto 0); 
		DIPSWITCH_IN  : in std_logic_vector(1 downto 0);
		CK_IN         : in std_logic_vector(41 downto 0);

		CK_OUT        : out std_logic_vector(41 downto 0);
		CK_EN         : out std_logic_vector(41 downto 0);
		LED_OUT 			: out std_logic_vector(3 downto 0);
		RGB_OUT 			: out rgb_array_t(4 to 5)
	);
end project_main_arty_z7; 

architecture RTL of project_main_arty_z7 is
	signal pb_debounced : std_logic_vector(PUSHBUTTON_IN'range) := (others => '0');
	signal sw_debounced : std_logic_vector(DIPSWITCH_IN'range) := (others => '0');
	signal rgb_o 				: rgb_array_t(RGB_OUT'range) := (others => cDEFAULT_RGB);
	signal led_o 				: std_logic_vector(LED_OUT'range) := (others => '0');
begin



end RTL;