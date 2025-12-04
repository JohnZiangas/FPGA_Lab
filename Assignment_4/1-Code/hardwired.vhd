library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library lpm;
use lpm.lpm_components.all;
use work.hardwiredlib.all;

entity hardwired is
    port( 
        ir           : in  std_logic_vector(3 downto 0);
        clock, reset : in  std_logic;
        z            : in  std_logic;
        mOPs         : out std_logic_vector(26 downto 0)
    );
end hardwired;

architecture rtl of hardwired is

	-- Internal signals for decoded instructions
    signal inst_decode : std_logic_vector(15 downto 0);
    signal INOP, ILDAC, ISTAC, IMVAC, IMOVR, IJUMP, IJMPZ, IJPNZ : std_logic;
    signal IADD, ISUB, IINAC, ICLAC, IAND, IOR, IXOR, INOT : std_logic;
    
	-- Internal signals for decoded states from the counter (T0-T7)
    signal state_decode 				  : std_logic_vector(7 downto 0);
    signal T0, T1, T2, T3, T4, T5, T6, T7 : std_logic;
    
	-- Counter signals
    signal counter_out : std_logic_vector(2 downto 0); -- 3-bit output of the state counter
    signal counter_inc : std_logic; 				   -- Signal to increment the counter
    signal counter_clr : std_logic;					   -- Signal to clear (reset) the counter
    
	-- FSM state signals (combinational logic based on T-states and instruction)
    signal FETCH1, FETCH2, FETCH3 			 : std_logic;
    signal NOP1 							 : std_logic;
    signal LDAC1, LDAC2, LDAC3, LDAC4, LDAC5 : std_logic;
    signal STAC1, STAC2, STAC3, STAC4, STAC5 : std_logic;
    signal MVAC1, MOVR1 					 : std_logic;
    signal JUMP1, JUMP2, JUMP3 				 : std_logic;
    signal JMPZY1, JMPZY2, JMPZY3 			 : std_logic;
    signal JMPZN1, JMPZN2 					 : std_logic;
    signal JPNZY1, JPNZY2, JPNZY3 			 : std_logic;
    signal JPNZN1, JPNZN2 					 : std_logic;
    signal ADD1, SUB1, INAC1, CLAC1 		 : std_logic;
    signal AND1, OR1, XOR1, NOT1 			 : std_logic;
    
	-- Individual control signals (micro-operations)
    signal ARLOAD, ARINC, PCLOAD, PCINC, DRLOAD, TRLOAD, IRLOAD, RLOAD : std_logic;
    signal ACLOAD, ZLOAD, RD, WR, MEMBUS, BUSMEM : std_logic;
    signal PCBUS, DRBUS, TRBUS, RBUS, ACBUS 	 : std_logic;
    signal ANDOP, OROP, XOROP, NOTOP 			 : std_logic;
    signal ACINC, ACZERO, PLUS, MINUS 			 : std_logic;
    
	-- Utility signals
    signal Z_not : std_logic;

