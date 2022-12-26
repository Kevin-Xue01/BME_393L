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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
  
entity clock_divider is
	port ( 	
				clock_in: in std_logic;
				num_of_rising_edges: in integer;
				clock_out: out std_logic
);
end clock_divider;
  
architecture clock_divider_architecture of clock_divider is
  
signal counter: integer := 1;
signal output : std_logic := '0';
  
begin
  
Clock_divider_process: process(clock_in)
begin

if rising_edge(clock_in) then
	if (counter = num_of_rising_edges) then
       output <= not output;
       counter <= 0;
   else
       counter <= counter + 1;
   end if;
end if;
clock_out <= output;
end process;
  
end clock_divider_architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity reaction_time_calculator is 
	port( 
			CLOCK_50_B5B:	in  std_logic;    -- 50MHz clock on the board
			KEY: 		in 	std_logic_vector(3 downto 0); 	-- Push buttons 
			HEX0:    out std_logic_vector(6 downto 0);
			HEX1: 	out std_logic_vector(6 downto 0);
			HEX2: 	out std_logic_vector(6 downto 0);
			HEX3: 	out std_logic_vector(6 downto 0)
		); 
end entity reaction_time_calculator; 


architecture reaction_time_calculator_architecture of reaction_time_calculator is 

component clock_divider is
	port ( 	
				clock_in: in std_logic;
				num_of_rising_edges: in integer;
				clock_out: out std_logic
);
end component;

type reaction_time_calculator_state_enum is (idle, key0_initiated, key1_initiated, finished_calculation); 
signal current_reaction_time_calculator_state:  reaction_time_calculator_state_enum := idle;
signal clock: std_logic;
signal time_counter_previous: unsigned(15 downto 0) := "0000000000000000";
signal time_counter_current: unsigned(15 downto 0) := "0000000000000000";
signal blank: std_logic := '1';
begin 
clock_inst: entity work.clock_divider(clock_divider_architecture) port map (CLOCK_50_B5B, 25000, clock); -- 1000 Hz clock

hex0_inst: entity work.seven_segment(behavioral) port map (std_logic_vector(time_counter_previous(3 downto 0)), blank, hex0);
hex1_inst: entity work.seven_segment(behavioral) port map (std_logic_vector(time_counter_previous(7 downto 4)), blank, hex1);
hex2_inst: entity work.seven_segment(behavioral) port map (std_logic_vector(time_counter_previous(11 downto 8)), blank, hex2);
hex3_inst: entity work.seven_segment(behavioral) port map (std_logic_vector(time_counter_previous(15 downto 12)), blank, hex3);

reaction_time_calculator_next_state_process: process (KEY, clock) 
begin  
if rising_edge(clock) then
	case current_reaction_time_calculator_state is 
		when key0_initiated =>
			if KEY(1) = '0' then
				current_reaction_time_calculator_state <= finished_calculation;
				time_counter_previous <= time_counter_current;
				time_counter_current <= "0000000000000000";
				blank <= '0';
			else 
				time_counter_current <= time_counter_current + 1;
			end if;
		when key1_initiated => 
			if KEY(0) = '0' then
				current_reaction_time_calculator_state <= finished_calculation;
				time_counter_previous <= time_counter_current;
				time_counter_current <= "0000000000000000";
				blank <= '0';
			else 
				time_counter_current <= time_counter_current + 1;
			end if;
		when idle =>	
			if KEY(0) = '0' then
				current_reaction_time_calculator_state <= key0_initiated;
			elsif KEY(1) = '0' then
				current_reaction_time_calculator_state <= key1_initiated;
			else 
				null;
			end if;
		when finished_calculation =>	
			if KEY(0) = '1' and KEY(1) = '1' then
				current_reaction_time_calculator_state <= idle;
			else 
				null;
			end if;
	end case; 	
end if;

end process; 	
					
end architecture reaction_time_calculator_architecture; 
