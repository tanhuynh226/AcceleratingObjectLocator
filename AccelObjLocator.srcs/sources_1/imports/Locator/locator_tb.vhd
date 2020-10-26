--------------------------------------------------------------------------------
-- Engineer: Tan Huynh
--
-- Create Date:  5/18/2020 
-- Design Name:  locator
-- Module Name:  locator_tb
-- Project Name:  Accelerating Object Locator
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Integrator_struct
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE std.textio.ALL; -- for write, writelin
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY locator_tb IS
END locator_tb;
 
ARCHITECTURE behavior OF locator_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Locator_struct
    PORT(
         Start : IN  std_logic;
         Rst : IN  std_logic;
         Clk : IN  std_logic;
         Loc : OUT  std_logic_vector(15 downto 0);
		 Done : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Start : std_logic := '0';
   signal Clk : std_logic := '0';
   signal Rst : std_logic := '1';

     --Outputs
   signal Done : std_logic;
   signal Loc : std_logic_vector(15 downto 0);

   -- Clock period definitions; change to correct value
   constant Clk_period : time := 44 ns;
 
BEGIN
 
    -- Instantiate the Unit Under Test (UUT)
   uut: Locator_struct PORT MAP (
          Start => Start,
          Rst => Rst,
          Clk => Clk,
		  Loc => Loc,
          Done => Done
        );

   -- Clock process definitions
   Clk_process :process
   begin
        Clk <= '0';
        wait for Clk_period/2;
        Clk <= '1';
        wait for Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
    variable stringbuff : LINE;
   begin        
        WRITE (stringbuff, string'("Simulation starts at "));
        WRITE (stringbuff, now);
        WRITELINE (output, stringbuff);

        Rst <= '1';
        WAIT FOR 100 NS; -- allow time for everything to rst
        Rst <= '0';
        WAIT FOR 15 NS; -- give some time between pressing rst & start button
        
        Start <= '1';
        WAIT UNTIL rising_edge(clk); -- wait for a rising edge so that it is easier to calculate next several wait statements
        WAIT FOR 10 NS; -- hold for some amount of time
        Start <= '0';
       
		-- remove line below & add your own waits, asserts, etc.
		WAIT FOR 265 NS; -- arbitrary wait time
		ASSERT Done = '1' report "Done is not equal to 1" SEVERITY WARNING;
		ASSERT (Loc = X"017D") REPORT "The location computed is not equal to 381" SEVERITY WARNING; -- 017D is the hexadecimal of 381

        WRITE (stringbuff, string'("Simulation Ends at "));
        WRITE (stringbuff, now);
        WRITELINE (output, stringbuff);

        wait; -- will wait forever
   end process;

END;
