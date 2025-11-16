library ieee;
use ieee.std_logic_1164.all;

entity adder1bit is
    port(
		-- Inputs
        a    : in std_logic;
        b    : in std_logic;
        cin  : in std_logic;
		
		-- Outputs
        s    : out std_logic;
        cout : out std_logic
    );
end entity;

architecture rtl of adder1bit is
begin
	
	-- calculating sum and carry out
	s    <= a xor b xor cin;                         -- sum bit
	cout <= (a and b) or (a and cin) or (b and cin); -- carry out bit
	
end architecture;
