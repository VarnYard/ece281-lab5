--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
--|
--| ALU OPCODES:
--|
--|     ADD     000
--|     SUB     001
--|     AND     010
--|     OR      011
--|     LSHIFT  100
--|     RSHIFT  101
--|
--+----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ALU is
    port(
        i_A      : in std_logic_vector(7 downto 0); 
        i_B      : in std_logic_vector(7 downto 0); 
        i_op     : in std_logic_vector(2 downto 0);
        
        o_flags  : out std_logic_vector(2 downto 0); 
        o_result : out std_logic_vector(7 downto 0)
    );       
end ALU;

architecture behavioral of ALU is 
  
    -- declare components and signals
    signal w_op, w_flags      : std_logic_vector(2 downto 0); 
    signal w_A, w_B, w_result : std_logic_vector(7 downto 0);
   
begin
    -- PORT MAPS ----------------------------------------
    process(i_op, i_A, i_B)
    begin
        case i_op is 
            when "000" =>   
                w_result <= std_logic_vector(unsigned(i_A) + unsigned(i_B));   
                if (unsigned(i_A) + unsigned(i_B)) > 255 then
                    w_flags(1) <= '1'; -- Set carry out flag if overflow occurs
                else
                    w_flags(1) <= '0';
                end if;
                if w_result = "00000000" then
                    w_flags(0) <= '1'; -- Set zero flag if result is zero
                else
                    w_flags(0) <= '0';
                end if;
                w_flags(2) <= '0'; -- Clear overflow flag
                
            when "001" => 
                w_result <= std_logic_vector(unsigned(i_A) - unsigned(i_B)); 
                if unsigned(i_A) >= unsigned(i_B) then
                    w_flags(1) <= '0'; -- Clear carry out flag
                else
                    w_flags(1) <= '1'; -- Set carry out flag if borrow occurs
                end if;
                if w_result = "00000000" then
                    w_flags(0) <= '1'; -- Set zero flag if result is zero
                else
                    w_flags(0) <= '0';
                end if;
                w_flags(2) <= '0'; -- Clear overflow flag
               
            when "010" =>   
                w_result <= i_A and i_B; 
                w_flags <= "000"; 
               
            when "011" =>   
                w_result <= i_A or i_B; 
                w_flags <= "000"; 
               
            when "100" =>   
                w_result <= std_logic_vector(shift_left(unsigned(i_A),to_integer(unsigned(i_B))));        
                w_flags <= "000"; 
               
            when "101" =>   
                w_result <= std_logic_vector(shift_right(unsigned(i_A),to_integer(unsigned(i_B))));
                w_flags <= "000"; 
               
            when others =>  
                w_result <= (others => '0'); 
                w_flags <= "000"; 
        end case; 
    end process; 
       
    -- CONCURRENT STATEMENTS ----------------------------
    o_result <= w_result;
    o_flags <= w_flags; 
    
end behavioral;

