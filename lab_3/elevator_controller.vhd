library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity elevator_controller is port(
			SW: in std_logic_vector(9 downto 0);
			LEDG: 	out std_logic_vector(4 downto 0);
			LEDR: 	out std_logic_vector(4 downto 0)
			);
end entity elevator_controller;

architecture elevator_controller_architecture of elevator_controller is
signal a,b,y,z: std_logic;
begin
		a <= SW(1);
		b <= SW(0);
		y <= SW(9);
		z <= SW(8);
		LEDR(0) <= (a and z and (not b or not y)) or (b and y and (not a or not z));
		LEDG(0) <= (not a or (y and z));

end architecture elevator_controller_architecture;
