library ieee;
use ieee.std_logic_1164.all;

entity aluTb is
	generic (n 	: integer := 8); -- This variable can change to reduce/increase the bits.
end entity;

architecture sim of aluTb is

	-- Internal signals	
	-- Inputs
	signal ac 	: std_logic_vector(n-1 downto 0);
	signal db 	: std_logic_vector(n-1 downto 0);
	signal alus : std_logic_vector(n-1 downto 1);
	
	-- Outputs
	signal dout : std_logic_vector(n-1 downto 0);
	
begin

	i_alu : entity work.alu(rtl)
		port map
		(
			ac   => ac,
			db 	 => db,
			alus => alus,
			dout => dout		
		);
	
	process
	begin
		
		ac <= "01001001";
		db <= "10011001";
		
		-- AND
		alus <= "1000000";
		wait for 250 ps;
		-- Expected Result: 00001001
		
		-- ==========================
		-- OR
		alus <= "1100000";
		wait for 250 ps;
		-- Expected Result: 11011001
	
		-- ==========================
		-- NOT
		alus <= "1110000";
		wait for 250 ps;
		-- Expected Result: 1010110
		
		-- ==========================
		-- XOR
		alus <= "1010000";
		wait for 250 ps;
		-- Expected Result: 11010000
		
		-- ==========================
		-- CLAC
		alus <= "0000000";
		wait for 250 ps;
		-- Expected Result: 00000000
		
		-- ==========================
		-- INAC
		alus <= "0001001";
		wait for 250 ps;
		-- Expected Result: 01001010
		
		-- ==========================
		-- ADD
		alus <= "0000101";
		wait for 250 ps;
		-- Expected Result: 11100010
		
		-- ==========================
		-- SUB
		alus <= "0001011";
		wait for 250 ps;
		-- Expected Result: 10110000
		
		-- ==========================
		-- MOV
		alus <= "0000100";
		wait for 250 ps;
		-- Expected Result: 10011001

		wait; -- End simulation
	end process;
end architecture;