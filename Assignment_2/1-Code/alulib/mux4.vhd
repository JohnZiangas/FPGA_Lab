library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--=========================================================
-- This component is a 4 to 1 mux which takes two unsigned
-- 8-bit numbers (Sig1, Sig2) and depending on the selector
-- (Sel), it passes the number the Sel is set at.
--=========================================================

entity mux4 is
	port(
		-- Inputs
		Sig1 	: in std_logic_vector(7 downto 0);
		Sig2 	: in std_logic_vector(7 downto 0);
		Sig3 	: in std_logic_vector(7 downto 0);
		Sig4 	: in std_logic_vector(7 downto 0);
		
		Sel  	: in std_logic_vector(1 downto 0);
		
		-- Outputs
		Output 	: out std_logic_vector(7 downto 0)
	);
end entity;

architecture rtl of mux4 is
begin

	process(Sig1, Sig2, Sig3, Sig4, Sel) is 
	begin 
		
		-- 4to1 Mux logic.
		case Sel is 
			when "00" =>
				Output <= Sig1;
			when "01" => 
				Output <= Sig2;
			when "10" =>
				Output <= Sig3;
			when "11" =>
				Output <= Sig4;
			when others =>
				Output <= (others => 'X');
		end case;
	end process;

end architecture;