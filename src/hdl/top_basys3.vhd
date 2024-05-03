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
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity top_basys3 is
    port(
        -- inputs
        clk     :   in std_logic; -- native 100MHz FPGA clock
        sw      :   in std_logic_vector(7 downto 0);
        btnU    :   in std_logic; -- fsm reset
        btnC    :   in std_logic; -- advance state machine
        
        -- outputs
        led :   out std_logic_vector(15 downto 0);
        -- 7-segment display segments (active-low cathodes)
        seg :   out std_logic_vector(6 downto 0);
        -- 7-segment display active-low enables (anodes)
        an  :   out std_logic_vector(3 downto 0)
    );
end top_basys3;

architecture top_basys3_arch of top_basys3 is 
  
	-- declare components and signals
	
    component controller_fsm is
        port (
            i_reset : in std_logic;
            i_adv : in std_logic;
            o_cycle : out std_logic_vector(3 downto 0)
            
        );
    end component controller_fsm;
    
    component ALU is
        port (
            i_A : in std_logic_vector(7 downto 0);
            i_B : in std_logic_vector(7 downto 0);
            i_op : in std_logic_vector(2 downto 0);
            o_flags : out std_logic_vector(2 downto 0); -- correct?
            o_result : out std_logic_vector(7 downto 0)
        );
    end component ALU;
    
    component twoscomp_decimal is
        port (
            i_bin : in std_logic_vector(7 downto 0);
            o_sign : out std_logic_vector(3 downto 0);
            o_hund : out std_logic_vector(3 downto 0);
            o_tens : out std_logic_vector(3 downto 0);
            o_ones : out std_logic_vector(3 downto 0)
        );
    end component twoscomp_decimal;
    
    -- don't need?
    component mux is
        port (
            i_A : in std_logic_vector(7 downto 0);
            i_B : in std_logic_vector(7 downto 0);
            i_C : in std_logic_vector(7 downto 0);
            i_S : in std_logic_vector(3 downto 0);
            o_Y : out std_logic_vector(7 downto 0)
        );
    end component mux;
    
    component sevenSegDecoder is 
    
        Port ( 
            i_D : in STD_LOGIC_VECTOR (3 downto 0);
            o_S : out STD_LOGIC_VECTOR (6 downto 0));
    
    end component sevenSegDecoder;
    
    component clock_divider is
    
        generic (constant k_DIV : natural := 4); 
    
            port (  i_clk    : in std_logic;
                    --i_reset  : in std_logic; don't need?          
                    o_clk    : out std_logic         
            );
    
    end component clock_divider;
    
    component TDM4 is
    
        generic ( constant k_WIDTH : natural  := 4); -- bits in input and output
    
            Port ( i_clk        : in  STD_LOGIC;
    
--i_reset        : in  STD_LOGIC; -- asynchronous
    
                   i_D3         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
    
                   i_D2         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
    
                   i_D1         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
    
                   i_D0         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
    
                   o_data        : out STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
    
                   o_sel        : out STD_LOGIC_VECTOR (3 downto 0)    -- selected data line (one-cold)
    
            );
    
    end component TDM4;
    
    component reg is
        port (
            i_reset : in std_logic;
            i_set : in std_logic_vector(3 downto 0); -- need for cycle input at top?
            i_D : in std_logic_vector(7 downto 0);
            o_Q : out std_logic_vector(7 downto 0)
        );
    end component reg;
    
    -- signals
    signal w_cycle : std_logic_vector(3 downto 0);
    signal w_regA : std_logic_vector(7 downto 0);
    signal w_regB : std_logic_vector(7 downto 0);
    signal w_result : std_logic_vector(7 downto 0);
    signal w_bin : std_logic_vector(7 downto 0);
    signal w_sign : std_logic_vector(3 downto 0);
    signal w_flags : std_logic_vector(2 downto 0);
    signal w_clk : std_logic;
    signal w_hund : std_logic_vector(3 downto 0);
    signal w_tens : std_logic_vector(3 downto 0);
    signal w_ones : std_logic_vector(3 downto 0);
    signal w_D : std_logic_vector(3 downto 0);
  
begin
	-- PORT MAPS ----------------------------------------
    controller_fsm_inst : controller_fsm
    port map (
        i_reset => btnU,
        i_adv => btnC,
        o_cycle => w_cycle
    );
    
    ALU_inst : ALU
    port map (
        i_A => w_regA,
        i_B => w_result,
        i_op(0) => sw(0),
        i_op(1) => sw(1),
        i_op(2) => sw(2),
        o_flags => w_flags,
        o_result => w_result
    );
    
    sevenSegDecoder_inst : sevenSegDecoder
    port map (
        i_D => w_D,
        o_S => seg
    );
    
    TDM4_inst : TDM4
    port map (
        i_clk => w_clk,
        i_D3 => w_sign,
        i_D2 => w_hund,
        i_D1 => w_tens,
        i_D0 => w_ones,
        o_data => w_D,
        o_sel => an
    );
    
    twoscomp_decimal_inst : twoscomp_decimal
    port map (
        i_bin => w_bin,
        o_sign => w_sign,
        o_hund => w_hund,
        o_tens => w_tens,
        o_ones => w_ones
    );
    
    clk_div_inst : clock_divider
    port map (
        i_clk => clk,
        o_clk => w_clk
    );
    
    regA_inst : reg
    port map (
        i_D => sw,
        i_reset => btnU,
        i_set => w_cycle
    );
    
    regB_inst : reg
    port map (
        i_D => sw,
        i_reset => btnU,
        i_set => w_cycle
    );
        
    
	
	
	-- CONCURRENT STATEMENTS ----------------------------
	
	-- shut off any anodes? (far left is only used for negative sign when needed)
	
	
	-- LEDs
	led(15) <= w_flags(0);
	led(14) <= w_flags(1);
	led(13) <= w_flags(2);
	led(3) <= w_cycle(3);
	led(2) <= w_cycle(2);
	led(1) <= w_cycle(1);
	led(0) <= w_cycle(0);
	
end top_basys3_arch;
