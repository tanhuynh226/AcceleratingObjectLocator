----------------------------------------------------------------------
-- Locator Structural Model
----------------------------------------------------------------------
-- First Name : Tan
-- Last Name : Huynh
----------------------------------------------------------------------

---------- Components library ----------

---------- 8x16 Register File ----------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY RegFile IS
   PORT (R_Addr1, R_Addr2, W_Addr: IN std_logic_vector(2 DOWNTO 0);
         R_en, W_en: IN std_logic;
         Reg_Data1 : OUT std_logic_vector(15 DOWNTO 0); 
			Reg_Data2 : OUT std_logic_vector(15 DOWNTO 0); 
         W_Data: IN std_logic_vector(15 DOWNTO 0); 
         Clk, Rst: IN std_logic);
END RegFile;

ARCHITECTURE Beh OF RegFile IS 
   TYPE regArray_type IS 
      ARRAY (0 TO 7) OF std_logic_vector(15 DOWNTO 0); 
   SIGNAL regArray : regArray_type;
BEGIN
   WriteProcess: PROCESS(Clk)    
   BEGIN
      IF (Clk = '1' AND Clk'EVENT) THEN
         IF (Rst = '1') THEN
            regArray(0) <= X"0000" AFTER 6.0 NS;
            regArray(1) <= X"000B" AFTER 6.0 NS;
            regArray(2) <= X"0008" AFTER 6.0 NS;
            regArray(3) <= X"0003" AFTER 6.0 NS;
            regArray(4) <= X"0005" AFTER 6.0 NS;
            regArray(5) <= X"0000" AFTER 6.0 NS;
            regArray(6) <= X"0000" AFTER 6.0 NS;
            regArray(7) <= X"0000" AFTER 6.0 NS;
         ELSE
            IF (W_en = '1') THEN
                regArray(conv_integer(W_Addr)) <= W_Data AFTER 6.0 NS;
                END IF;
        END IF;
     END IF;
   END PROCESS;
            
   ReadProcess1: PROCESS(R_en, R_Addr1, regArray)
   BEGIN
      IF (R_en = '1') THEN
        CASE R_Addr1 IS
            WHEN "000" =>
                Reg_Data1 <= regArray(0) AFTER 6.0 NS;
            WHEN "001" =>
                Reg_Data1 <= regArray(1) AFTER 6.0 NS;
            WHEN "010" =>
                Reg_Data1 <= regArray(2) AFTER 6.0 NS;
            WHEN "011" =>
                Reg_Data1 <= regArray(3) AFTER 6.0 NS;
            WHEN "100" =>
                Reg_Data1 <= regArray(4) AFTER 6.0 NS;
            WHEN "101" =>
                Reg_Data1 <= regArray(5) AFTER 6.0 NS;
            WHEN "110" =>
                Reg_Data1 <= regArray(6) AFTER 6.0 NS;
            WHEN "111" =>
                Reg_Data1 <= regArray(7) AFTER 6.0 NS;
            WHEN OTHERS =>
                Reg_Data1 <= (OTHERS=>'0') AFTER 6.0 NS;
        END CASE;
      ELSE
        Reg_Data1 <= (OTHERS=>'0') AFTER 6.0 NS;
      END IF;
   END PROCESS;
	
	ReadProcess2: PROCESS(R_en, R_Addr2, regArray)
   BEGIN
      IF (R_en = '1') THEN
        CASE R_Addr2 IS
            WHEN "000" =>
                Reg_Data2 <= regArray(0) AFTER 6.0 NS;
            WHEN "001" =>
                Reg_Data2 <= regArray(1) AFTER 6.0 NS;
            WHEN "010" =>
                Reg_Data2 <= regArray(2) AFTER 6.0 NS;
            WHEN "011" =>
                Reg_Data2 <= regArray(3) AFTER 6.0 NS;
            WHEN "100" =>
                Reg_Data2 <= regArray(4) AFTER 6.0 NS;
            WHEN "101" =>
                Reg_Data2 <= regArray(5) AFTER 6.0 NS;
            WHEN "110" =>
                Reg_Data2 <= regArray(6) AFTER 6.0 NS;
            WHEN "111" =>
                Reg_Data2 <= regArray(7) AFTER 6.0 NS;
            WHEN OTHERS =>
                Reg_Data2 <= (OTHERS=>'0') AFTER 6.0 NS;
        END CASE;
      ELSE
        Reg_Data2 <= (OTHERS=>'0') AFTER 6.0 NS;
      END IF;
   END PROCESS;
END Beh;


---------- 16-Bit ALU ----------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;


ENTITY ALU IS
    PORT (Sel: IN std_logic;
            A: IN std_logic_vector(15 DOWNTO 0);
            B: IN std_logic_vector(15 DOWNTO 0);
            ALU_Out: OUT std_logic_vector (15 DOWNTO 0) );
END ALU;

ARCHITECTURE Beh OF ALU IS

BEGIN
    PROCESS (A, B, Sel)
         variable temp: std_logic_vector(31 DOWNTO 0):= X"00000000";
    BEGIN
        IF (Sel = '0') THEN
            ALU_Out <= A + B AFTER 12 NS;                
        ELSIF (Sel = '1') THEN
            temp := A * B ;
                ALU_Out <= temp(15 downto 0) AFTER 12 NS; 
        END IF;
          
    END PROCESS;
END Beh;


---------- 16-bit Shifter ----------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Shifter IS
   PORT (I: IN std_logic_vector(15 DOWNTO 0);
         Q: OUT std_logic_vector(15 DOWNTO 0);
         sel: IN std_logic );
END Shifter;

ARCHITECTURE Beh OF Shifter IS 
BEGIN
   PROCESS (I,sel) 
   BEGIN
         IF (sel = '1') THEN 
            Q <= I(14 downto 0) & '0' AFTER 4.0 NS;
         ELSE
            Q <= '0' & I(15 downto 1) AFTER 4.0 NS;
         END IF;   
   END PROCESS; 
END Beh;


---------- 2-to-1 Selector ----------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Selector IS
   PORT (sel: IN std_logic;
         x,y: IN std_logic_vector(15 DOWNTO 0);
         f: OUT std_logic_vector(15 DOWNTO 0));
END Selector;

ARCHITECTURE Beh OF Selector IS 
BEGIN
   PROCESS (x,y,sel)
   BEGIN
         IF (sel = '0') THEN
            f <= x AFTER 3.0 NS;
         ELSE
            f <= y AFTER 3.0 NS;
         END IF;   
   END PROCESS; 
END Beh;


---------- 16-bit Register ----------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Reg IS
   PORT (I: IN std_logic_vector(15 DOWNTO 0);
         Q: OUT std_logic_vector(15 DOWNTO 0);
         Ld: IN std_logic; 
         Clk, Rst: IN std_logic );
END Reg;

ARCHITECTURE Beh OF Reg IS 
BEGIN
   PROCESS (Clk)
   BEGIN
      IF (Clk = '1' AND Clk'EVENT) THEN
         IF (Rst = '1') THEN
            Q <= X"0000" AFTER 4.0 NS;
         ELSIF (Ld = '1') THEN
            Q <= I AFTER 4.0 NS;
         END IF;   
      END IF;
   END PROCESS; 
END Beh;

---------- 16-bit Three-state Buffer ----------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ThreeStateBuff IS
    PORT (Control_Input: IN std_logic;
          Data_Input: IN std_logic_vector(15 DOWNTO 0);
          Output: OUT std_logic_vector(15 DOWNTO 0) );
END ThreeStateBuff;

ARCHITECTURE Beh OF ThreeStateBuff IS
BEGIN
    PROCESS (Control_Input, Data_Input)
    BEGIN
        IF (Control_Input = '1') THEN
            Output <= Data_Input AFTER 2 NS;
        ELSE
            Output <= (OTHERS=>'Z') AFTER 2 NS;
        END IF;
    END PROCESS;
END Beh;

---------- Controller ----------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY Controller IS
    PORT(R_en: OUT std_logic;
         W_en: OUT std_logic;
         R_Addr1: OUT std_logic_vector(2 DOWNTO 0);
			R_Addr2: OUT std_logic_vector(2 DOWNTO 0);
         W_Addr: OUT std_logic_vector(2 DOWNTO 0);
         Shifter_Sel: OUT std_logic;
         Selector_Sel: OUT std_logic;
         ALU_sel : OUT std_logic;
         OutReg_Ld: OUT std_logic;
         Oe: OUT std_logic;
         Done: OUT std_logic;
         Start, Clk, Rst: IN std_logic); 
END Controller;


ARCHITECTURE Beh OF Controller IS
SUBTYPE StateType is std_logic_vector(3 downto 0);
SIGNAL Currstate, Nextstate: Statetype:= "0000";

BEGIN
    CtrlReg: PROCESS (CLK)
    BEGIN
        If (Clk = '1' AND Clk 'EVENT) THEN
            IF (RST = '1') THEN
                Currstate <= "0000";
            ELSE
                Currstate <= Nextstate;
            END IF;
        END IF;
    END  PROCESS CtrlReg;
    
    CtrlLogic: PROCESS (Currstate, Start)
    BEGIN
        CASE Currstate IS
            WHEN "0000" =>
                Done <= '0';
                Oe <= '0';
                OutReg_Ld <= '0';
                R_en <= '0';
                W_en <= '0';
                IF (Start = '1') THEN
                    Nextstate <= "0001" AFTER 11 NS;
                ELSE
                    Nextstate <= "0000" AFTER 11 NS;
                END IF;
            WHEN "0001" =>
                R_en <= '1';
                r_Addr1 <= "001";
                r_Addr2 <= "010";
                W_en <= '1';
                W_Addr <= "101";
                ALU_sel <= '1';
                Selector_sel <= '1';
                Nextstate <= "0010" AFTER 11 NS;
            WHEN "0010" =>
                R_en <= '1';
                r_Addr1 <= "101";
                r_Addr2 <= "010";
                W_en <= '1';
                W_Addr <= "110";
                ALU_sel <= '1';
                Selector_sel <= '1';
                Nextstate <= "0011" AFTER 11 NS;
            WHEN "0011" =>
                R_en <= '1';
                r_Addr1 <= "000";
                r_Addr2 <= "110";
                W_en <= '1';
                W_Addr <= "101";
                Shifter_sel <= '0';
                Selector_sel <= '0';
                Nextstate <= "0100" AFTER 11 NS;
            WHEN "0100" =>
                R_en <= '1';
                r_Addr1 <= "011";
                r_Addr2 <= "010";
                W_en <= '1';
                W_Addr <= "110";
                ALU_sel <= '1';
                Selector_sel <= '1';
                Nextstate <= "0101" AFTER 11 NS;
            WHEN "0101" =>
                R_en <= '1';
                r_Addr1 <= "101";
                r_Addr2 <= "110";
                W_en <= '1';
                W_Addr <= "111";
                ALU_sel <= '0';
                Selector_sel <= '1';
                Nextstate <= "0110" AFTER 11 NS;
            WHEN "0110" =>
                R_en <= '1';
                r_Addr1 <= "111";
                r_Addr2 <= "100";
                W_en <= '1';
                W_Addr <= "101";
                ALU_sel <= '0';
                Selector_sel <= '1';
                OutReg_Ld <= '1';
                Nextstate <= "0111" AFTER 11 NS;
            WHEN "0111" =>
                OutReg_Ld <= '1';
                Nextstate <= "1000" AFTER 11 NS;
            WHEN "1000" =>
                Oe <= '1';
                Done <= '1' AFTER 2 NS;
                Nextstate <= "0000" AFTER 11 NS;
            WHEN others =>
                Nextstate <= "0000" AFTER 11 NS;
        END CASE;
    END PROCESS CtrlLogic;

END Beh;


---------- Locator (with clock cycle =  44 NS )----------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

entity Locator_struct is
    Port ( Start : in  STD_LOGIC;
           Rst : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           Loc : out  STD_LOGIC_VECTOR (15 downto 0);
           Done : out  STD_LOGIC);
end Locator_struct;

architecture Struct of Locator_struct is
    
    COMPONENT RegFile IS
        PORT (  R_Addr1, R_Addr2, W_Addr: IN std_logic_vector(2 DOWNTO 0);
                R_en, W_en: IN std_logic;
                Reg_Data1: OUT std_logic_vector(15 DOWNTO 0); 
				Reg_Data2: OUT std_logic_vector(15 DOWNTO 0);
                W_Data: IN std_logic_vector(15 DOWNTO 0); 
                Clk, Rst: IN std_logic );
    END COMPONENT;
    
    COMPONENT ALU IS
        PORT (Sel: IN std_logic;
                A: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
                B: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
                ALU_Out: OUT STD_LOGIC_VECTOR (15 DOWNTO 0) );
    END COMPONENT;

    COMPONENT Shifter IS
         PORT (I: IN std_logic_vector(15 DOWNTO 0);
               Q: OUT std_logic_vector(15 DOWNTO 0);
               sel: IN std_logic );
    END COMPONENT;

    COMPONENT Selector IS
        PORT (sel: IN std_logic;
              x,y: IN std_logic_vector(15 DOWNTO 0);
              f: OUT std_logic_vector(15 DOWNTO 0) );
    END COMPONENT;
   
    COMPONENT Reg IS
        PORT (I: IN std_logic_vector(15 DOWNTO 0);
              Q: OUT std_logic_vector(15 DOWNTO 0);
              Ld: IN std_logic; 
              Clk, Rst: IN std_logic );
    END COMPONENT;
    
    COMPONENT ThreeStateBuff IS
        PORT (Control_Input: IN std_logic;
              Data_Input: IN std_logic_vector(15 DOWNTO 0);
              Output: OUT std_logic_vector(15 DOWNTO 0) );
    END COMPONENT;
    
    COMPONENT Controller IS
       PORT(R_en: OUT std_logic;
            W_en: OUT std_logic;
            R_Addr1: OUT std_logic_vector(2 DOWNTO 0);
				R_Addr2: OUT std_logic_vector(2 DOWNTO 0);
            W_Addr: OUT std_logic_vector(2 DOWNTO 0);
            Shifter_sel: OUT std_logic;
            Selector_sel: OUT std_logic;
            ALU_sel : OUT std_logic;
            OutReg_Ld: OUT std_logic;
            Oe: OUT std_logic;
            Done: OUT std_logic;
            Start, Clk, Rst: IN std_logic); 
     END COMPONENT;

SIGNAL R_Addr1, R_Addr2, W_Addr: std_logic_vector(2 downto 0);
SIGNAL R_en, W_en: std_logic;
SIGNAL ALU_sel: std_logic;
SIGNAL Shifter_sel: std_logic;
SIGNAL Selector_sel: std_logic;
SIGNAL OutReg_Ld: std_logic;
SIGNAL Oe: std_logic;
SIGNAL w1, w2, w3, w4, w5, w6:  std_logic_vector(15 downto 0);
begin

    ---Controller---
    Control: Controller PORT MAP(R_en => R_en, W_en => W_en, R_Addr1 => R_Addr1, R_Addr2 => R_Addr2, W_Addr => W_Addr, Shifter_Sel => Shifter_Sel, Selector_Sel => Selector_Sel, ALU_Sel => ALU_Sel, OutReg_Ld => OutReg_Ld, Oe => Oe , Done => Done, Start => Start, Clk => Clk, Rst => Rst);
    
    ----Datapath----
    RegisterFile: RegFile PORT MAP (R_Addr1 => R_Addr1, R_Addr2 => R_Addr2, W_Addr => W_Addr, R_en => R_en, W_en => W_en, Reg_Data1 => w1, Reg_Data2 => w2, W_Data => w5, Clk => Clk, Rst => Rst);
    AddOrMultiply: ALU PORT MAP (Sel => ALU_sel, A => w2, B => w1, ALU_out => w3);
    Divide: Shifter PORT MAP (I => w2, Q => w4, sel => Shifter_sel);
    Selectr: Selector PORT MAP (Sel => Selector_sel, x => w4, y => w3, f => w5);
    OutReg: Reg PORT MAP (I => w5, Q => w6, Ld => OutReg_Ld, Clk => Clk, Rst => Rst);
    TSB: ThreeStateBuff PORT MAP(Control_Input => Oe, Data_Input => w6, Output => Loc);
end Struct;