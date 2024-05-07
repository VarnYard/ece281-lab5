----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2024 09:42:47 AM
-- Design Name: 
-- Module Name: controller_fsm2 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: Created for ECE 281 Lab 5 (C3C West and Varnier)
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller_fsm2 is
   port ( 
        i_reset : in std_logic;
        i_adv : in std_logic;
        o_cycle : out std_logic_vector(3 downto 0)
   );
end controller_fsm2;

architecture Behavioral of controller_fsm2 is

 
   type sm_state is (s_default, s_loadA, s_loadB, s_operate);
   -- Here you create variables that can take on the values defined above. Neat!    
   signal f_Q, f_Q_next : sm_state;

begin

   -- CONCURRENT STATEMENTS ------------------------------------------------------------------------------
   -- Next State Logic
   f_Q_next <= s_default when (f_Q = s_operate and i_adv = '1') or i_reset = '1' else
               s_loadA when f_Q = s_default and i_adv = '1' else
               s_loadB when f_Q = s_loadA and i_adv = '1' else
               s_operate when f_Q = s_loadB and i_adv = '1' else
               s_default; -- default case here?
   
             
     
   -- Output logic
   with f_Q select -- one-hot encoding for states
       o_cycle <= "0010" when s_loadA,
                  "0100" when s_loadB,
                  "1000" when s_operate,
                  "0001" when others; -- default is s_default
                  
    
   -------------------------------------------------------------------------------------------------------
   -- PROCESSES ------------------------------------------------------------------------------------------    
   -- State memory ------------
   register_proc : process (i_reset, i_adv)
   begin
        -- synchronous reset
       if i_reset = '1' then
           f_Q <= s_default;
       elsif rising_edge(i_adv) then
           f_Q <= f_Q_next;
       end if;

   end process register_proc;    
   -------------------------------------------------------------------------------------------------------



end Behavioral;
