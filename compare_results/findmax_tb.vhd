----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/27/2020 11:45:46 PM
-- Design Name: 
-- Module Name: findmax_tb - Behavioral
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

entity findmax_tb is
--  Port ( );
end findmax_tb;

architecture Behavioral of findmax_tb is

component findmax is
port(
           stimulus_1_avrg : in std_logic_vector(31 downto 0);
           stimulus_2_avrg : in std_logic_vector(31 downto 0);
           stimulus_3_avrg : in std_logic_vector(31 downto 0);
           stimulus_4_avrg : in std_logic_vector(31 downto 0);
           max             : out std_logic_vector(3 downto 0)-- (001,010,011,100) templates 1,2,3 e 4
);
end component;
 
signal stimulus_1_avrg : std_logic_vector(31 downto 0):= x"00000000";
signal stimulus_2_avrg : std_logic_vector(31 downto 0):= x"00000000";
signal stimulus_3_avrg : std_logic_vector(31 downto 0):= x"00000000";
signal stimulus_4_avrg : std_logic_vector(31 downto 0):= x"00000000";
signal max             : std_logic_vector(3 downto 0):= x"0";
--constant CLK_PERIOD:time:=10ns;
 
begin
--clk <= not clk after (CLK_PERIOD/2);
 
DUT: findmax port map(
    stimulus_1_avrg => stimulus_1_avrg,
    stimulus_2_avrg => stimulus_2_avrg,
    stimulus_3_avrg => stimulus_3_avrg,
    stimulus_4_avrg => stimulus_4_avrg,
    max             => max
);
 
process
begin
        wait for 10ns;
        stimulus_1_avrg  <= x"ffffffff";
        stimulus_2_avrg  <= x"00000020";
        stimulus_3_avrg  <= x"ffffff65";
        stimulus_4_avrg  <= x"fffffd07";
        wait for 10ns;
        stimulus_1_avrg  <= x"0000007d";
        stimulus_2_avrg  <= x"ffffffdf";
        stimulus_3_avrg  <= x"fffffA52";
        stimulus_4_avrg  <= x"ffffefe3";
        wait for 10ns;
        stimulus_1_avrg  <= x"ffffffaa";
        stimulus_2_avrg  <= x"050aea96";
        stimulus_3_avrg  <= x"050aea96";
        stimulus_4_avrg  <= x"050f170f";
        wait for 10ns;

end process;


end Behavioral;
