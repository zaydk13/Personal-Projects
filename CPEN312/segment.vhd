library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity segment is

	port
	(

	input							: in  std_logic_vector (19 downto 0) := "11000000000000000000";
	hex0, hex1, hex2, hex3	: out std_logic_vector (6 downto 0) := "0000001";
	hex4							: out std_logic_vector (6 downto 0) := "0010010";
	hex5							: out std_logic_vector (6 downto 0) := "1001111"

	);

end segment;


architecture x of segment is

begin

	process (input)
	
	begin
	
		case input(3 downto 0) is
			when "0000" => hex0 <= "0000001";
			when "0001" => hex0 <= "1001111";
			when "0010" => hex0 <= "0010010";
			when "0011" => hex0 <= "0000110";
			when "0100" => hex0 <= "1001100";
			when "0101" => hex0 <= "0100100";
			when "0110" => hex0 <= "0100000";
			when "0111" => hex0 <= "0001111";
			when "1000" => hex0 <= "0000000";
			when "1001" => hex0 <= "0000100";
			when others => hex0 <= "1111111";
		end case;
		
		case input(7 downto 4) is
			when "0000" => hex1 <= "0000001";
			when "0001" => hex1 <= "1001111";
			when "0010" => hex1 <= "0010010";
			when "0011" => hex1 <= "0000110";
			when "0100" => hex1 <= "1001100";
			when "0101" => hex1 <= "0100100";
			when "0110" => hex1 <= "0100000";
			when "0111" => hex1 <= "0001111";
			when "1000" => hex1 <= "0000000";
			when "1001" => hex1 <= "0000100";
			when others => hex1 <= "1111111";
		end case;
		
		case input(11 downto 8) is
			when "0000" => hex2 <= "0000001";
			when "0001" => hex2 <= "1001111";
			when "0010" => hex2 <= "0010010";
			when "0011" => hex2 <= "0000110";
			when "0100" => hex2 <= "1001100";
			when "0101" => hex2 <= "0100100";
			when "0110" => hex2 <= "0100000";
			when "0111" => hex2 <= "0001111";
			when "1000" => hex2 <= "0000000";
			when "1001" => hex2 <= "0000100";
			when others => hex2 <= "1111111";
		end case;
		
		case input(15 downto 12) is
			when "0000" => hex3 <= "0000001";
			when "0001" => hex3 <= "1001111";
			when "0010" => hex3 <= "0010010";
			when "0011" => hex3 <= "0000110";
			when "0100" => hex3 <= "1001100";
			when "0101" => hex3 <= "0100100";
			when "0110" => hex3 <= "0100000";
			when "0111" => hex3 <= "0001111";
			when "1000" => hex3 <= "0000000";
			when "1001" => hex3 <= "0000100";
			when others => hex3 <= "1111111";
		end case;
		
		case input(19 downto 16) is
			when "0000" => hex4 <= "0000001";
			when "0001" => hex4 <= "1001111";
			when "0010" => hex4 <= "0010010";
			when "0011" => hex4 <= "0000110"; --& hex5 <= "0000001";
			when "0100" => hex4 <= "1001100"; --& hex5 <= "0000001";
			when "0101" => hex4 <= "0100100"; --& hex5 <= "0000001";
			when "0110" => hex4 <= "0100000"; --& hex5 <= "0000001";
			when "0111" => hex4 <= "0001111"; --& hex5 <= "0000001";
			when "1000" => hex4 <= "0000000"; --& hex5 <= "0000001";
			when "1001" => hex4 <= "0000100"; --& hex5 <= "0000001";
			when "1010" => hex4 <= "0000001"; --& hex5 <= "1001111";
			when "1011" => hex4 <= "1001111"; --& hex5 <= "1001111";
			when "1100" => hex4 <= "0010010"; --& hex5 <= "1001111";
			when others => hex4 <= "1111111";
		end case;
		
		case input(19 downto 16) is
			when "0000" => hex5 <= "0000001";
			when "0001" => hex5 <= "0000001";
			when "0010" => hex5 <= "0000001";
			when "0011" => hex5 <= "0000001";
			when "0100" => hex5 <= "0000001";
			when "0101" => hex5 <= "0000001";
			when "0110" => hex5 <= "0000001";
			when "0111" => hex5 <= "0000001";
			when "1000" => hex5 <= "0000001";
			when "1001" => hex5 <= "0000001";
			when "1010" => hex5 <= "1001111";
			when "1011" => hex5 <= "1001111";
			when "1100" => hex5 <= "1001111";
			when others => hex5 <= "1111111";
		end case;
		
	end process;
	
end x;
	