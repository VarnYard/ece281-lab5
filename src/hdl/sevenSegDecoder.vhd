----------------------------------------------------------------------------------
-- Company: USAFA ECE 281 (Spring 2024)
-- Engineer: C3C Jack West
-- 
-- Create Date: 02/20/2024 09:52:10 AM
-- Design Name: 
-- Module Name: sevenSegDecoder - Behavioral
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

entity sevenSegDecoder is
    port ( 
       i_D : in std_logic_vector(3 downto 0);
       o_S : out std_logic_vector(6 downto 0)
    );
end sevenSegDecoder;

architecture Behavioral of sevenSegDecoder is

-- signals for Sa (c_S(0)) to Sg (c_S(6))
    signal c_S : std_logic_vector (6 downto 0);
    
begin
    -- Concurrent Statements
    o_S(0) <= c_S(0);
    o_S(1) <= c_S(1);
    o_S(2) <= c_S(2);
    o_S(3) <= c_S(3);
    o_S(4) <= c_S(4);
    o_S(5) <= c_S(5);
    o_S(6) <= c_S(6);
    
    -- logic for outputs (using logic equations from prelab
    
    c_S(0) <= (i_D(2) and not i_D(1) and not i_D(0))
            or (i_D(3) and i_D(2) and not i_D(1))
            or (not i_D(3) and not i_D(2) and not i_D(1) and i_D(0))
            or (i_D(3) and not i_D(2) and i_D(1) and i_D(0));
    
    c_S(1) <= (i_D(2) and i_D(1) and not i_D(0))
            or (i_D(3) and i_D(1) and i_D(0))
            or (not i_D(3) and i_D(2) and not i_D(1) and i_D(0))
            or (i_D(3) and i_D(2) and not i_D(1) and not i_D(0));
    
    c_S(2) <= (i_D(3) and i_D(2) and not i_D(1) and not i_D(0))
            or (not i_D(3) and not i_D(2) and i_D(1) and not i_D(0))
            or (i_D(3) and i_D(2) and i_D(1));
    
    --c_S(3) <= '1' when ( (i_D = x"1") or
                         --(i_D = x"4") or
                         --(i_D = x"7") or
                         --(i_D = x"9") or
                         --(i_D = x"A") or
                         --(i_D = x"F") ) else '0';        
    c_S(3) <= (not i_D(3) and i_D(2) and not i_D(1) and not i_D(0))
            or (not i_D(2) and not i_D(1) and i_D(0))
            or (i_D(2) and i_D(1) and i_D(0))
            or (i_D(3) and not i_D(2) and i_D(1) and not i_D(0));
    
    c_S(4) <= (not i_D(3) and i_D(0))
            or (not i_D(3) and i_D(2) and not i_D(1))
            or (not i_D(2) and not i_D(1) and i_D(0));
    
    c_S(5) <= (i_D(3) and i_D(2) and not i_D(1))
            or (not i_D(3) and not i_D(2) and i_D(0))
            or (not i_D(3) and not i_D(2) and i_D(1))
            or (not i_D(3) and i_D(1) and i_D(0));
            
    c_S(6) <= '1' when ( (i_D = x"0") or
                         (i_D = x"1") or
                         (i_D = x"7") ) else '0';
    
    
    --c_S(6) <= (not i_D(3) and not i_D(2) and not i_D(1))
            --or (not i_D(3) and i_D(2) and i_D(1) and i_D(0));
            
    -- finish rest of Sx outputs 

end Behavioral;
