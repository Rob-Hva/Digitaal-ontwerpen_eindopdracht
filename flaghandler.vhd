library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FlagHandler is
    port (
        result      : in  std_logic_vector(3 downto 0);
        carry       : in  std_logic;
        overflow    : in  std_logic;
        signed_mode : in  std_logic;

        flags       : out std_logic_vector(3 downto 0)  -- C O S Z
    );
end FlagHandler;

architecture Behavioral of FlagHandler is
begin

    process(result, carry, overflow, signed_mode)
        variable C, O, S, Z : std_logic;
    begin
        -- Zero flag
        if result = "0000" then
            Z := '1';
        else
            Z := '0';
        end if;

        -- Sign flag (alleen relevant bij signed mode)
        if signed_mode = '1' then
            S := result(3);  -- MSB
        else
            S := '0';
        end if;

        -- Carry & Overflow
        if signed_mode = '1' then
            C := '0';         -- carry niet relevant bij signed
            O := overflow;
        else
            C := carry;
            O := '0';         -- overflow niet relevant bij unsigned
        end if;

        flags <= C & O & S & Z;
    end process;

end Behavioral;