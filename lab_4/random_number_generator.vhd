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

architecture seven_segment_architecture of seven_segment is
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

end architecture seven_segment_architecture;

-- ^^^ seven_segment entity and architecture declaration above ^^^
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity random_number_generator is port(
			CLOCK_50_B5B:	in  std_logic ;    -- 50MHz clock on the board 
			KEY:		in  std_logic_vector(3 downto 0);
			HEX3: 	out std_logic_vector(6 downto 0);
			HEX2: 	out std_logic_vector(6 downto 0);
			HEX1:    out std_logic_vector(6 downto 0);
			HEX0:    out std_logic_vector(6 downto 0)
			);
end entity random_number_generator;

architecture random_number_generator_architecture of random_number_generator is

component seven_segment is port (
		data_in: in std_logic_vector(3 downto 0);
		blank: in std_logic;
		data_out: out std_logic_vector(6 downto 0)
);
end component;

signal rndm: unsigned(7 downto 0);
signal prev_rndm: unsigned(7 downto 0);
signal hex0_input, hex1_input, hex2_input, hex3_input: std_logic_vector(3 downto 0);
signal blank_prev_rndm: std_logic := '1';
signal blank_rndm: std_logic := '1';

begin

hex0_inst: entity work.seven_segment(seven_segment_architecture) port map (hex0_input, blank_rndm, hex0);
hex1_inst: entity work.seven_segment(seven_segment_architecture) port map (hex1_input, blank_rndm, hex1);
hex2_inst: entity work.seven_segment(seven_segment_architecture) port map (hex2_input, blank_prev_rndm, hex2);
hex3_inst: entity work.seven_segment(seven_segment_architecture) port map (hex3_input, blank_prev_rndm, hex3);

rndm <= rndm + 1 when rising_edge(CLOCK_50_B5B);

rng_process: process (KEY(0))
begin

if rising_edge(KEY(0)) then
	if blank_rndm = '0' then
		blank_prev_rndm <= '0';
		hex3_input <= std_logic_vector(prev_rndm)(7 downto 4); 
		hex2_input <= std_logic_vector(prev_rndm)(3 downto 0); 
	else
		blank_rndm <= '0';
	end if;
	hex1_input <= std_logic_vector(rndm)(7 downto 4); 
	hex0_input <= std_logic_vector(rndm)(3 downto 0);
	prev_rndm <= rndm;
	
end if;

		
end process;

end architecture random_number_generator_architecture;



