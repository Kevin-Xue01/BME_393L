library ieee;						-- Declare that you want to use IEEE libraries 
use ieee.std_logic_1164.all;	-- Library for standard logic circuits 
-- use ieee.numeric_std.all; 	-- Another useful library for UNSIGNED numbers 

entity First_circuit is 	-- entity definition 
	port( SW: 		in 	std_logic_vector(3 downto 0); 	-- Toggle switches 
			LEDG:		out 	std_logic_vector(2 downto 0)		-- Green LEDs 
			); 
end entity First_circuit; 

architecture main of First_circuit is 
signal sw_input:	std_logic_vector(3 downto 0);	-- Naming inputs 
signal intermediate:	std_logic_vector(3 downto 0);	-- Naming inputs 
signal first_bit_out:	std_logic;	-- output first bit -> value * 2^0
signal second_bit_out: 	std_logic;	-- output second bit -> value * 2^1
signal third_bit_out: 	std_logic;	-- output third bit -> value * 2^2

begin 
sw_input(0) <= SW(0); 
sw_input(1) <= SW(1); 
sw_input(2) <= SW(2); 
sw_input(3) <= SW(3); 
 
intermediate(0) <= sw(0) and sw(2);
intermediate(1) <= sw(1) xor sw(3);
intermediate(2) <= sw(1) and sw(3);
intermediate(3) <= intermediate(0) and intermediate(1);

first_bit_out <= sw(0) xor sw(2);
second_bit_out <= intermediate(0) xor intermediate(1);
third_bit_out <= intermediate(2) or intermediate(3);

LEDG(0) <= first_bit_out; 
LEDG(1) <= second_bit_out; 
LEDG(2) <= third_bit_out; 
end architecture main;