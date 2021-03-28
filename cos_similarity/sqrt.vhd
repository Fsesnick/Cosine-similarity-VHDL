--https://vhdlguru.blogspot.com/2010/03/vhdl-function-for-finding-square-root.html?m=1

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity sqrt is
Port (
    clk: IN std_logic;
    rst: IN std_logic;
    input: IN std_logic_vector(31 downto 0);
    output: OUT std_logic_vector(15 downto 0);
    done: OUT std_logic
);
end sqrt;

architecture Behavioral of sqrt is

signal left: STD_LOGIC_VECTOR(17 downto 0):="000000000000000000";
signal right: STD_LOGIC_VECTOR(17 downto 0):="000000000000000000";
signal r: STD_LOGIC_VECTOR(17 downto 0):="000000000000000000";
signal a: STD_LOGIC_VECTOR(31 downto 0);
signal q: STD_LOGIC_VECTOR(15 downto 0):=x"0000";
signal i: STD_LOGIC_VECTOR(3 downto 0):="0000";

type stateFSM is (initial, generateLR, computeR, compute, final);
signal state:stateFSM:=initial;
begin

process_state: process(clk, rst)
begin
    if(rst = '1') then
        state <= initial;
        left <= "000000000000000000";
        right <= "000000000000000000";
        r <= "000000000000000000";
        a <= x"00000000";
        q <= x"0000";
        i <= "0000";
    else
        if(rising_edge(clk)) then
            case state is
                when initial => a<=input;
                                state <= generateLR;
                when generateLR => right <= q & r(17) & '1';
                                   left <= r(15 downto 0) & a(31 downto 30);
                                   a(31 downto 2) <= a(29 downto 0);
                                   state <= computeR;
                when computeR =>  if(r(17) = '1') then
                                        r <= left + right;
                                   else
                                        r <= left - right;
                                   end if;
                                   state <= compute;
                when compute => q(15 downto 1) <= q(14 downto 0);
                                q(0) <= not r(17);
                                i <= i+1;
                                if(i = "1111") then
                                    state <= final;
                                else
                                    state <= generateLR;
                                end if;
                when final => done <= '1';
                              output <= q;
            end case;
        end if;
    end if;
end process;
end Behavioral;
