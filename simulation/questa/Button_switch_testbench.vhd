library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity Button_switch_testbench is
end entity Button_switch_testbench;

architecture testbench of Button_switch_testbench is
	component Button_switch is
		
		generic (N 	: integer := 5;		-- amount of buttons
			 M 	: integer := 8);	-- debounce samples per button

		port(	clk 		: in 	std_logic;
		  	rst_n 		: in 	std_logic;
		  	button 		: in	std_logic_vector(N-1 downto 0);
		  	pressed		: out 	std_logic_vector(N-1 downto 0);
		  	pressed_event 	: out 	std_logic_vector(N-1 downto 0);
		  	released_event 	: out 	std_logic_vector(N-1 downto 0);
			switch		: out 	std_logic_vector(N-1 downto 0));

	end component;
	
	constant N : integer := 5;
	constant M : integer := 8; 
	constant CLOCK_PERIOD : time := 20 ns;
	constant AMOUNT_OF_LOOPS : integer := 10;

	signal clk 	: std_logic := '1';
	signal rst_n 	: std_logic := '1';
	signal button	: std_logic_vector(N-1 downto 0) := (others => '1');
	
	signal pressed 		: std_logic_vector(N-1 downto 0) := (others => '1');
	signal pressed_event 	: std_logic_vector(N-1 downto 0) := (others => '1');
	signal released_event 	: std_logic_vector(N-1 downto 0) := (others => '1');

	signal switch 	: std_logic_vector(N-1 downto 0) := (others => '1');

begin

	DUT : Button_switch

		generic map(N => N)
		port map(clk => clk,
	 		 rst_n => rst_n,
			 button => button,
			 pressed => pressed,
			 pressed_event => pressed_event,
			 released_event => released_event,
			 switch => switch
			 );

	clk <= not clk after 0.5 * CLOCK_PERIOD;

	stimuli: process

		variable seed1, seed2 : positive := 1;
    		variable rand_real : real;

	begin
		rst_n <= '0';

		wait for 0.25 * CLOCK_PERIOD;

		rst_n <= '1';
		
		for i in 0 to AMOUNT_OF_LOOPS loop
			-- Here debounce is being simulated by genarating random bursts.
			for i in 0 to 5000 loop
       		 		uniform(seed1, seed2, rand_real);
				button <= not button;	

				for j in 0 to integer(rand_real * 10.0) loop
        				wait until rising_edge(clk);
				end loop;
    			end loop;
		
			-- Here te debounce is gone and the button is being pressed.
			button <= (others => '0');
		
			wait for 500000 * CLOCK_PERIOD;

			-- Here debounce is being simulated by genarating random bursts.
			for i in 0 to 5000 loop
        			uniform(seed1, seed2, rand_real);
				button <= not button;

				for j in 0 to integer(rand_real * 10.0) loop
        				wait until rising_edge(clk);
				end loop;
    			end loop;

			-- People usually dont press infinitely fast.
			button <= (others => '1');
		
			wait for 500000 * CLOCK_PERIOD;
		end loop;
		wait;
	end process stimuli;
end architecture testbench;