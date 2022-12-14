-- First VHDL code for BME-393 Lab 
-- It implements three primitive gates of AND, OR, and NOT (inverter) 

library ieee;						-- Declare that you want to use IEEE libraries 
use ieee.std_logic_1164.all;	-- Library for standard logic circuits 
-- use ieee.numeric_std.all; 	-- Another useful library for UNSIGNED numbers 

entity First_circuit is 	-- entity definition 
	port( KEY: 		in 	std_logic_vector(3 downto 0); 	-- Push buttons 
			SW: 		in 	std_logic_vector(9 downto 0); 	-- Toggle switches 
			LEDR:		out 	std_logic_vector(9 downto 0); 	-- Red LEDs 
			LEDG:		out 	std_logic_vector(7 downto 0)		-- Green LEDs 
			); 
end entity First_circuit; 

architecture main of First_circuit is 
signal a, b, c, d, e, f:	std_logic;	-- Naming inputs 
signal and_out: 				std_logic;	-- AND gate output for reading by XOR gate  
signal or_out: 				std_logic;	-- OR gate output for reading by XOR gate 

begin 
a <= SW(0); 
b <= SW(1); 
c <= SW(8); 
d <= SW(9); 
e <= KEY(0); 

and_out <= a and b; 
or_out <= c or d; 
LEDR(0) <= and_out; 
LEDR(9) <= or_out; 
LEDG(0) <= not KEY(0); 
LEDG(5) <= and_out xor or_out; 
end architecture main;