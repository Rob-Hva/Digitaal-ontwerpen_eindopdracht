library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Button_Switch is

	generic (BTN_AMT 	: integer := 5;	-- amount of buttons
				DBNC_SMPL_LNGTH  : integer := 8);	-- debounce samples per button	
	port(clk 				: in 	std_logic;
		  rst_n 				: in 	std_logic;
		  button 			: in 	std_logic_vector(BTN_AMT-1 downto 0);
		  pressed			: out std_logic_vector(BTN_AMT-1 downto 0);
		  pressed_event 	: out std_logic_vector(BTN_AMT-1 downto 0);
		  released_event 	: out std_logic_vector(BTN_AMT-1 downto 0);
		  switch 			: out std_logic_vector(BTN_AMT-1 downto 0));
		  
end entity Button_Switch;

architecture behaviour of Button_Switch is 

	constant read_threshold : integer := 50000; 	-- 1ms/20ns = 50000.

	signal pressed_ff				: std_logic_vector(BTN_AMT-1 downto 0) := (others => '1');
	signal pressed_ff_prev 		: std_logic_vector(BTN_AMT-1 downto 0) := (others => '1');
	signal pressed_event_ff		: std_logic_vector(BTN_AMT-1 downto 0) := (others => '1');
	signal released_event_ff	: std_logic_vector(BTN_AMT-1 downto 0) := (others => '1');
	
	signal clk_count	 		: unsigned(16-1 downto 0);										-- 16-bits are needed to store 50000.
	signal sample_pulse		: std_logic := '0';												-- this signal wil be the divided clk.
	signal btn_read		 	: std_logic_vector(BTN_AMT-1 downto 0) := (others => '1');	-- Used to store the read values of each button.
	
	-- Used to store the last few read values of each button.
   type btn_matrix_type is array (0 to BTN_AMT-1) of std_logic_vector(DBNC_SMPL_LNGTH-1 downto 0);
   signal btn_matrix		:	btn_matrix_type := (others => (others => '1'));	
	
	signal switch_ff	: std_logic_vector(BTN_AMT-1 downto 0) := (others => '1');
	
begin

	-- Here the signal of the clock is being devided so that has a lower frequency. 
	-- The new signal should have a period of 1ms.
	-- This signal will later be used to read te button every ms.
	clk_divider : process(clk, rst_n, button) is
	begin
	
		if rst_n = '0' then
			
			clk_count <= (others => '0');
			btn_read <= (others => '1');
			sample_pulse <= '0';
			
		elsif rising_edge(clk) then
		
			if clk_count < read_threshold then
			
				clk_count <= clk_count + 1;
				sample_pulse <= '0';	-- No samples sent yet.
				
			else
			
				btn_read <= button;
				sample_pulse <= '1'; -- New sample!
				clk_count <= (others => '0');
				
			end if;
			
		end if;
		
	end process clk_divider;

	
	
	-- This is a check to determine of a button is being pressed or released.
	-- To do this a matrix is used with a vector for each button.
	-- When this vector is read and all 8 values in it are 0 the button will be considered to be pressed.
	debounce_check : process (clk, rst_n) is
	begin
		
		if rst_n = '0' then
		
			btn_matrix <= (others => (others => '1'));
			pressed_ff <= (others => '1');
			pressed_ff_prev <= (others => '1');
			
		elsif rising_edge(clk) then
		
			if sample_pulse = '1' then
				for i in 0 to BTN_AMT-1 loop
					btn_matrix(i) <= btn_matrix(i)(DBNC_SMPL_LNGTH-2 downto 0) & btn_read(i);	-- Push the read values into the matrix to temporarily store them.
				end loop;
			end if;
			
			-- Check if button is low for te entire [M]ms.
			for i in 0 to BTN_AMT-1 loop
				if btn_matrix(i) = (btn_matrix(i)'range => '0') then
					pressed_ff_prev(i) <= pressed_ff(i);
					pressed_ff(i) <= '0';
				else
					pressed_ff_prev(i) <= pressed_ff(i);	
					pressed_ff(i) <= '1';
				end if;
			end loop;
		end if;
	end process debounce_check;
	
	
	
	press_release_check : process (clk, rst_n, pressed_ff, pressed_ff_prev) is
	begin 
	
		if rst_n = '0' then
		
			pressed_event_ff <= (others => '1');
			released_event_ff <= (others => '1');
			
		elsif rising_edge(clk) then
		
			for i in 0 to BTN_AMT-1 loop
				-- Check if button (i) is being pressed.
				if (pressed_ff(i) = '0') AND (pressed_ff_prev(i) = '1') then
					pressed_event_ff(i) <= '0';
				else 
					pressed_event_ff(i) <= '1';
				end if;
			
				-- Check if button is being released.
				if (pressed_ff(i) = '1') AND (pressed_ff_prev(i) = '0') then
					released_event_ff(i) <= '0';
				else 
					released_event_ff(i) <= '1';
				end if;
			end loop;
		end if;
		
	end process press_release_check;
	
	btn_to_sw : process(clk, rst_n) is
	begin
			
		if rst_n = '0' then
			switch_ff			<= (others =>'1');
	
		elsif rising_edge(clk) then
		
			for i in 0 to BTN_AMT-1 loop
				if pressed_ff(i) = '0' AND pressed_ff_prev(i) = '1' then
				
					-- button pressed! toggle switch
					switch_ff(i) <= NOT switch_ff(i);
					
				end if;
			end loop;
		end if;
	end process btn_to_sw;
		
	pressed <= pressed_ff;
	pressed_event <= pressed_event_ff;
	released_event <= released_event_ff;
	switch <= switch_ff;
	
end architecture behaviour;