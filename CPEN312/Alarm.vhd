library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Alarm is

	port
	(

	reset, alarmset, alarmON, AmIn : in  std_logic;
	KEY3, KEY2, KEY1, set			 : in  std_logic;
	number								 : in  std_logic_vector (3 downto 0);
	input									 : in  std_logic_vector (19 downto 0) := "11000000000000000000";
	AmPm, alarm					  		 : out std_logic;
	output								 : out std_logic_vector (19 downto 0) := "11000000000000000000"

	);

end Alarm;


architecture x of Alarm is

signal secLow, secHi, minLow, minHi, hour: std_logic_vector (3 downto 0);
signal meridiem: std_logic;


begin

	process (reset, alarmset, KEY3, KEY2, KEY1, set, input, number)
	
	begin
	
		if (alarmset='1') then
		
			if (set='1') then
		
				if (KEY1='0') then
					
					if (number>9) then
						minLow<="0000";
					else
						minLow<=number;
					end if;
					
				elsif (KEY2='0') then
				
					if (number>5) then
						minHi<="0000";
					else
						minHi<=number;
					end if;
					
				elsif (KEY3='0') then
				
					if (number>12 or number=0) then
						hour<="1100";
						if (number=0) then
						meridiem<=not(meridiem);
						end if;
					else
						hour<=number;
					end if;
					
				end if;
				
			end if;
			
			output(3 downto 0)<=secLow;
			output(7 downto 4)<=secHi;
			output(11 downto 8)<=minLow;
			output(15 downto 12)<=minHi;
			output(19 downto 16)<=hour;
			AmPm<=meridiem;
				
		else
		
			output(3 downto 0)<=input(3 downto 0);
			output(7 downto 4)<=input(7 downto 4);
			output(11 downto 8)<=input(11 downto 8);
			output(15 downto 12)<=input(15 downto 12);
			output(19 downto 16)<=input(19 downto 16);
			AmPm<=AmIn;
			
		end if;
					
	end process;
	
	process (alarmON, input)
	
	begin
	
	if (alarmON='1') and (input(11 downto 8)=minLow) and (input(15 downto 12)=minHi) and (input(19 downto 16)=hour) then
		alarm<='1';
		
	else
	
		alarm<='0';
		
	end if;
		
	end process;
	
end x;
	
	
	