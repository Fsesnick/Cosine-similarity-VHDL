library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity similarity_TB is
--  Port ( );
end similarity_TB;

architecture Behavioral of similarity_TB is

component similarity is
Port (
    clk: IN std_logic;
    reset: IN std_logic;
    start: IN std_logic;
    result: OUT std_logic_vector(31 downto 0)
);
end component;

signal clk: std_logic:='0';
signal reset: std_logic:='0';
signal start: std_logic:='0';
signal result: std_logic_vector(31 downto 0):=x"00000000";

constant CLK_PERIOD:time:=10ns;

begin

clk <= not clk after (CLK_PERIOD/2);

DUT: similarity port map (
    clk => clk,
    reset => reset,
    start => start,
    result => result
);

gen_vect_process: process
begin
    wait for 1000ns;
    reset <= '1';
    wait for 10ns;
    reset <= '0';
    wait for 10ns;
    start <= '1';
    wait for 1us;    
    start <= '0';
    wait for 10ns;
    
end process;
end Behavioral;
