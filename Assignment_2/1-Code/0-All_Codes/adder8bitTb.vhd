library ieee;
use ieee.std_logic_1164.all;

entity adder8bitTb is
end entity;

architecture sim of adder8bitTb is

	-- Internal signals
	-- Inputs
	signal a 	: std_logic_vector(7 downto 0);
	signal b 	: std_logic_vector(7 downto 0);
	signal cin 	: std_logic;
	
	-- Outputs
	signal s	: std_logic_vector(7 downto 0);
	signal cout : std_logic;

begin

	adder8bit : entity work.adder8bit(rtl)
		port map(
			a 	 => a,
			b 	 => b, 
			cin  => cin,
			s 	 => s,
			cout => cout
		);
	
	process
	begin
		-- Different scenarios to test adder8bit.
		--Scenario 1:
		a <= "01010101";
		b <= "00110011";
		cin <= '0';
		wait for 250 ps;
		-- Expected: cout = 10001000
		--=======================================
		
		--Scenario 2:
		a <= "00000010";
		b <= "00000101";
		cin <= '1';
		wait for 250 ps;
		-- Expected: cout = 00001000
		--=======================================
		
		-- Scenario 3:
		a <= "11111111";
		b <= "00000001";
		cin <= '0';
		wait for 250 ps;
		-- Expected: cout = 00000000
		--=======================================
		
		-- Scenario 4:
		a <= "11111111";
		b <= "11111111";
		cin <= '1';
		wait for 250 ps;
		-- Expected: cout = 11111111
		
		wait; -- end simulation
	end process;	

end architecture;