library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- This will be a testbench for a ALU.

entity Nbit_register_testbench is
end entity Nbit_register_testbench;

architecture testbench of Nbit_register_testbench is

	component Nbit_register is 

		generic (N : integer := 4);

		port(	rst_n 		: in	std_logic;
		  	clk 		: in 	std_logic;
		  	D 		: in	std_logic_vector(N-1 downto 0);
		  	Q		: out	std_logic_vector(N-1 downto 0));
	end component;

	constant CLOCK_PERIOD 		: time := 20 ns;
	constant N 			: integer := 4;
	constant possible_values 	: integer := 2 ** N; -- Amount of possible values a N-bit vector can represent.

	signal	rst_n 	:	std_logic := '1';
	signal	clk 	: 	std_logic := '0';
	signal	D	:	std_logic_vector(N-1 downto 0) := (others => '0');
	signal	Q	:	std_logic_vector(N-1 downto 0) := (others => '0');

begin
	DUT : Nbit_register
		
		generic map(N => N)
		port map(rst_n => rst_n,
	 		 clk => clk,
			 D => D,
			 Q => Q);

	clk <= not clk after 0.5 * CLOCK_PERIOD;

	stimuli : process
	begin
		rst_n <= '1';
		for i in 1 to possible_values - 1 loop
			wait for 20 ns;
			D <= std_logic_vector(to_unsigned(i, N));
		end loop;
		
		wait;
	end process stimuli;
end architecture testbench;