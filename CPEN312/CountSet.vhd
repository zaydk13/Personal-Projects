library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity CountSet is

	port
	(

	reset, clock, alarmset  : in  std_logic;
	KEY3, KEY2, KEY1, set	: in  std_logic;
	input							: in  std_logic_vector (3 downto 0);
	output						: out std_logic_vector (19 downto 0) := "11000000000000000000";
	AmPm							: out std_logic

	);

end CountSet;

architecture x of CountSet is

signal secLow, secHi, minLow, minHi, hour: std_logic_vector (3 downto 0);
signal meridiem: std_logic;
signal count: std_logic_vector (26 downto 0);
	
begin
	
	process(clock, reset, KEY3, KEY2, KEY1, alarmset, set, input)
	
	begin
	
	if (alarmset='0') then
	
		if (set='0') then
				
			if (clock'event and clock='1') then
							
				if (count>50000000) then
				
					count<=(others=>'0');

					if (secLow=9) then
						secLow<="0000";
						
						if (secHi=5) then
							secHi<="0000";
							
							if (minLow=9) then
								minLow<="0000";
								
								if (minHi=5) then
									minHi<="0000";
									
									if (hour=12) then
										hour<="0001";
										
									else
										hour<=hour+'1';
										
											if (hour=11) then
												meridiem<=not(meridiem);
											end if;
											
									end if;
									
								else
									minHi<=minHi+'1';
								end if;
	
							else
								minLow<=minLow+'1';
							end if;
						
						else
							secHi<=secHi+'1';
						end if;
					
					else
						secLow<=secLow+'1';	
					end if;
					
				else 
					count<=count+'1';	
				end if;
					
				if (reset='0') then
				
					secLow<="0000";
					secHi <="0000";
					minLow<="0000";
					minHi <="0000";
					hour 	<="1100";
					meridiem<='0';
					
				end if;
									
			end if;
		
		else
		
			if (KEY1='0') then
				
				if (input>9) then
					minLow<="0000";
				else
					minLow<=input;
				end if;
				
			elsif (KEY2='0') then
			
				if (input>5) then
					minHi<="0000";
				else
					minHi<=input;
				end if;
				
			elsif (KEY3='0') then
			
				if (input>12 or input=0) then
					hour<="1100";
					if (input=0) then
						meridiem<=not(meridiem);
					end if;
				else
					hour<=input;
				end if;
				
			end if;
		
		end if;
			
	end if;
							
	end process;
	
	
	process(secLow, secHi, minLow, minHi, hour, input)
	
	begin
		
		output(3 downto 0)<=secLow;
		output(7 downto 4)<=secHi;
		output(11 downto 8)<=minLow;
		output(15 downto 12)<=minHi;
		output(19 downto 16)<=hour;
		AmPm<=meridiem;
							
	end process;
		
end x;