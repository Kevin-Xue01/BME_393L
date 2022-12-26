-- This code is half-written. To be completed by students. 
-- The goal is showing the value of data_in input on the segments_out output. 
--   ┌---a---┐
--   |       |
--   f       b
--   |       |
--   ├---g---┤
--   |       |
--   e       c
--   |       |
--   └---d---┘
-- Each segment of a, b, c, d, e, f, and g can be turned ON or OFF independently. 
-- The following line is from page 32 of the C5G_User_Manual document available on FPGA_Datasheets folder on LEARN. 
-- "Applying a low logic level to a segment will light it up and applying a high logic level turns it off." 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_segment is port(
			data_in:		in std_logic_vector(3 downto 0);	-- The 4 bit data to be displayed
			blank: 	in std_logic;
			data_out: out std_logic_vector(6 downto 0));	-- 7 bits out to a 7-segment display
end entity seven_segment;

architecture behavioral of seven_segment is
signal segments_out: std_logic_vector(6 downto 0);	-- 7 bits out to a 7-segment display
begin
		with blank & data_in select		-- seven-segment bits are 'a' to 'g'. The LSB is 'a' and MSB is 'g' 
								--   gfedcba
		data_out <=	"1000000" when "00000",		-- 0
									"1111001" when "00001",		-- 1
									"0100100" when "00010",		-- 2
									"0110000" when "00011",		-- 3
									"0011001" when "00100",		-- 4
									"0010010" when "00101",		-- 5
									"0000010" when "00110",		-- 6
									"1111000" when "00111",		-- 7
									"0000000" when "01000",		-- 8
									"0010000" when "01001",		-- 9 
									"0001000" when "01010",		-- a
									"0000011" when "01011",		-- b
									"1000110" when "01100",		-- c
									"0100001" when "01101",		-- d
									"0000110" when "01110",		-- e
									"0001110" when "01111",		-- f
									"1111111" when others; 	-- "1XXXX", blank		

end architecture behavioral;

-- ^^^ seven_segment entity and architecture declaration above ^^^
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity four_bit_adder is port(
			input_a:		in std_logic_vector(3 downto 0);	
			input_b: 	in std_logic_vector(3 downto 0);
			output_sum: 	out std_logic_vector(4 downto 0)
			);
end entity four_bit_adder;

architecture four_bit_adder_architecture of four_bit_adder is
begin
		output_sum <= std_logic_vector(('0' & unsigned(input_a(3 downto 0))) + ('0' & unsigned(input_b(3 downto 0))));
end architecture four_bit_adder_architecture;

-- ^^^ four_bit_adder entity and architecture declaration above ^^^
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity four_bit_multiplier is port(
			SW:		in std_logic_vector(7 downto 0);
			HEX3: 	out std_logic_vector(6 downto 0);
			HEX2: 	out std_logic_vector(6 downto 0);
			HEX1:    out std_logic_vector(6 downto 0);
			HEX0:    out std_logic_vector(6 downto 0)
			);
end entity four_bit_multiplier;

architecture four_bit_multiplier_architecture of four_bit_multiplier is

component seven_segment is port (
		data_in: in std_logic_vector(3 downto 0);
		blank: in std_logic;
		data_out: out std_logic_vector(6 downto 0)
);
end component;
component four_bit_adder is port(
			input_a:		in std_logic_vector(3 downto 0);	
			input_b: 	in std_logic_vector(3 downto 0);
			output_sum: 	out std_logic_vector(4 downto 0)
			);
end component four_bit_adder;

signal operand_1, operand_2: std_logic_vector(3 downto 0);
signal intermediate_1, intermediate_2, intermediate_3: std_logic_vector(4 downto 0);
signal product_0, product_1, product_2: std_logic;
signal four_bit_adder_inst_1_input_1, four_bit_adder_inst_1_input_2: std_logic_vector(3 downto 0);
signal four_bit_adder_inst_2_input_1, four_bit_adder_inst_2_input_2: std_logic_vector(3 downto 0);
signal four_bit_adder_inst_3_input_1, four_bit_adder_inst_3_input_2: std_logic_vector(3 downto 0);
signal hex2_input, hex3_input: std_logic_vector(3 downto 0);

begin

hex0_inst: entity work.seven_segment(behavioral) port map (SW(3 downto 0), '0', hex0);
hex1_inst: entity work.seven_segment(behavioral) port map (SW(7 downto 4), '0', hex1);
hex2_inst: entity work.seven_segment(behavioral) port map (hex2_input, '0', hex2);
hex3_inst: entity work.seven_segment(behavioral) port map (hex3_input, '0', hex3);	

four_bit_adder_inst_1: entity work.four_bit_adder(four_bit_adder_architecture) port map (four_bit_adder_inst_1_input_1, four_bit_adder_inst_1_input_2, intermediate_1);
four_bit_adder_inst_2: entity work.four_bit_adder(four_bit_adder_architecture) port map (four_bit_adder_inst_2_input_1, four_bit_adder_inst_2_input_2, intermediate_2);
four_bit_adder_inst_3: entity work.four_bit_adder(four_bit_adder_architecture) port map (four_bit_adder_inst_3_input_1, four_bit_adder_inst_3_input_2, intermediate_3);

Four_bit_multiplier_process: process (SW)
begin

operand_1 <= SW(3 downto 0);
operand_2 <= SW(7 downto 4);

product_0 <= operand_1(0) and operand_2(0);

four_bit_adder_inst_1_input_1 <= '0' & (operand_1(3) and operand_2(0)) & (operand_1(2) and operand_2(0)) & (operand_1(1) and operand_2(0));
four_bit_adder_inst_1_input_2 <= ((operand_1(3) and operand_2(1)) & (operand_1(2) and operand_2(1)) & (operand_1(1) and operand_2(1)) & (operand_1(0) and operand_2(1)));

product_1 <= intermediate_1(0);
		
four_bit_adder_inst_2_input_1 <= intermediate_1(4 downto 1);
four_bit_adder_inst_2_input_2 <= ((operand_1(3) and operand_2(2)) & (operand_1(2) and operand_2(2)) & (operand_1(1) and operand_2(2)) & (operand_1(0) and operand_2(2)));

product_2 <= intermediate_2(0);
		
four_bit_adder_inst_3_input_1 <= intermediate_2(4 downto 1);
four_bit_adder_inst_3_input_2 <= ((operand_1(3) and operand_2(3)) & (operand_1(2) and operand_2(3)) & (operand_1(1) and operand_2(3)) & (operand_1(0) and operand_2(3)));
		
hex2_input <= (intermediate_3(0) & product_2 & product_1 & product_0); 
hex3_input <= intermediate_3(4 downto 1);
		
end process;

end architecture four_bit_multiplier_architecture;



