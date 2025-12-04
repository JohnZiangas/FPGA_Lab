library ieee;
use ieee.std_logic_1164.all;

entity decoder_genericTb is
end entity;

architecture sim of decoder_genericTb is

	signal ir 	  : std_logic_vector(3 downto 0);
	signal ir_out : std_logic_vector(15 downto 0);
	signal state_counter : std_logic_vector(2 downto 0);
	signal state_out : std_logic_vector(7 downto 0);
	
begin

	i_Decoder4to16 : entity work.decoder_generic(rtl)
		generic map(
			INPUT_WIDTH  => 4,
			OUTPUT_WIDTH => 16
		)
		port map(
			din  => ir,
			dout => ir_out
		);
		
	i_Decoder3to8 : entity work.decoder_generic(rtl)
		generic map(
			INPUT_WIDTH  => 3,
			OUTPUT_WIDTH => 8
		)
		port map(
			din  => state_counter,
			dout => state_out
		);
	
	process is 
	begin
		
		ir 			  <= "0000"; -- INOP
		state_counter <= "000";  -- T0
		wait for 100 ps;
		
		--============================
		ir 			  <= "0001"; -- ILDAC
		state_counter <= "001";  -- T1
		wait for 100 ps;
		
		--============================
		
		ir 			  <= "0110"; -- IINAC
		state_counter <= "010";  -- T2
		wait for 100 ps;

		--============================
		ir 			  <= "1001"; -- ASUB
		state_counter <= "011";  -- T3
		wait for 100 ps;
	
		--============================
		ir 			  <= "0101"; -- IJUMP
		state_counter <= "100";  -- T4
		wait for 100 ps;
		
		--============================
		ir 			  <= "0111"; -- IJPNZ
		state_counter <= "101";  -- T5
		wait for 100 ps;
		
		--============================
		ir 			  <= "1111"; -- INOT
		state_counter <= "110";  -- T6
		wait for 100 ps;
		
		--============================
		ir 			  <= "1110"; -- IXOR
		state_counter <= "111";  -- T7
		wait for 100 ps;
		
		wait; -- stop simulation
	end process;
end architecture;