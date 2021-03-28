library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity UART_TX is
  port (
    clk     : in  std_logic;  -- A 100MHz clock
    rst     : in  std_logic;
    TX_DATA : in  std_logic_vector(7 downto 0);
    START_TX: in  std_logic;
    TX      : out std_logic;
    BUSY    : out std_logic
  );
end entity UART_TX;

architecture behavioural of UART_TX is
  signal s_busy          : std_logic := '0';
  signal bit_number      : std_logic_vector(3 downto 0);
  signal TX_REG          : std_logic_vector(7 downto 0);
  signal baudrate_counter: std_logic_vector(9 downto 0);
  signal next_bit        : std_logic;
begin
  process(clk)
  begin
    if(clk'event and clk='1') then
      if(rst = '1') then
        TX         <= '1';  -- idle
        s_busy     <= '0';
        TX_REG     <= (others => '0');
        bit_number <= (others => '0');
      else
        if(START_TX = '1') then
          s_busy <= '1';
          TX_REG <= TX_DATA;
        end if;

        if(s_busy = '1') then
          if(next_bit = '1') then
            bit_number <= bit_number + 1;

            case bit_number is
              when X"0" => TX <= '0';        -- start bit
              when X"1" => TX <= TX_REG(0);  -- LSb
              when X"2" => TX <= TX_REG(1);
              when X"3" => TX <= TX_REG(2);
              when X"4" => TX <= TX_REG(3);
              when X"5" => TX <= TX_REG(4);
              when X"6" => TX <= TX_REG(5);
              when X"7" => TX <= TX_REG(6);
              when X"8" => TX <= TX_REG(7);  -- MSb
              when X"9" => TX <= '1';        -- stop bit
              when X"A" =>                   -- idle
                s_busy     <= '0';
                bit_number <= (others => '0');
              when others => null;
            end case;                
          end if;
        end if;
      end if;
    end if;
  end process;

  -- baudrate generator
  process(clk)
  begin
    if(clk'event and clk='1') then
      if(rst = '1') then
        baudrate_counter <= (others => '0');
        next_bit         <= '0';
      else
        if(s_busy = '1') then
          if(baudrate_counter < (868-1)) then
            baudrate_counter <= baudrate_counter + 1;
            next_bit         <= '0';
          else
            baudrate_counter <= (others => '0');
            next_bit         <= '1';
          end if;
        else
          baudrate_counter <= (others => '0');
          next_bit         <= '0';
        end if;
      end if;
    end if;
  end process;
end behavioural;



