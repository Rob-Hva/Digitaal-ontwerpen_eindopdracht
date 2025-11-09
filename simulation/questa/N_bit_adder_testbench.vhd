library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- This will be a testbench for a N-bit adder.

entity N_bit_adder_testbench is
end entity N_bit_adder_testbench;

architecture testbench of N_bit_adder_testbench is

	component N_bit_adder is 

		generic (N : integer := 8);

		port(	op 		: in  std_logic;
		  	a 		: in  std_logic_vector(N-1 downto 0);
		  	b 		: in  std_logic_vector(N-1 downto 0);
		  	z		: out std_logic_vector(N-1 downto 0));
	end component;

	constant N : integer := 8;
	constant possible_values : integer := 2 ** N ; -- Amount of possible values a N-bit vector can represent.

	signal op : std_logic := '0';
	signal a  : std_logic_vector(N-1 downto 0) := (others => '0');
	signal b  : std_logic_vector(N-1 downto 0) := (others => '0');
	signal z  : std_logic_vector(N-1 downto 0) := (others => '0');

begin

	DUT : N_bit_adder
		
		generic map(N => N)
		port map(op => op,
	 		 a => a,
			 b => b,
			 z => z
			 );

	op <= NOT op after 10 ns;

	stimuli : process
	begin
		wait for 20 ns;
		
		-- Create every possible comination.
		for i in 0 to possible_values - 1 loop

			a <= (others => '0');
			for j in 0 to possible_values - 1 loop
				a <= std_logic_vector(unsigned(a) + 1);
				wait for 20 ns;
			end loop;
			b <= std_logic_vector(unsigned(b) + 1);

		end loop;

		wait;

	end process stimuli;
end architecture testbench;
	
