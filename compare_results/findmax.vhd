---------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity findmax is
    Port ( stimulus_1_avrg : in std_logic_vector(31 downto 0);
           stimulus_2_avrg : in std_logic_vector(31 downto 0);
           stimulus_3_avrg : in std_logic_vector(31 downto 0);
           stimulus_4_avrg : in std_logic_vector(31 downto 0);
           max             : out std_logic_vector(3 downto 0));-- (001,010,011,100) templates 1,2,3 e 4
end findmax;

architecture Behavioral of findmax is

begin
process (stimulus_1_avrg,stimulus_2_avrg,stimulus_3_avrg,stimulus_4_avrg)
begin
         if (stimulus_1_avrg> stimulus_2_avrg)and (stimulus_1_avrg> stimulus_3_avrg)and (stimulus_1_avrg>stimulus_4_avrg) then
                    max <= x"1";
         
         elsif (stimulus_2_avrg> stimulus_1_avrg)and (stimulus_2_avrg> stimulus_3_avrg)and (stimulus_2_avrg>stimulus_4_avrg)then
                    max <= x"2";
                       
         elsif  (stimulus_3_avrg> stimulus_1_avrg)and (stimulus_3_avrg> stimulus_2_avrg)and (stimulus_3_avrg>stimulus_4_avrg)then
                    max<=   x"3";
         elsif (stimulus_4_avrg> stimulus_1_avrg)and (stimulus_4_avrg> stimulus_2_avrg)and (stimulus_4_avrg>stimulus_3_avrg)then
                    max <=  x"4";    
         else
                    max <= x"0";
         end if;
end process;


end Behavioral;
