library ieee;						-- Declare that you want to use IEEE libraries 
use ieee.std_logic_1164.all;	-- Library for standard logic circuits 
use ieee.numeric_std.all; 	-- Another useful library for UNSIGNED numbers 

entity First_circuit is 	-- entity definition 
	port( SW: 		in 	std_logic_vector(7 downto 0); 	-- Toggle switches 
			LEDG:		out 	std_logic_vector(7 downto 0)		-- Green LEDs 
			); 
end entity First_circuit; 

architecture main of First_circuit is 
signal input_a:	std_logic_vector(3 downto 0);-- Naming inputs 
signal input_b:	std_logic_vector(3 downto 0);-- Naming inputs 
signal intermediate_0: unsigned(7 downto 0);
signal intermediate_1: unsigned(7 downto 0);
signal intermediate_2: unsigned(7 downto 0);
signal intermediate_3: unsigned(7 downto 0);
begin

input_a <= SW(3 downto 0);
input_b <= SW(7 downto 4);

intermediate_0(0) <= input_a(0) and input_b(0);
intermediate_0(1) <= input_a(1) and input_b(0);
intermediate_0(2) <= input_a(2) and input_b(0);
intermediate_0(3) <= input_a(3) and input_b(0);

intermediate_1(1) <= input_a(0) and input_b(1);
intermediate_1(2) <= input_a(1) and input_b(1);
intermediate_1(3) <= input_a(2) and input_b(1);
intermediate_1(4) <= input_a(3) and input_b(1);

intermediate_2(2) <= input_a(0) and input_b(2);
intermediate_2(3) <= input_a(1) and input_b(2);
intermediate_2(4) <= input_a(2) and input_b(2);
intermediate_2(5) <= input_a(3) and input_b(2);

intermediate_3(3) <= input_a(0) and input_b(3);
intermediate_3(4) <= input_a(1) and input_b(3);
intermediate_3(5) <= input_a(2) and input_b(3);
intermediate_3(6) <= input_a(3) and input_b(3);

LEDG <= std_logic_vector(intermediate_0 + intermediate_1 + intermediate_2 + intermediate_3);

end architecture main;