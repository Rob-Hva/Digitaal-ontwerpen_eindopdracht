library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- This will be a testbench for a ALU.

entity ALU_testbench is
end entity ALU_testbench;

architecture testbench of ALU_testbench is

	component ALU is 

		generic (BIT_AMT : integer := 4);

		port(	op 		: in  unsigned(4-1 downto 0);
		  	a 		: in  std_logic_vector(BIT_AMT-1 downto 0);
		  	b 		: in  std_logic_vector(BIT_AMT-1 downto 0);
		  	z		: out std_logic_vector(BIT_AMT-1 downto 0);
		  	carry_in 	: in  std_logic;
		  	carry_out 	: out  std_logic);
	end component;

	constant BIT_AMT : integer := 4;
	constant possible_values : integer := 2 ** BIT_AMT; -- Amount of possible values a N-bit vector can represent.

	signal op	 	: unsigned(4-1 downto 0) := (others => '0');
	signal a 	 	: std_logic_vector(BIT_AMT-1 downto 0) := (others => '0');
	signal b 	 	: std_logic_vector(BIT_AMT-1 downto 0) := (others => '0');
	signal z 	 	: std_logic_vector(BIT_AMT-1 downto 0) := (others => '0');
	signal carry_in 	: std_logic := '0';
	signal carry_out	: std_logic := '0';

begin
	DUT : ALU
		
		generic map(BIT_AMT => BIT_AMT)
		port map(op => op,
	 		 a => a,
			 b => b,
			 z => z,
			 carry_in => carry_in,
			 carry_out => carry_out
			 );

	stimuli : process
	begin
		
		--wait for 10 ns; -- Delay before start

		-- op-code is "0000" INC_A
		-- increment A until max value is reaced
		op <= "0000";
		a <= "0000";
		for i in 1 to possible_values - 1 loop
			wait for 10 ns;
			a <= z;
		end loop;
		
		-- op-code is "0001" DEC_A
		op <= "0001";
		a <= "1111";
		for i in 1 to possible_values - 1 loop
			wait for 10 ns;
			a <= z;
		end loop;

		-- op-code is "0010" ADD_A_B
		op <= "0010";
		a <= "0001";
		b <= "0001";
		for i in 1 to possible_values - 1 loop
			wait for 10 ns;
			a <= z;
		end loop;

		-- op-code is "0011" ADC_A_B
		op <= "0011";
		a <= "0001";
		b <= "0001";
		carry_in <= '1';
		for i in 1 to (possible_values/2) - 1 loop
			wait for 10 ns;
			a <= z;
		end loop;

		-- op-code is "0100" SUB_A_B
		op <= "0100";
		a <= "1111";
		b <= "0001";
		for i in 1 to possible_values - 1 loop
			wait for 10 ns;
			a <= z;
		end loop;

		-- op-code is "0101" SBC_A_B
		op <= "0101";
		a <= "1111";
		b <= "0001";
		carry_in <= '1';
		for i in 1 to (possible_values/2) - 1 loop
			wait for 10 ns;
			a <= z;
		end loop;

		-- op-code is "0110" PASS_A
		op <= "0110";
		a <= "0000";
		for i in 1 to possible_values - 1 loop
			wait for 10 ns;
			a <= std_logic_vector(unsigned(a) + 1);
		end loop;

		-- op-code is "0111" PASS_B
		op <= "0111";
		b <= "0000";
		for i in 1 to possible_values - 1 loop
			wait for 10 ns;
			b <= std_logic_vector(unsigned(b) + 1);
		end loop;

		-- op-code is "1000" AND_A_B
		op <= "1000";
		a <= "0000";
		b <= "1010";
		for i in 0 to possible_values - 1 loop
			wait for 10 ns;
			a <= std_logic_vector(unsigned(a) + 1);
		end loop;

		-- op-code is "1001" OR_A_B
		op <= "1001";
		a <= "0000";
		b <= "1010";
		for i in 0 to possible_values - 1 loop
			wait for 10 ns;
			a <= std_logic_vector(unsigned(a) + 1);
		end loop;

		-- op-code is "1010" XOR_A_B
		op <= "1010";
		a <= "0000";
		b <= "1010";
		for i in 0 to possible_values - 1 loop
			wait for 10 ns;
			a <= std_logic_vector(unsigned(a) + 1);
		end loop;

		-- op-code is "1011" NOT_A
		op <= "1011";
		a <= "0000";
		for i in 0 to possible_values - 1 loop
			wait for 10 ns;
			a <= std_logic_vector(unsigned(a) + 1);
		end loop;

		-- op-code is "1100" SHL_A
		op <= "1100";
		a <= "0000";
		for i in 0 to possible_values - 1 loop
			wait for 10 ns;
			a <= std_logic_vector(to_unsigned(i, BIT_AMT) + 1);
		end loop;

		-- op-code is "1101" ROL_A
		op <= "1101";
		a <= "0000";
		for i in 0 to possible_values - 1 loop
			wait for 10 ns;
			a <= std_logic_vector(to_unsigned(i, BIT_AMT) + 1);
		end loop;

		-- op-code is "1110" SHR_A
		op <= "1110";
		a <= "0000";
		for i in 0 to possible_values - 1 loop
			wait for 10 ns;
			a <= std_logic_vector(to_unsigned(i, BIT_AMT) + 1);
		end loop;

		-- op-code is "1111" ROR_A
		op <= "1111";
		a <= "0000";
		for i in 0 to possible_values - 1 loop
			wait for 10 ns;
			a <= std_logic_vector(to_unsigned(i, BIT_AMT) + 1);
		end loop;

		wait;
	end process stimuli;
end architecture testbench;