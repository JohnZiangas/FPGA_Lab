library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity alu is
    generic (n : integer := 8); -- This variable can change to reduce/increase the bits.
    port (
        ac    : in std_logic_vector(n-1 downto 0);
        db    : in std_logic_vector(n-1 downto 0);
        alus  : in std_logic_vector(7 downto 1);
        dout  : out std_logic_vector(n-1 downto 0)
    );
end alu;

architecture rtl of alu is

	-- Internal signals
	signal mux2_out1 : std_logic_vector(n-1 downto 0);
	signal mux2_out2 : std_logic_vector(n-1 downto 0);
	signal mux4_out1 : std_logic_vector(n-1 downto 0);
	signal mux4_out2 : std_logic_vector(n-1 downto 0);
	signal adder_out : std_logic_vector(n-1 downto 0);
	
	-- Logic signals
	signal and_out : std_logic_vector(n-1 downto 0);
	signal or_out  : std_logic_vector(n-1 downto 0);
	signal xor_out : std_logic_vector(n-1 downto 0);
	signal not_out : std_logic_vector(n-1 downto 0);
	
	-- Inverted signals
	signal db_inv  : std_logic_vector(n-1 downto 0);

begin

	-- Here we begin to write the main code.

	-- Logic Unit outputs
	and_out <= ac and db;
	or_out  <= ac or db;
	xor_out <= ac xor db;
	not_out <= not(ac);
	
	-- Inverted db signal
	db_inv 	<= not(db);

	-- Arithmetic Unit
	i_Mux2_AU: entity work.mux2(rtl)
		port map(
			Sig1 	=> (others => '0'),
			Sig2 	=> ac,
			Sel 	=> alus(1),
			Output 	=> mux2_out1
		);
		
	i_Mux4_AU: entity work.mux4(rtl)
		port map(
			Sig1 	=> (others => '0'),
			Sig2 	=> (others => '0'),
			Sig3 	=> db,
			Sig4 	=> db_inv,
			Sel 	=> alus(3 downto 2),
			Output 	=> mux4_out1
		);
	
	i_adder8bit_AU: entity work.adder8bit(rtl)
		port map(
			a 	 	=> mux2_out1,
			b 	 	=> mux4_out1,
			cin  	=> alus(4),
			s 		=> adder_out,
			cout 	=> open
		);
	
	-- Logic Unit
	i_Mux4_LU: entity work.mux4(rtl)
		port map(
			Sig1 	=> and_out,
			Sig2 	=> xor_out,
			Sig3 	=> or_out,
			Sig4 	=> not_out,
			Sel 	=> alus(6 downto 5),
			Output 	=> mux4_out2		
		);
	
	-- Ouput of the circuit
	i_Mux2_OUT: entity work.mux2(rtl)
		port map(
			Sig1 	=> adder_out,
			Sig2 	=> mux4_out2,
			Sel 	=> alus(7),
			Output 	=> mux2_out2		
		);

	dout <= mux2_out2;

end rtl;
