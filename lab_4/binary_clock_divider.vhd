library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity binary_clock_divider is 
	port( 
			CLOCK_50_B5B:	in  std_logic ;    -- 50MHz clock on the board 
			LEDR:			out std_logic_vector(9 downto 0)
		); 
end entity binary_clock_divider; 


architecture binary_clock_divider_architecture of binary_clock_divider is 

signal counter: unsigned(29 downto 0); 

begin 

counter <= counter + 1 when rising_edge(CLOCK_50_B5B);
LEDR <= std_logic_vector(counter)(29 downto 20);

end architecture binary_clock_divider_architecture; 
