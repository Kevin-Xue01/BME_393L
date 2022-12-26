library ieee;						-- Declare that you want to use IEEE libraries 
use ieee.std_logic_1164.all;	-- Library for standard logic circuits 
use ieee.numeric_std.all; 	-- Another useful library for UNSIGNED numbers 

entity First_circuit is 	-- entity definition 
	port( SW: 		in 	std_logic_vector(9 downto 0); 	-- Toggle switches 
			LEDG:		out 	std_logic_vector(4 downto 0)		-- Green LEDs 
			); 
end entity First_circuit; 

architecture main of First_circuit is 
signal a, b:	unsigned(3 downto 0);
signal c:	unsigned(4 downto 0);	-- Naming inputs 
begin 
a <= unsigned(SW(3 downto 0));  
b <= unsigned(SW(9 downto 6));  
c <= ('0' & a) + ('0' & b);

LEDG(4 downto 0) <= std_logic_vector(c);
end architecture main; 