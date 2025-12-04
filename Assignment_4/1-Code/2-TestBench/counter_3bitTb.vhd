library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_3bitTb is
end entity;

architecture sim of counter_3bitTb is
    
    -- Internal signals
    signal clk   : std_logic := '0';
    signal rst   : std_logic := '0';
    signal inc   : std_logic := '0';
    signal count : std_logic_vector(2 downto 0);
    
    -- Clock period definition
    constant clk_period : time := 100 ps;
    
begin 

    -- Instantiate the Device Under Test (DUT)
    i_Counter3bit : entity work.counter_3bit(rtl)
        port map(
            clk   => clk,
            rst   => rst,
            inc   => inc,
            count => count
        );
    
    --=================================================
    -- Clock Process
    --=================================================
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    --=================================================
    -- Stimulus Process
    --=================================================
    sim_process : process
    begin
        -- Initialize
        rst <= '1';
        inc <= '0';
        wait for clk_period * 2;
        
        report "------------------------------------------------";
        report "TEST 1: RESET VERIFICATION";
        report "------------------------------------------------";
        rst <= '0';
        wait for clk_period; -- Wait for 1 clock cycle to stabilize
        assert count = "000" report "Error: Reset failed, count is not 0" severity error;
        
        report "------------------------------------------------";
        report "TEST 2: COUNTING SEQUENCE (0 to 7)";
        report "------------------------------------------------";
        inc <= '1';
        
        -- Check each value from 0 to 7
        for i in 0 to 7 loop
             -- Compare expected integer 'i' with actual std_logic_vector 'count'
            assert unsigned(count) = to_unsigned(i, 3) 
                report "Error: Count mismatch at " & integer'image(i) severity error;
            wait for clk_period;
        end loop;

        report "------------------------------------------------";
        report "TEST 3: OVERFLOW (7 -> 0)";
        report "------------------------------------------------";
        -- Counter should be at 0 now (wrapped around from 7)
        assert count = "000" report "Error: Overflow failed, did not wrap to 0" severity error;
        
        report "------------------------------------------------";
        report "TEST 4: HOLD VALUE (Inc = 0)";
        report "------------------------------------------------";
        inc <= '0'; -- Disable increment
        wait for clk_period * 3; -- Wait a few cycles
        assert count = "000" report "Error: Hold failed, counter changed value" severity error;
        
        report "------------------------------------------------";
        report "TEST 5: PRIORITY CHECK (Rst vs Inc)";
        report "------------------------------------------------";
        -- Set both active at the same time. Reset should win.
        inc <= '1';
        rst <= '1'; 
        wait for clk_period;
        
        -- Release reset but keep increment
        rst <= '0';
        wait for clk_period; -- Counter should be 1 now (0->1)
        assert count = "001" report "Error: Priority check failed or counting didn't resume" severity error;
        
        report "------------------------------------------------";
        report "SIMULATION COMPLETED SUCCESSFULLY";
        report "------------------------------------------------";
        
        -- Stop simulation
        wait;
    end process;
    
end architecture;
