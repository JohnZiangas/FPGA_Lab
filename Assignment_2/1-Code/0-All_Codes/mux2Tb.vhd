library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--===================================================
-- This is the test bench to test the mux2 component.
-- To test it, use ModelSim.
--===================================================

entity mux2Tb is
end entity;

architecture sim of mux2Tb is

    signal Sig1 : std_logic_vector(7 downto 0) := x"AA";
    signal Sig2 : std_logic_vector(7 downto 0) := x"BB";
    
    signal Sel : std_logic := '0';
    
    signal Output : std_logic_vector(7 downto 0);

begin

    i_Mux2 : entity work.mux2(rtl) port map
    (
        Sel    => Sel,
        Sig1   => Sig1,
        Sig2   => Sig2,
        Output => Output
    );

    process
    begin
        Sel <= '0';
        wait for 500 ps;
        
        Sel <= '1';
        wait for 250 ps;
		
		Sel <= '0';
		wait for 250 ps;
		
		Sel <= '1';
		wait for 500 ps;
        
        wait;  -- stop simulation
    end process;

end architecture;
