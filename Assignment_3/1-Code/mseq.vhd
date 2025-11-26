library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library lpm;
use lpm.lpm_components.all;
use work.mseqlib.all;

entity mseq is
    port( 
        ir           : in std_logic_vector(3 downto 0);
        clock, reset : in std_logic;
        z            : in std_logic;
        code         : out std_logic_vector(35 downto 0);
        mOPs         : out std_logic_vector(26 downto 0)
    );
end mseq;

architecture arc of mseq is

    signal microinstruction : std_logic_vector(35 downto 0);
    signal current_address  : std_logic_vector(5 downto 0);
    signal next_address     : std_logic_vector(5 downto 0);

    signal sel_field        : std_logic_vector(2 downto 0);
    signal addr_field       : std_logic_vector(5 downto 0);

    signal s1, s0           : std_logic;
    signal mux_sel          : std_logic_vector(1 downto 0);
    signal bt               : std_logic;
    signal condition        : std_logic;

    signal incremented_addr : std_logic_vector(5 downto 0);
    signal mapped_addr      : std_logic_vector(5 downto 0);

    -- Extended 8-bit signals for mux4 compatibility
    signal mux_in1          : std_logic_vector(7 downto 0);
    signal mux_in2          : std_logic_vector(7 downto 0);
    signal mux_in3          : std_logic_vector(7 downto 0);
    signal mux_in4          : std_logic_vector(7 downto 0);
    signal mux_out          : std_logic_vector(7 downto 0);

    -- Signals for regnbit inputs/outputs
    signal regnbit_ld       : std_logic;
    signal regnbit_rst      : std_logic;
    signal regnbit_inc      : std_logic := '0';  -- Not used for now
    signal regnbit_din      : std_logic_vector(5 downto 0);
    signal regnbit_dout     : std_logic_vector(5 downto 0);

begin

    -- ROM with REGISTERED address (required by MAX 10)
    ROM_inst : lpm_rom
        generic map (
            lpm_width => 36,
            lpm_widthad => 6,
            lpm_address_control => "REGISTERED",
            lpm_outdata => "UNREGISTERED",
            lpm_file => "rs_microcode.mif"
        )
        port map (
            address => regnbit_dout,
            inclock => clock,
            q => microinstruction
        );

    -- Field Extraction from ROM output
    sel_field  <= microinstruction(35 downto 33);
    addr_field <= microinstruction(5 downto 0);

    code <= microinstruction;
    mOPs <= microinstruction(32 downto 6);

    -- MAP Block: Maps IR to starting microcode addresses
    process(ir)
    begin
        case ir is
            when "0000" => mapped_addr <= "000000";  -- NOP -> 0
            when "0001" => mapped_addr <= "000001";  -- FETCH -> 1
            when "0010" => mapped_addr <= "000100";  -- LDAC -> 4
            when "0011" => mapped_addr <= "001000";  -- STAC -> 8
            when "0100" => mapped_addr <= "001100";  -- MVAC -> 12
            when "0101" => mapped_addr <= "010000";  -- MOVR -> 16
            when "0110" => mapped_addr <= "011000";  -- JMPZ -> 24
            when "0111" => mapped_addr <= "011100";  -- JPNZ -> 28
            when "1000" => mapped_addr <= "100000";  -- ADD -> 32
            when "1001" => mapped_addr <= "100100";  -- SUB -> 36
            when "1010" => mapped_addr <= "101000";  -- INAC -> 40
            when "1011" => mapped_addr <= "101100";  -- CLAC -> 44
            when "1100" => mapped_addr <= "110000";  -- AND -> 48
            when "1101" => mapped_addr <= "110100";  -- OR -> 52
            when "1110" => mapped_addr <= "111000";  -- XOR -> 56
            when "1111" => mapped_addr <= "111100";  -- NOT -> 60
            when others => mapped_addr <= "000001";
        end case;
    end process;

    -- Incrementer: Standard increment
    incremented_addr <= regnbit_dout + 1;

    -- Condition Evaluation LOGIC MUX
    bt <= sel_field(2);
    condition <= z when bt = '0' else not z;

    -- S1, S0 Generation
    s1 <= sel_field(1) and (sel_field(0) or condition);
    s0 <= sel_field(0) and not sel_field(1);

    mux_sel <= s1 & s0;

    -- Extend 6-bit addresses to 8-bit for mux4 compatibility
    mux_in1 <= "00" & incremented_addr;  -- Sel="00": Sequential
    mux_in2 <= "00" & mapped_addr;       -- Sel="01": MAP jump
    mux_in3 <= "00" & addr_field;        -- Sel="10": Branch
    mux_in4 <= (others => '0');          -- Sel="11": Reset/Unused

    -- MUX4 Component Instantiation (MAP ADDRESSES MUX)
    MUX_Inst : mux4
        port map (
            Sig1   => mux_in1,
            Sig2   => mux_in2,
            Sig3   => mux_in3,
            Sig4   => mux_in4,
            Sel    => mux_sel,
            Output => mux_out
        );

    -- regnbit load and data assignment
    regnbit_ld <= '1';
    regnbit_rst <= not reset;
    regnbit_din <= mux_out(5 downto 0);

    -- Instantiate regnbit
    regnbit_inst : regnbit
        generic map (n => 6)
        port map (
            din  => regnbit_din,
            clk  => clock,
            rst  => regnbit_rst,
            ld   => regnbit_ld,
            inc  => regnbit_inc,
            dout => regnbit_dout
        );
end arc;