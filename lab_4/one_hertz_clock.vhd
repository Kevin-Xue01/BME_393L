library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity one_hertz_clock is 
	port( 
			CLOCK_50_B5B:	in  std_logic ;    -- 50MHz clock on the board 
			LEDG:			out std_logic_vector(9 downto 0)
		); 
end entity one_hertz_clock; 


architecture one_hertz_clock_architecture of one_hertz_clock is 

signal counter: unsigned(24 downto 0); 
signal output: std_logic := '0';

begin 

counting: process (CLOCK_50_B5B)  
begin  
 if rising_edge(CLOCK_50_B5B) then  
  if (counter = to_unsigned(24999999, 25)) then   
   counter <= to_unsigned(0, 25);  
   output <= not output;  
  else  
   counter <= counter + 1;  
  end if;  
 end if;     
end process;

LEDG(0) <= output;

end architecture one_hertz_clock_architecture; 
