library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity avg is
  port (clk, reset : in std_logic;
        result     : in std_logic_vector(31 downto 0);
	    avrg       : out std_logic_vector(31 downto 0);
	    ch_number  : in std_logic_vector(7 downto 0);
        avr_done   : out std_logic);
end entity;

architecture behavioural of avg is
begin
  process(clk)
    variable samples : integer;
    variable sample1, sample2, sample3, sample4,
	         sample5, sample6, sample7, sample8,
	         sample9, sample10 : unsigned(31 downto 0);
  begin
    if(rising_edge(clk)) then
      if(reset = '1') then
        samples := 1;
        avr_done <= '0';
        sample10 := (others => '0');
        sample9 := (others => '0');
        sample8 := (others => '0');
        sample7 := (others => '0');
        sample6 := (others => '0');
        sample5 := (others => '0');
        sample4 := (others => '0');
        sample3 := (others => '0');
        sample2 := (others => '0');
        sample1 := unsigned(result);
      else
        samples := samples + 1;
        sample10 := sample9;
        sample9 := sample8;
        sample8 := sample7;
        sample7 := sample6;
        sample6 := sample5;
        sample5 := sample4;
        sample4 := sample3;
        sample3 := sample2;
        sample2 := sample1;
        sample1 := unsigned(result);
        
     if (ch_number = X"09") then
          avr_done <= '1';
 	 
 	 avrg <= std_logic_vector((sample1 + sample2 + sample3 + sample4+sample5+sample6+sample7+sample8+sample9
					+ sample10) / 10); --edited
        else
          avr_done <= '0';
        end if;
      end if;
    end if;
  end process;
end architecture;
