library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

--=========================================================
-- Library package for Lab 3 microprogrammed control unit
-- Contains component declarations for ALU and related units
--=========================================================

package mseqlib is

	-- regnbit Component
	component regnbit is
		generic (n : integer := 8);
		port(
			-- Inputs
			din     	: in std_logic_vector(n-1 downto 0);
			clk,rst,ld  : in std_logic;
			inc     	: in std_logic;
			
			-- Outputs
			dout    	: out std_logic_vector(n-1 downto 0)
		);
	end component;

    -- 1-bit Full Adder Component
    component adder1bit is
        port(
            -- Inputs
            a    : in std_logic;
            b    : in std_logic;
            cin  : in std_logic;
            
            -- Outputs
            s    : out std_logic;
            cout : out std_logic
        );
    end component;

    -- 8-bit Full Adder Component
    component adder8bit is
        port(
            -- Inputs
            a    : in std_logic_vector(7 downto 0);
            b    : in std_logic_vector(7 downto 0);
            cin  : in std_logic;
            
            -- Outputs
            s    : out std_logic_vector(7 downto 0);
            cout : out std_logic
        );
    end component;

    -- 2-to-1 Multiplexer Component
    component mux2 is
        port(
            -- Inputs
            Sig1   : in std_logic_vector(7 downto 0);
            Sig2   : in std_logic_vector(7 downto 0);
            Sel    : in std_logic;
            
            -- Outputs
            Output : out std_logic_vector(7 downto 0)
        );
    end component;

    -- 4-to-1 Multiplexer Component
    component mux4 is
        port(
            -- Inputs
            Sig1   : in std_logic_vector(7 downto 0);
            Sig2   : in std_logic_vector(7 downto 0);
            Sig3   : in std_logic_vector(7 downto 0);
            Sig4   : in std_logic_vector(7 downto 0);
            Sel    : in std_logic_vector(1 downto 0);
            
            -- Outputs
            Output : out std_logic_vector(7 downto 0)
        );
    end component;

    -- ALU Component
    component alu is
        generic (n : integer := 8);
        port (
            ac   : in std_logic_vector(n-1 downto 0);
            db   : in std_logic_vector(n-1 downto 0);
            alus : in std_logic_vector(7 downto 1);
            dout : out std_logic_vector(n-1 downto 0)
        );
    end component;

end package mseqlib;