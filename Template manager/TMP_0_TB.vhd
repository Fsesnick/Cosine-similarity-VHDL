----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/17/2020 06:16:46 PM
-- Design Name: 
-- Module Name: TMP_0_TB - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TMP_0_TB is
--  Port ( );
end TMP_0_TB;

architecture Behavioral of TMP_0_TB is

component TMP_0 is
    port (
        clk  : in  std_logic;  -- A 100MHz clock
        rst  : in  std_logic;
        CH_N : in  std_logic_vector( 7 downto 0);
        ADDR : IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
        DATA : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
end component;

signal clk   : std_logic:='0';
signal reset : std_logic:='0';
signal CH_N  : std_logic_vector(7 downto 0) := x"00";
signal ADDR  : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000000";
signal DATA  : STD_LOGIC_VECTOR(15 DOWNTO 0);


constant CLK_PERIOD:time:=10ns;

begin

clk <= not clk after (CLK_PERIOD/2);

DUT: TMP_0 port map (
    clk  => clk,
    rst  => reset,
    CH_N => CH_N,
    ADDR => ADDR,
    DATA => DATA
);
gen_vect_process: process
begin

    wait for 3ns;
    CH_N <=  X"01";
    ADDR <= "000001";
    
    wait for 30ns;   
    CH_N <=  X"01";
    ADDR <= "000010";
    
    wait for 30ns; 
    CH_N <=  X"00";
    ADDR <= "000011";
    
    wait for 30ns;
    CH_N <=  X"00";
    ADDR <= "000101";
    
    wait for 30ns;
end process;

end Behavioral;
