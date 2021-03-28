--https://agenda.infn.it/event/6549/attachments/45954/54424/RAMs_-_FIFOs_-_Coregen.pdf

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity similarity is
Port (
    clk: IN std_logic;
    reset: IN std_logic;
    start: IN std_logic;
    result: OUT std_logic_vector(31 downto 0)
);
end similarity;

architecture Behavioral of similarity is

component sqrt is
Port (
    clk: IN std_logic;
    rst: IN std_logic;
    input: IN std_logic_vector(31 downto 0);
    output: OUT std_logic_vector(15 downto 0);
    done: OUT std_logic
);
end component;

component DivEx is
    port ( 
     X    : in STD_LOGIC_VECTOR(31 downto 0);
     Y    : in STD_LOGIC_VECTOR(31 downto 0);
     R    : out STD_LOGIC_VECTOR(31 downto 0)
           );
end component;

COMPONENT blk_mem_t --A
    PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END COMPONENT;

COMPONENT blk_mem_r --B
    PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
 
END COMPONENT;

signal   BRAM_WE                   : std_logic_vector( 0 downto 0) := (others => '0');
signal   address                   : STD_LOGIC_VECTOR(5 downto 0)  := (others => '0');
signal   BRAM_A_dout               : std_logic_vector(15 downto 0);
signal   BRAM_B_dout               : std_logic_vector(15 downto 0);

--signal ROM_out_b : integer;
--to_integer(signed(BRAM_dout)=> ROM_out_b ;

signal numerator: STD_LOGIC_VECTOR(31 downto 0):=x"00000000";
signal denominator: STD_LOGIC_VECTOR(31 downto 0):=x"00000000";

signal sum_square_Ai: STD_LOGIC_VECTOR(31 downto 0):=x"00000000";
signal sum_square_Bi: STD_LOGIC_VECTOR(31 downto 0):=x"00000000";

signal final_result: STD_LOGIC_VECTOR(31 downto 0):=x"00000000";

signal Ai_x_Bi: STD_LOGIC_VECTOR(31 downto 0);

signal square_Ai: STD_LOGIC_VECTOR(31 downto 0);
signal square_Bi: STD_LOGIC_VECTOR(31 downto 0);

signal done_square_A: std_logic:='0';
signal done_square_B: std_logic:='0';

signal sqrt_Ai: std_logic_vector(15 downto 0):=x"0000";
signal sqrt_Bi: std_logic_vector(15 downto 0):=x"0000";

signal product_of_squares: std_logic_vector(31 downto 0):=x"00000000";
signal rstSqrt:std_logic:='1';
--signal final_ready :std_logic := '0';

type state is (idle, compute, startSquareRoots, computeSquareRoots, final);
signal crtState:state:=idle;

signal factor : integer:= 512;

begin

    
Ai_x_Bi   <= (BRAM_A_dout * BRAM_B_dout);

square_Ai <= BRAM_A_dout * BRAM_A_dout;
square_Bi <= BRAM_B_dout * BRAM_B_dout;

ROM_B : blk_mem_r
   PORT MAP (
        clka  => clk,
        ena   => '1',
        addra => address,
        douta => BRAM_B_dout
);
    
ROM_A : blk_mem_t
   PORT MAP (
        clka  => clk,
        ena   => '1',
        addra => address,
        douta => BRAM_A_dout
);
    
state_process: process(clk, reset,address)
begin

     --   if(rising_edge(clk)) then
     if clk'event and clk = '1' then
     
          if(reset = '1') then
             crtState <= idle;
           else
    
          case crtState is
                when idle => if(start = '1') then
                                crtState <= compute;
                             end if;
                          --   final_ready <= '0';
                when compute => address <= address + 1;
                                numerator <= numerator + Ai_x_Bi;
                                sum_square_Ai <= sum_square_Ai + square_Ai;
                                sum_square_Bi <= sum_square_Bi + square_Bi;
                                if(address = "111111") then
                                    crtState <= startSquareRoots;
                                end if;
                             --   final_ready <= '0';
                when startSquareRoots => rstSqrt <= '0';
                                         crtState    <= computeSquareRoots;
                                      --   final_ready <= '0';
                when computeSquareRoots => if(done_square_A = '1' and done_square_B = '1') then
                                                denominator <= sqrt_Ai * sqrt_Bi;
                                                crtState <= final;
                                            end if;
                           --   final_ready <= '0';
                when final =>null;
               end case;
        end if;
    end if;
end process;

result <= final_result when crtState = final else x"00000000";

square_root_sum_Ai: sqrt port map(
    clk => clk,
    rst => rstSqrt,
    input => sum_square_Ai,
    output => sqrt_Ai,
    done => done_square_A
);

square_root_sum_Bi: sqrt port map(
    clk => clk,
    rst => rstSqrt,
    input => sum_square_Bi,
    output => sqrt_Bi,
    done => done_square_B
);


compute_similarity: DivEx port map(
 
    X => numerator,
    Y => denominator,
    R => final_result
);
end Behavioral;
