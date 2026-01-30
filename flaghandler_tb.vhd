library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity flaghandler_tb is
end flaghandler_tb;

architecture sim of flaghandler_tb is

    signal result      : std_logic_vector(3 downto 0);
    signal carry       : std_logic;
    signal overflow    : std_logic;
    signal signed_mode : std_logic;
    signal flags       : std_logic_vector(3 downto 0);

begin

    uut : entity work.FlagHandler
        port map (
            result      => result,
            carry       => carry,
            overflow    => overflow,
            signed_mode => signed_mode,
            flags       => flags
        );

    stim_proc : process
    begin
        signed_mode <= '0';
        result      <= "0000";
        carry       <= '1';
        overflow    <= '0';
        wait for 100 ns;

        signed_mode <= '1';
        result      <= "1111";
        overflow    <= '0';
        wait for 100 ns;

        wait;
    end process;

end sim;