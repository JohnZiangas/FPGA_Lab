library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--=========================================================
-- This component is a 2 to 1 mux which takes two unsigned
-- 8-bit numbers (Sig1, Sig2) and depending on the selector
-- (Sel), it passes the number the Sel is set at.
--=========================================================

entity mux2 is
	port(
		-- Inputs
		Sig1 : in std_logic_vector(7 downto 0);
		Sig2 : in std_logic_vector(7 downto 0);
		
		Sel  : in std_logic;
		
		-- Outputs
		Output : out std_logic_vector(7 downto 0)
	);
end entity;

architecture rtl of mux2 is
begin

	process(Sig1, Sig2, Sel) is 
	begin 
		
		-- 2to1 Mux logic.
		case Sel is 
			when '0' =>
				Output <= Sig1;
			when '1' => 
				Output <= Sig2;
			when others =>
				Output <= (others => 'X');
		end case;
	end process;

end architecture;