----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2024 09:33:56 AM
-- Design Name: 
-- Module Name: reg - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
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

entity reg is
    port ( 
        i_reset : in std_logic;
        i_set : in std_logic_vector(3 downto 0); -- need for cycle input at top?
        i_D : in std_logic_vector(7 downto 0);
        o_Q : out std_logic_vector(7 downto 0)
    );
end reg;

architecture Behavioral of reg is

    signal w_reg : STD_LOGIC_VECTOR(7 downto 0);
    
begin
    process(i_set)
    begin
        if i_set = "0010" then  
            o_Q <= i_D; 
        end if;
    end process;
    
    -- Concurrent Statements
   --o_out <= w_reg;

end Behavioral;
