library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--===================================================
-- This is the test bench to test the mux4 component.
-- To test it, use ModelSim.
--===================================================

entity mux4Tb is
end entity;

architecture sim of mux4Tb is

    signal Sig1 : std_logic_vector(7 downto 0) 	:= x"AA";
    signal Sig2 : std_logic_vector(7 downto 0) 	:= x"BB";
	signal Sig3 : std_logic_vector(7 downto 0) 	:= x"CC";
    signal Sig4 : std_logic_vector(7 downto 0) 	:= x"DD";
    
    signal Sel : std_logic_vector(1 downto 0) 	:= (others => '0');
    
    signal Output : std_logic_vector(7 downto 0);

begin

    i_Mux4 : entity work.mux4(rtl) port map
    (
        Sel   	=> Sel,
        Sig1  	=> Sig1,
        Sig2   	=> Sig2,
		Sig3 	=> Sig3,
		Sig4 	=> Sig4,
        Output 	=> Output
    );

    process
    begin
	
		Sel <= "00";
		wait for 250 ps;
		
		Sel <= "01";
		wait for 250 ps;
		
		Sel <= "10";
		wait for 250 ps;
		
		Sel <= "11";
		wait for 250 ps;
		
		Sel <= "00";
		wait for 250 ps;
		wait; 				-- End simulation.
    end process;

end architecture;
