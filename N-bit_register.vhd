library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Nbit_register is

	generic (N 	: integer := 4);
	port(		rst_n	: in 	std_logic;
				clk 	: in 	std_logic;
				D 		: in 	std_logic_vector(N-1 downto 0);
				Q 		: out std_logic_vector(N-1 downto 0));
				
end entity Nbit_register;

architecture behaviour of Nbit_register is

	signal Q_ff	:	std_logic_vector(N-1 downto 0);

begin

	Nbit_reg : process(clk, rst_n) is
	begin
	
		if rst_n = '0' then
			Q_ff <= (others => '0');
		elsif rising_edge(clk) then
			Q_ff <= D;
		end if;
	end process Nbit_reg;
	
	Q <= Q_ff;
end architecture behaviour;