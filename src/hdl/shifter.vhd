----------------------------------------------------------------------------------
-- Company: 
-- Engineer: C3C Jack West
-- 
-- Create Date: 05/05/2024 11:01:14 PM
-- Design Name: 
-- Module Name: shifter - Behavioral
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

use IEEE.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity shifter is
    port (
        i_operation : in std_logic_vector(2 downto 0); -- does i_op feed into shifter?
        i_inputL : in std_logic_vector(7 downto 0); -- i_A
        i_inputR : in std_logic_vector(7 downto 0); --i_B
        o_shifted : out std_logic_vector(7 downto 0) -- the result of the shift
    
     );
end shifter;

architecture Behavioral of shifter is


    signal w_A : std_logic_vector(7 downto 0);
    signal w_B : std_logic_vector(7 downto 0);
    signal w_operation : std_logic_vector(2 downto 0);

begin

    w_A <= i_inputL;
    w_B <= i_inputR;
    w_operation <= i_operation;
    
    

    o_shifted <= std_logic_vector(shift_left(unsigned(w_A), to_integer(unsigned(w_B(7 downto 0))))) when w_operation = "100" else
                 std_logic_vector(shift_right(unsigned(w_A), to_integer(unsigned(w_B(7 downto 0))))) when w_operation = "101" else
                 "00000000"; -- default


end Behavioral;
