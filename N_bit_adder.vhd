library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- This component will be able to perform additions and subtractions in binairy.
-- It will work with N number of bits.

entity N_bit_adder is
	generic (N : integer := 8);
	
	port(op			: in std_logic;  -- This input controls the opperation type. '0' = addition and '1' = subtraction.
		  a 			: in std_logic_vector(N-1 downto 0);
		  b 			: in std_logic_vector(N-1 downto 0);
		  z 			: out std_logic_vector(N-1 downto 0);
		  carry_out	: out std_logic);
		  
end entity N_bit_adder;

architecture behaviour of N_bit_adder is

	signal z_buffer : std_logic_vector(N downto 0);
	
begin
	
	 
	z_buffer <= 	std_logic_vector(resize(signed(a), N+1) + resize(signed(b), N+1)) when op = '0' else
						std_logic_vector(resize(signed(a), N+1) - resize(signed(b), N+1)) when op = '1' else
						(others => 'U');
	
	z <= z_buffer(N - 1 downto 0);
	
	carry_out <= z_buffer(N);
	
end architecture behaviour;