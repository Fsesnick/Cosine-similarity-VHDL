library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sqrt_TB is
--Port ( );
end sqrt_TB;

architecture Behavioral of sqrt_TB is

component sqrt is
Port (
    clk: IN std_logic;
    rst: IN std_logic;
    input: IN std_logic_vector(31 downto 0);
    output: OUT std_logic_vector(15 downto 0);
    done: OUT std_logic
);
end component;

signal clk: std_logic:='0';
signal rst: std_logic:='0';
signal input: std_logic_vector(31 downto 0):=x"00000000";
signal output: std_logic_vector(15 downto 0):=x"0000";
signal done: std_logic:='0';

constant CLK_PERIOD:time:=10ns;
begin
clk <= not clk after (CLK_PERIOD/2);

DUT: sqrt port map(
    clk => clk,
    rst => rst,
    input => input,
    output => output,
    done => done
);


gen_vect_process: process
begin
    input <= x"00005100";
    wait for 5000ns;
end process;

end Behavioral;