begin

	-- Instruction decoder (4 to 16)
    inst_decoder : decoder_generic
        generic map(INPUT_WIDTH => 4, OUTPUT_WIDTH => 16)
        port map(din => ir, dout => inst_decode);
    
	-- State decode (3 to 8)
    state_decoder : decoder_generic
        generic map(INPUT_WIDTH => 3, OUTPUT_WIDTH => 8)
        port map(din => counter_out, dout => state_decode);
    
	-- 3-bit counter
	-- Increments on 'counter_inc' and clears on 'counter_clr'.
    -- NOTE: This component uses a SYNCHRONOUS reset.
    counter : counter_3bit
        port map(clk => clock, rst => counter_clr, inc => counter_inc, count => counter_out);

    -- Assign decoded instruction signals for readability
    INOP  <= inst_decode(0);
    ILDAC <= inst_decode(1);
    ISTAC <= inst_decode(2);
    IMVAC <= inst_decode(3);
    IMOVR <= inst_decode(4);
    IJUMP <= inst_decode(5);
    IJMPZ <= inst_decode(6);
    IJPNZ <= inst_decode(7);
    IADD  <= inst_decode(8);
    ISUB  <= inst_decode(9);
    IINAC <= inst_decode(10);
    ICLAC <= inst_decode(11);
    IAND  <= inst_decode(12);
    IOR   <= inst_decode(13);
    IXOR  <= inst_decode(14);
    INOT  <= inst_decode(15);
    
    -- Assign decoded state signals for readability
    T0 <= state_decode(0);
    T1 <= state_decode(1);
    T2 <= state_decode(2);
    T3 <= state_decode(3);
    T4 <= state_decode(4);
    T5 <= state_decode(5);
    T6 <= state_decode(6);
    T7 <= state_decode(7);
    
	-- Invert the Z flag for use in JMPZN and JPNZY instructions
    Z_not <= not z;

	-- FETCH CYCLE STATES
    -- T0, T1, and T2 are dedicated to the fetch cycle.
    FETCH1 <= T0;
    FETCH2 <= T1;
    FETCH3 <= T2;
    
	-- INSTRUCTION EXECUTION STATES
    -- All instruction execution starts at T3.
	-- Table 1
    NOP1 <= INOP and T3;
    
    LDAC1 <= ILDAC and T3;
    LDAC2 <= ILDAC and T4;
    LDAC3 <= ILDAC and T5;
    LDAC4 <= ILDAC and T6;
    LDAC5 <= ILDAC and T7;
    
    STAC1 <= ISTAC and T3;
    STAC2 <= ISTAC and T4;
    STAC3 <= ISTAC and T5;
    STAC4 <= ISTAC and T6;
    STAC5 <= ISTAC and T7;
    
    MVAC1 <= IMVAC and T3;
    MOVR1 <= IMOVR and T3;
    
    JUMP1 <= IJUMP and T3;
    JUMP2 <= IJUMP and T4;
    JUMP3 <= IJUMP and T5;
    
    JMPZY1 <= IJMPZ and z and T3;
    JMPZY2 <= IJMPZ and z and T4;
    JMPZY3 <= IJMPZ and z and T5;
    JMPZN1 <= IJMPZ and Z_not and T3;
    JMPZN2 <= IJMPZ and Z_not and T4;
    
    JPNZY1 <= IJPNZ and Z_not and T3;
    JPNZY2 <= IJPNZ and Z_not and T4;
    JPNZY3 <= IJPNZ and Z_not and T5;
    JPNZN1 <= IJPNZ and z and T3;
    JPNZN2 <= IJPNZ and z and T4;
    
    ADD1  <= IADD and T3;
    SUB1  <= ISUB and T3;
    INAC1 <= IINAC and T3;
    CLAC1 <= ICLAC and T3;
    AND1  <= IAND and T3;
    OR1   <= IOR and T3;
    XOR1  <= IXOR and T3;
    NOT1  <= INOT and T3;

	-- Control Signal Generation from Table 2.
	-- Register Control
    ARLOAD 	<= FETCH1 or FETCH3 or LDAC3 or STAC3;
    ARINC  	<= LDAC1 or STAC1 or JMPZY1 or JPNZY1;
    PCLOAD 	<= JUMP3 or JMPZY3 or JPNZY3;
    PCINC  	<= FETCH2 or LDAC1 or LDAC2 or STAC1 or STAC2 or 
               JMPZN1 or JMPZN2 or JPNZN1 or JPNZN2;
    DRLOAD 	<= FETCH2 or LDAC1 or LDAC2 or LDAC4 or STAC1 or STAC2 or STAC4 or 
               JUMP1 or JUMP2 or JMPZY1 or JMPZY2 or JPNZY1 or JPNZY2;
    TRLOAD 	<= LDAC2 or STAC2 or JUMP2 or JMPZY2 or JPNZY2;
    IRLOAD 	<= FETCH3;
    RLOAD  	<= MVAC1;
    ACLOAD 	<= LDAC5 or MOVR1 or ADD1 or SUB1 or INAC1 or CLAC1 or 
               AND1 or OR1 or XOR1 or NOT1;
    ZLOAD  	<= LDAC5 or MOVR1 or ADD1 or SUB1 or INAC1 or CLAC1 or 
               AND1 or OR1 or XOR1 or NOT1;
	
	-- Memory Control
    RD 		<= FETCH2 or LDAC1 or LDAC2 or LDAC4 or STAC1 or STAC2 or 
			   JUMP1 or JUMP2 or JMPZY1 or JMPZY2 or JPNZY1 or JPNZY2;
    WR 		<= STAC5;
    MEMBUS  <= FETCH2 or LDAC1 or LDAC2 or LDAC4 or STAC1 or STAC2 or 
               JUMP1 or JUMP2 or JMPZY1 or JMPZY2 or JPNZY1 or JPNZY2;
    BUSMEM 	<= STAC5;
	
	-- Bus Control
    PCBUS 	<= FETCH1 or FETCH3;
    DRBUS 	<= LDAC2 or LDAC3 or LDAC5 or STAC2 or STAC3 or STAC5 or 
               JUMP2 or JUMP3 or JMPZY2 or JMPZY3 or JPNZY2 or JPNZY3;
    TRBUS 	<= LDAC3 or STAC3 or JUMP3 or JMPZY3 or JPNZY3;
    RBUS	<= MOVR1 or ADD1 or SUB1 or AND1 or OR1 or XOR1;
    ACBUS 	<= STAC4 or MVAC1;
	
	-- ALU operations
    ANDOP 	<= AND1;
    OROP  	<= OR1;
    XOROP 	<= XOR1;
    NOTOP 	<= NOT1;
    ACINC  	<= INAC1;
    ACZERO 	<= CLAC1;
    PLUS   	<= ADD1;
    MINUS  	<= SUB1;

    -- Increment on all non-terminal states. The counter advances the FSM
    -- through the fetch and execute cycles.
	counter_inc <= FETCH1 or FETCH2 or FETCH3 or
	               LDAC1 or LDAC2 or LDAC3 or LDAC4 or 
	               STAC1 or STAC2 or STAC3 or STAC4 or
	               JUMP1 or JUMP2 or 
	               JMPZY1 or JMPZY2 or JMPZN1 or 
	               JPNZY1 or JPNZY2 or JPNZN1;

    -- Clear (reset) the counter only on the terminal state of each instruction.
    -- This causes the FSM to loop back to T0 (FETCH1) for the next instruction.
	counter_clr <=  NOP1 or LDAC5 or STAC5 or MVAC1 or MOVR1 or 
	                JUMP3 or JMPZY3 or JMPZN2 or JPNZY3 or JPNZN2 or 
	                ADD1 or SUB1 or INAC1 or CLAC1 or AND1 or OR1 or XOR1 or NOT1;

    -- The individual control signals are combined into the final 27-bit mOPs word.
    -- The order of concatenation is critical and must match the system design.
    mOPs <= ARLOAD & ARINC & PCLOAD & PCINC & DRLOAD & TRLOAD & IRLOAD & RLOAD &
            ACLOAD & ZLOAD & RD & WR & MEMBUS & BUSMEM & PCBUS & DRBUS &
            TRBUS & RBUS & ACBUS & ANDOP & OROP & XOROP & NOTOP & ACINC &
            ACZERO & PLUS & MINUS;

end architecture;