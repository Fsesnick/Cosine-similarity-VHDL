library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity DivEx_TB is
--Port ( );
end DivEx_TB;
 
architecture Behavioral of DivEx_TB is
 
component DivEx is
port(
    X   : in STD_LOGIC_VECTOR(31 downto 0);
    Y   : in STD_LOGIC_VECTOR(31 downto 0);
    R   : out STD_LOGIC_VECTOR(31 downto 0)
);
end component;
 
signal X : STD_LOGIC_VECTOR(31 downto 0);
signal Y : STD_LOGIC_VECTOR(31 downto 0);
signal R : STD_LOGIC_VECTOR(31 downto 0);
 
--constant CLK_PERIOD:time:=10ns;
 
begin
--clk <= not clk after (CLK_PERIOD/2);
 
DUT: DivEx port map(
    X => X,
    Y => Y,
        R => R
);
 
process
begin
        X <= x"00002710";
        Y <= x"00000005";
        wait for 10ns;
        X <= x"00002711";
        Y <= x"00000005";
        wait for 10ns;
        X <= x"00000bb8";
        Y <= x"00000002";
        wait for 10ns;
end process;
 
end Behavioral;