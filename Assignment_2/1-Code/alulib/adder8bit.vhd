library ieee;
use ieee.std_logic_1164.all;

entity adder8bit is
	port(
		-- Inputs
		a 	 : in std_logic_vector(7 downto 0);
		b 	 : in std_logic_vector(7 downto 0);
		cin  : in std_logic;
		
		-- Outputs
        s    : out std_logic_vector(7 downto 0);
        cout : out std_logic
	);
	
end entity;

architecture rtl of adder8bit is

	-- Internal signal
	signal carry : std_logic_vector(7 downto 0);

begin

	FA0: entity work.adder1bit
		port map(
			a 	 => a(0),
			b 	 => b(0),
			cin  => cin,
			s 	 => s(0),
			cout => carry(0)		
		);
	
	FA1: entity work.adder1bit
		port map(
			a 	 => a(1),
			b 	 => b(1),
			cin  => carry(0),
			s 	 => s(1),
			cout => carry(1)		
		);
	
	FA2: entity work.adder1bit
		port map(
			a 	 => a(2),
			b 	 => b(2),
			cin  => carry(1),
			s 	 => s(2),
			cout => carry(2)		
		);
	
	FA3: entity work.adder1bit
		port map(
			a 	 => a(3),
			b 	 => b(3),
			cin  => carry(2),
			s 	 => s(3),
			cout => carry(3)		
		);
	
	FA4: entity work.adder1bit
		port map(
			a 	 => a(4),
			b 	 => b(4),
			cin  => carry(3),
			s 	 => s(4),
			cout => carry(4)		
		);
		
	FA5: entity work.adder1bit
		port map(
			a 	 => a(5),
			b 	 => b(5),
			cin  => carry(4),
			s 	 => s(5),
			cout => carry(5)		
		);
	
	FA6: entity work.adder1bit
		port map(
			a 	 => a(6),
			b 	 => b(6),
			cin  => carry(5),
			s 	 => s(6),
			cout => carry(6)		
		);
	
	FA7: entity work.adder1bit
		port map(
			a 	 => a(7),
			b 	 => b(7),
			cin  => carry(6),
			s 	 => s(7),
			cout => cout		
		);
	
end architecture;