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


entity traffic_light_controller is 
	port( 
			CLOCK_50_B5B:	in  std_logic;    -- 50MHz clock on the board
			HEX0:    out std_logic_vector(6 downto 0);
			HEX3: 	out std_logic_vector(6 downto 0);
			LEDR:		out 	std_logic_vector(9 downto 0); 	-- Red LEDs 
			LEDG:		out 	std_logic_vector(7 downto 0)		-- Green LEDs 
		); 
end entity traffic_light_controller; 


architecture traffic_light_controller_architecture of traffic_light_controller is 

component clock_divider is
	port ( 	
				clock_in: in std_logic;
				num_of_rising_edges: in integer;
				clock_out: out std_logic
);
end component;

type light_state_enum is (f_green, s_green, f_red, s_red); 


signal light_state:  light_state_enum := f_green;
signal light_next_state:  light_state_enum := f_green;
signal light_state_encoding: std_logic_vector(1 downto 0);

type direction_state_enum is (NS, EW);  
signal direction_state:  direction_state_enum := NS;
signal direction_next_state:  direction_state_enum := NS;

signal fast_clock, slow_clock: std_logic;
signal time_counter: unsigned(2 downto 0) := "000";
signal state_encoding: std_logic_vector(3 downto 0);

begin 
fast_clock_inst: entity work.clock_divider(clock_divider_architecture) port map (CLOCK_50_B5B, 2500000, fast_clock); -- 10 Hz clock
slow_clock_inst: entity work.clock_divider(clock_divider_architecture) port map (fast_clock, 5, slow_clock); -- 1 Hz clock

hex0_inst: entity work.seven_segment(behavioral) port map ('0' & std_logic_vector(time_counter), '0', hex0);
hex3_inst: entity work.seven_segment(behavioral) port map (state_encoding, '0', hex3);

traffic_light_controller_next_state_process: process (slow_clock) 
begin  

if rising_edge(slow_clock) then 
	case light_state is 
		when f_green =>
			if time_counter = "001" then
				light_state <= s_green;
				time_counter <= "000";
			else 
				time_counter <= time_counter + 1;
			end if;
		when s_green => 
			if time_counter = "100" then
				light_state <= f_red;
				time_counter <= "000";
			else 
				time_counter <= time_counter + 1;
			end if;
		when f_red =>
			if time_counter = "010" then
				light_state <= s_red;
				time_counter <= "000";
			else 
				time_counter <= time_counter + 1;
			end if;
		when s_red =>	
			if time_counter = "000" then
				light_state <= f_green;
				time_counter <= "000";
				if direction_state = NS then
					direction_state <= EW;
				else 
					direction_state <= NS;
				end if;
			else 
				time_counter <= time_counter + 1;
			end if;
		when others => 
				null;
	end case; 
	
end if;  

end process; 

traffic_light_controller_state_encoding_process: process (light_state, direction_state)
begin
	case light_state is
		when f_green =>
			light_state_encoding <= "00";
		when s_green => 
			light_state_encoding <= "01";
		when f_red => 
			light_state_encoding <= "10";
		when others =>
			light_state_encoding <= "11";
	end case;
	case direction_state is
		when NS =>
			state_encoding <= "00" & light_state_encoding;
		when EW => 
			state_encoding <= "01" & light_state_encoding;
		when others =>
			state_encoding <= "1000";
	end case;
end process;	
	
with state_encoding select
		LEDG(7) <= fast_clock when "0000",
					  '1' when "0001",
					  '0' when others;
					  
with state_encoding select					  
		LEDR(0) <= fast_clock when "0010",
						'0' when "0000",
						'0' when "0001",
						'1' when others;
						
with state_encoding select						
		LEDG(4) <= fast_clock when "0100",
						'1' when "0101",
						'0' when others;
						
with state_encoding select						
		LEDR(4) <= fast_clock when "0110",
						'0' when "0100",
						'0' when "0101",
						'1' when others;
						
					

end architecture traffic_light_controller_architecture; 
