library IEEE;
use IEEE.std_logic_1164.all;

entity avg_testbench is
end entity;

architecture stimulus of avg_testbench is
  component avg is
  port (clk, reset : in std_logic;
        result     : in std_logic_vector(31 downto 0);
	    avrg       : out std_logic_vector(31 downto 0);
	    ch_number  : in std_logic_vector(7 downto 0);
        avr_done   : out std_logic);
  end component;

  signal clk       : std_logic := '0'; -- must be initialized for clk_gen to work
  signal reset     : std_logic;   
  signal result    : std_logic_vector(31 downto 0);
  signal avrg      : std_logic_vector(31 downto 0);
  signal ch_number : std_logic_vector(7 downto 0);
  signal avr_done  : std_logic;

constant CLK_PERIOD:time:=10ns;

begin
clk <= not clk after (CLK_PERIOD/2);

  DUT : avg port map(
    clk => clk, 
    reset => reset, 
    result => result, 
    avrg => avrg, 
    ch_number => ch_number, 
    avr_done => avr_done);

 
 gen_vect_process :process
 begin
          
        wait for 10ns;
        result <= x"00000001";
        ch_number <= x"00";

        wait for 10ns;
        result <= x"00000002";
        ch_number <= x"01";  
        
        wait for 10ns;        
        result <= x"00000003";
        ch_number <= x"02";  
        
        wait for 10ns;
        result <= x"00000004";
        ch_number <= x"03";
          
        wait for 10ns;
        result <= x"00000005";
        ch_number <= x"04";  
        
        wait for 10ns;
        result <= x"00000006";
        ch_number <= x"05";  
        
        wait for 10ns;
        result <= x"00000007";
        ch_number <= x"06";  
        
        wait for 10ns;
        result <= x"00000008";
        ch_number <= x"07";  
        
        wait for 10ns;
        result <= x"00000009";
        ch_number <= x"08";  
        
        wait for 10ns;
        result <= x"0000000a";
        ch_number <= x"09";  
        wait for 300ns;
end process;


end architecture;
