library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity UART_RX is
  port (
    clk     : in  std_logic;  -- A 100MHz clock
    rst     : in  std_logic;
    RX      : in  std_logic;
    RX_DATA : out std_logic_vector(7 downto 0);
    NEW_DATA: out std_logic
  );
end entity UART_RX;

architecture behavioural of UART_RX is
  signal start            : std_logic := '0';
  signal bit_number       : std_logic_vector(3 downto 0);
  signal RX_REG           : std_logic_vector(7 downto 0);
  signal baudrate_counter : std_logic_vector(9 downto 0);
  signal middle_of_the_bit: std_logic;
begin
  -- check start bit
  process(clk)
  begin
    if(clk'event and clk='1') then
      if(rst = '1') then
        start      <= '0';
        bit_number <= (others => '0');
        RX_REG     <= (others => '0');
        RX_DATA    <= (others => '0');
        NEW_DATA   <= '0';
      else
        if(RX = '0') then
          start <= '1';
        end if;

        if(start = '1') then
          if(middle_of_the_bit = '1') then
            bit_number <= bit_number + 1;

            case bit_number is
              -- when X"0" => START_BIT <= RX;
              when X"1" => RX_REG(0) <= RX;
              when X"2" => RX_REG(1) <= RX;
              when X"3" => RX_REG(2) <= RX;
              when X"4" => RX_REG(3) <= RX;
              when X"5" => RX_REG(4) <= RX;
              when X"6" => RX_REG(5) <= RX;
              when X"7" => RX_REG(6) <= RX;
              when X"8" => RX_REG(7) <= RX;
              when X"9" => start     <= '0';
                RX_DATA    <= RX_REG;
                NEW_DATA   <= '1';
                bit_number <= (others => '0');
              when others => null;
            end case;                
          end if;
        else
          NEW_DATA   <= '0';
        end if;
      end if;
    end if;
  end process;

  -- baudrate generator
  process(clk)
  begin
    if(clk'event and clk='1') then
      if(rst = '1' or start = '0') then
        baudrate_counter  <= (others => '0');
        middle_of_the_bit <= '0';
      elsif(start = '1') then
        if(baudrate_counter < (868-1)) then
          baudrate_counter <= baudrate_counter + 1;
        else
          baudrate_counter <= (others => '0');
        end if;

        if(baudrate_counter = 434) then
          middle_of_the_bit <= '1';
        else
          middle_of_the_bit <= '0';
        end if;
      end if;
    end if;
  end process;
end behavioural;



