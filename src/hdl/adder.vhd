library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.numeric_std.ALL;

entity adder is
    port (
        i_Cin : in std_logic;
            o_Cout : out std_logic_vector(0 downto 0); -- more bits?
            i_inputL : in std_logic_vector(7 downto 0); -- left input according to ALU scematic
            i_inputR : in std_logic_vector(7 downto 0);
            o_sum : out std_logic_vector(7 downto 0)
    );
    end adder;
    
architecture Behavioral of adder is

    signal w_A : std_logic_vector(7 downto 0);
    signal w_B : std_logic_vector(7 downto 0);

begin
    
    w_A <= i_inputL;
    w_B <= i_inputR;
    
    

    o_sum <= std_logic_vector(unsigned(w_A) + unsigned(w_B));


end Behavioral;
