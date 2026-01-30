library ieee;
use ieee.std_logic_1164.all;

entity ALU_testapplicatie is
	
	generic(	BIT_AMT 	: integer := 4;	--Amount of bits.
				BTN_AMT 	: integer := 5;	--Amount of buttons.
				KEY_AMT 	: integer := 2);	--Amount of keys.
   port(	clk    	: in  std_logic;
			rst_n  	: in  std_logic;
			buttons	: in 	std_logic_vector(BTN_AMT-1 downto 0);
			keys		: in 	std_logic_vector(KEY_AMT-1 downto 0);
			a			: in	std_logic_vector(BIT_AMT-1 downto 0);
			b			: in	std_logic_vector(BIT_AMT-1 downto 0);
			carry_in : in  std_logic;
			z			: out std_logic_vector(BIT_AMT-1 downto 0));
			
end entity ALU_testapplicatie;

architecture behavioral of ALU_testapplicatie is


	-- Button_switch --
   component Button_switch is
		generic (BTN_AMT				: integer := BTN_AMT;
					DBNC_SMPL_LNGTH 	: integer := 8);
			port (clk            : in  std_logic;
					rst_n          : in  std_logic;
					button         : in  std_logic_vector(BTN_AMT-1 downto 0);
					pressed        : out std_logic_vector(BTN_AMT-1 downto 0);
					pressed_event  : out std_logic_vector(BTN_AMT-1 downto 0);
					released_event	: out std_logic_vector(BTN_AMT-1 downto 0);
					switch			: out std_logic_vector(BTN_AMT-1 downto 0)
        );
   end component;
	
	signal btn_sw_output : std_logic_vector(BTN_AMT-1 downto 0);
   signal btn_to_op 		: std_logic_vector(BTN_AMT-2 downto 0);
	 
	 
	 -- ALU --
	component ALU is
		generic (BIT_AMT	: integer := BIT_AMT);
		port (op           	: in  std_logic_vector(4-1 downto 0);
				a          		: in  std_logic_vector(BIT_AMT-1 downto 0);
				b         		: in std_logic_vector(BIT_AMT-1 downto 0);
				z   				: out std_logic_vector(BIT_AMT-1 downto 0);
				carry_in 		: in std_logic;
				carry_out 		: out std_logic);
   end component;
	
	
	-- N-bit_register --
   component Nbit_register is
		generic (N	: integer := 4);
				port(	rst_n	: in 	std_logic;
						clk 	: in 	std_logic;
						D 		: in 	std_logic_vector(N-1 downto 0);
						Q 		: out std_logic_vector(N-1 downto 0));
   end component;
	
	signal a_ff	: std_logic_vector(BIT_AMT-1 downto 0);
	signal b_ff	: std_logic_vector(BIT_AMT-1 downto 0);
	 
begin
    -- instantiate button_switch --
	btn_sw : button_switch
		generic map(BTN_AMT => BTN_AMT,
						DBNC_SMPL_LNGTH => 8)
		port map(clk            => clk,
					rst_n          => rst_n,
					button         => buttons,
					pressed        => open,
					pressed_event	=> open,
					released_event	=> open,
					switch			=> btn_sw_output);
				
	btn_to_op <= btn_sw_output(BTN_AMT-2 downto 0);
				
	-- instantiate key button_switch --
	keys_sw : button_switch
		generic map (BTN_AMT => KEY_AMT,
			DBNC_SMPL_LNGTH => 8)
		port map(
				clk            => clk,
            rst_n          => rst_n,
            button         => keys,
            pressed        => open,
            pressed_event	=> open,
            released_event	=> open,
				switch			=> open);
		 
	
	-- instantiate a register --
	a_register : Nbit_register
		generic map(N => BIT_AMT)
		port map(rst_n	=> rst_n,
					clk 	=> clk,
					D 		=> a,
					Q 		=> a_ff);
					
	-- instantiate b register --
	b_register : Nbit_register
		generic map(N => BIT_AMT)
		port map(rst_n	=> rst_n,
					clk 	=> clk,
					D 		=> b,
					Q 		=> b_ff);
	
	
	-- instantiate ALU --
	ALU_inst : ALU
		generic map (BIT_AMT => BIT_AMT)
		port map (op			=> btn_to_op,
					 a				=>	a_ff,
					 b	  			=>	b_ff,
					 z				=>	z,
					 carry_in	=>	carry_in,
					 carry_out	=>	open);

end architecture behavioral;