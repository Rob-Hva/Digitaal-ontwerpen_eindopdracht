library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- This component will be able to perform additions and subtractions in binairy.
-- It will work with N number of bits.

entity ALU is
	generic (N : integer := 4);
	
	port(op			: in unsigned(4-1 downto 0);  -- This input controls the opperation type.
		  a 			: in std_logic_vector(N-1 downto 0);
		  b 			: in std_logic_vector(N-1 downto 0);
		  z 			: out std_logic_vector(N-1 downto 0);
		  carry_in	: in std_logic;
		  carry_out	: out std_logic);
		  
end entity ALU;

architecture behaviour of ALU is

	constant INC_A 	: unsigned(4-1 downto 0) := "0000"; -- Z = A + 1
	constant DEC_A 	: unsigned(4-1 downto 0) := "0001"; -- Z = A - 1
	constant ADD_A_B 	: unsigned(4-1 downto 0) := "0010"; -- Z = A + B
	constant ADC_A_B 	: unsigned(4-1 downto 0) := "0011"; -- Z = A + B + C_in
	constant SUB_A_B 	: unsigned(4-1 downto 0) := "0100"; -- Z = A - B
	constant SBC_A_B 	: unsigned(4-1 downto 0) := "0101"; -- Z = A - B - C_in
	constant PASS_A 	: unsigned(4-1 downto 0) := "0110"; -- Z = A
	constant PASS_B 	: unsigned(4-1 downto 0) := "0111"; -- Z = B
	
	constant AND_A_B 	: unsigned(4-1 downto 0) := "1000"; -- Z = A AND B
	constant OR_A_B 	: unsigned(4-1 downto 0) := "1001"; -- Z = A OR B
	constant XOR_A_B 	: unsigned(4-1 downto 0) := "1010"; -- Z = A XOR B
	constant NOT_A		: unsigned(4-1 downto 0) := "1011"; -- Z = NOT A
	constant SHL_A		: unsigned(4-1 downto 0) := "1100"; -- Z = SHL A
	constant ROL_A		: unsigned(4-1 downto 0) := "1101"; -- Z = ROL A
	constant SHR_A		: unsigned(4-1 downto 0) := "1110"; -- Z = SHR A
	constant ROR_A		: unsigned(4-1 downto 0) := "1111"; -- Z = ROR A

	signal z_buffer : std_logic_vector(N downto 0);
	
begin
	
	process(op, a, b, carry_in)
	
		variable carry_in_val : signed(N downto 0);
	
	begin	
	
		if carry_in = '1' then
			carry_in_val := to_signed(1, N+1);
		elsif carry_in = '0' then
			carry_in_val := to_signed(0, N+1);
		end if;
		
		case(op) is
		when INC_A =>
			z_buffer <= std_logic_vector(resize(signed(a), N+1) + 1);
		when DEC_A =>
			z_buffer <= std_logic_vector(resize(signed(a), N+1) - 1);
		when ADD_A_B =>
			z_buffer <= std_logic_vector(
								resize(signed(a), N+1) + 
								resize(signed(b), N+1)
							);
		when ADC_A_B =>
			z_buffer <= std_logic_vector(
								resize(signed(a), N+1) + 
								resize(signed(b), N+1) + 
								carry_in_val
							);
		when SUB_A_B =>
			z_buffer <= std_logic_vector(
								resize(signed(a), N+1) -
								resize(signed(b), N+1)
							);
		when SBC_A_B =>
			z_buffer <= std_logic_vector(
								resize(signed(a), N+1) - 
								resize(signed(b), N+1) - 
								carry_in_val
							);
		when PASS_A =>
			z_buffer <= std_logic_vector(resize(signed(a), N+1));
		when PASS_B =>
			z_buffer <= std_logic_vector(resize(signed(b), N+1));
		when AND_A_B =>
			z_buffer <= std_logic_vector(
								resize(signed(a), N+1) AND
								resize(signed(b), N+1)
							);
		when OR_A_B =>
			z_buffer <= std_logic_vector(
								resize(signed(a), N+1) OR
								resize(signed(b), N+1)
							);
		when XOR_A_B =>
			z_buffer <= std_logic_vector(
								resize(signed(a), N+1) XOR
								resize(signed(b), N+1)
							);
		when NOT_A =>
			z_buffer <= std_logic_vector(resize(signed(NOT a), N+1));
		when SHL_A =>
			z_buffer <= std_logic_vector(resize(shift_left(signed(a), 1), N+1));
		when ROL_A =>
			z_buffer <= '0' & (a(N-2 downto 0) & a(N-1));
		when SHR_A =>
			z_buffer <= std_logic_vector(resize(shift_right(unsigned(a), 1), N+1));
		when ROR_A =>
			z_buffer <= '0' & (a(0) & a(N-1 downto 1));
		when others =>
			z_buffer <= (others => 'U');
		end case;
	end process;
	
	z <= z_buffer(N - 1 downto 0);
	
	carry_out <= z_buffer(N);
	
end architecture behaviour;