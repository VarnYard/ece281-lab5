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
    --signal w_op, w_flags      : std_logic_vector(2 downto 0); 
    --signal w_A, w_B, w_result : std_logic_vector(7 downto 0);
    signal w_2muxToAdder : std_logic_vector(7 downto 0);
    signal w_carryAdder : std_logic_vector(0 downto 0); --larger Cout from adder?
    signal w_sum : std_logic_vector(7 downto 0);
    signal w_shifted : std_logic_vector(7 downto 0);
    
    component adder is
        port (
            i_Cin : in std_logic;
            o_Cout : out std_logic_vector(0 downto 0); -- more bits?
            i_inputL : in std_logic_vector(7 downto 0); -- left input according to ALU scematic
            i_inputR : in std_logic_vector(7 downto 0);
            o_sum : out std_logic_vector(7 downto 0)
            );
    end component adder;
    
    component shifter is
        port (
            i_operation : in std_logic_vector(2 downto 0); -- does i_op feed into shifter?
            i_inputL : in std_logic_vector(7 downto 0); -- i_A
            i_inputR : in std_logic_vector(7 downto 0); --i_B
            o_shifted : out std_logic_vector(7 downto 0) -- the result of the shift
        );
    end component shifter;
    
    
            
   
begin
    -- PORT MAPS ----------------------------------------
    adder_inst : adder 
    port map (
        i_inputL => i_A,
        i_inputR => w_2muxToAdder,
        i_Cin => i_op(0),
        o_Cout => w_carryAdder,
        o_sum => w_sum
    );
    
    shifter_inst : shifter
    port map (
        i_operation => i_op,
        i_inputL => i_A,
        i_inputR => i_B,
        o_shifted => w_shifted
    );
    
    
       
    -- CONCURRENT STATEMENTS ----------------------------
    --o_result <= w_result;
    --o_flags <= w_flags;
    
    --shifter logic (has to be done in separate file?)
     
    
    --adder logic (has to be done in separate file?)
   -- o_sum <= unsigned(i_A) + w_2muxToAdder;
    
    -- little 2 to 1 mux
    with i_op(0) select
        w_2muxToAdder <= i_B when '0', -- adding case
        not i_B when others; -- subtracting case
        
    -- 4 to 1 mux
    with i_op select
        o_result <= w_shifted when "100",
        w_shifted when "101",
        w_sum when "000",
        std_logic_vector(unsigned(w_sum) + "00000001") when "001", --w_sum; subtracts
        i_A and i_B when "010",
        i_A or i_B when "011",
        "00000000" when others; -- default case, shouldn't active unless a ghost state is present
        
    -- o_flags mapping (originally set to '1')
    o_flags(0) <= '1' when w_carryAdder = "1" else
                   '0'; --not i_op(2 downto 1) and w_carryAdder;
    o_flags(1) <= '1' when w_sum = "00000000" or w_shifted = "00000000" else
                   '0';-- not sure
    o_flags(2) <= '1' when w_sum(7) = '1' else
                   '0';-- not sure either
    
    
        
        
end behavioral;

