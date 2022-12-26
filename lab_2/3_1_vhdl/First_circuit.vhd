-- First VHDL code for BME-393 Lab 
-- It implements three primitive gates of AND, OR, and NOT (inverter) 

library ieee;						-- Declare that you want to use IEEE libraries 
use ieee.std_logic_1164.all;	-- Library for standard logic circuits 
-- use ieee.numeric_std.all; 	-- Another useful library for UNSIGNED numbers 

entity First_circuit is 	-- entity definition 
	port( SW: 		in 	std_logic_vector(3 downto 0); 	
			LEDG:		out 	std_logic_vector(3 downto 0)		
			); 
end entity First_circuit; 

architecture main of First_circuit is 
signal a0, a1, b0, b1:	std_logic;
signal p0, p1, p2, p3: std_logic;
begin 
a0 <= SW(1 downto 0); 
a1 <= SW(1); 
b0 <= SW(2); 
b1 <= SW(3); 

p0 <= a0 and b0;
p1 <= ((a0 and b1) and (not (b0 and a1))) or ((not (a0 and b1)) and (b0 and a1));
p2 <= not (a0 and b0) and (a1 and b1);
p3 <= (a1 and b1) and (a0 and b0);

LEDG(0) <= p0; 
LEDG(1) <= p1; 
LEDG(2) <= p2; 
LEDG(3) <= p3; 
end architecture main; 