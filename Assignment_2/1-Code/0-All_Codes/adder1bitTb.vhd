library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--===================================================
-- This is the test bench to test the mux2 component.
-- To test it, use ModelSim.
--===================================================

entity adder1bitTb is
end entity;

architecture sim of adder1bitTb is

    signal a : std_logic;
    signal b : std_logic;
    
    signal cin : std_logic;
    
    signal s : std_logic;
	signal cout : std_logic;

begin

    i_Adder1bit : entity work.adder1bit(rtl) port map
    (
		a => a,
		b => b,
		cin => cin,
		s => s, 
		cout => cout
    );

    process
    begin
		
		-- Testing different scenarios
		a <= '0';
		b <= '0';
		cin <= '1';
		wait for 250 ps;
		
		--============================
		a <= '0';
		b <= '1';
		cin <= '0';
		wait for 250 ps;
		
		a <= '0';
		b <= '1';
		cin <= '1';
		wait for 250 ps;
		
		--============================
		a <= '1';
		b <= '0';
		cin <= '0';
		wait for 250 ps;
		
		a <= '1';
		b <= '0';
		cin <= '1';
		wait for 250 ps;
		
		--=============================
		a <= '1';
		b <= '1';
		cin <= '0';
		wait for 250 ps;
		
		a <= '1';
		b <= '1';
		cin <= '1';
		wait for 250 ps;
        
        wait;  -- stop simulation
    end process;

end architecture;
