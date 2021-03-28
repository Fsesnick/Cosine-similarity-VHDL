library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MAIN is
    port (
        clk: in  std_logic;  -- A 100MHz clock
        rst: in  std_logic;
        RX : in  std_logic;
        TX : out std_logic;
        LED0: out std_logic
    );
end MAIN;

architecture Behavioral of MAIN is    
    component UART_RX is
    port (
        clk     : in  std_logic;  -- A 100MHz clock
        rst     : in  std_logic;
        RX      : in  std_logic;
        RX_DATA : out std_logic_vector(7 downto 0);
        NEW_DATA: out std_logic
    );
    end component;

    component UART_TX is
    port (
        clk     : in  std_logic;  -- A 100MHz clock
        rst     : in  std_logic;
        TX_DATA : in  std_logic_vector(7 downto 0);
        START_TX: in  std_logic;
        TX      : out std_logic;
        BUSY    : out std_logic
    );
    end component;

    COMPONENT blk_mem
    PORT (
        clka : IN  STD_LOGIC;
        ena  : IN  STD_LOGIC;
        wea  : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra: IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
        dina : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        douta: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
    END COMPONENT;
    
    signal   BRAM_ADDR_OVERFLOW      : std_logic   := '0'; 
    constant C_MAX_SIZE_BRAM         : integer:= 64; --64 enderecos
    constant C_DELAY_8u7             : integer := 10000;  -- 100 us
    signal   NEW_DATA, START_TX, BUSY: std_logic;
    signal   RX_DATA, TX_DATA        : std_logic_vector( 7 downto 0);
    signal   CHECK_START             : std_logic_vector( 3 downto 0) := (others => '0'); --keep track of START sent from PC
    signal   CHECK_START_OK          : std_logic := '0'; --check if the got the 5 letters "START" and if is OK we send "READY"
    signal   delay_8u7               : std_logic_vector(13 downto 0); --  100MHZ /115200 [Baud rate], delay to send bytes from TX
    signal   count_ready             : std_logic_vector( 3 downto 0) := (others => '0'); -- count the 5 bytes to send "READY" from TX
    signal   header                  : std_logic_vector( 3 downto 0) := (others => '0');  -- W or R a+ Channel number + data size
    signal   command                 : std_logic_vector( 7 downto 0) := (others => '0');
    signal   channel_number          : std_logic_vector( 7 downto 0) := (others => '0');
    signal   data_size               : std_logic_vector(15 downto 0) := (others => '0');
    signal   header_is_done          : std_logic := '0'; -- gets one when we receiving header info
    
    signal   BRAM_00_WE              : std_logic_vector( 0 downto 0) := (others => '0'); -- signals assigned to Block ram 00 - channel 00 values
    signal   BRAM_00_addr            : std_logic_vector( 5 downto 0) := (others => '0');
    signal   BRAM_00_din             : std_logic_vector(15 downto 0) := (others => '0');
    signal   BRAM_00_dout            : std_logic_vector(15 downto 0);
    
    signal   BRAM_01_WE              : std_logic_vector( 0 downto 0) := (others => '0');-- signals assigned to Block ram 01 - channel 01 values
    signal   BRAM_01_addr            : std_logic_vector( 5 downto 0) := (others => '0');
    signal   BRAM_01_din             : std_logic_vector(15 downto 0) := (others => '0');
    signal   BRAM_01_dout            : std_logic_vector(15 downto 0);
    
    signal   BRAM_02_WE              : std_logic_vector( 0 downto 0) := (others => '0');
    signal   BRAM_02_addr            : std_logic_vector( 5 downto 0) := (others => '0');
    signal   BRAM_02_din             : std_logic_vector(15 downto 0) := (others => '0');
    signal   BRAM_02_dout            : std_logic_vector(15 downto 0);

    signal   BRAM_03_WE              : std_logic_vector( 0 downto 0) := (others => '0');
    signal   BRAM_03_addr            : std_logic_vector( 5 downto 0) := (others => '0');
    signal   BRAM_03_din              : std_logic_vector(15 downto 0) := (others => '0');
    signal   BRAM_03_dout            : std_logic_vector(15 downto 0);
    
    signal   BRAM_04_WE              : std_logic_vector( 0 downto 0) := (others => '0');
    signal   BRAM_04_addr            : std_logic_vector( 5 downto 0) := (others => '0');
    signal   BRAM_04_din              : std_logic_vector(15 downto 0) := (others => '0');
    signal   BRAM_04_dout            : std_logic_vector(15 downto 0);
          
    signal   BRAM_05_WE              : std_logic_vector( 0 downto 0) := (others => '0');
    signal   BRAM_05_addr            : std_logic_vector( 5 downto 0) := (others => '0');
    signal   BRAM_05_din             : std_logic_vector(15 downto 0) := (others => '0');
    signal   BRAM_05_dout            : std_logic_vector(15 downto 0);
 
    signal   BRAM_06_WE              : std_logic_vector( 0 downto 0) := (others => '0');
    signal   BRAM_06_addr            : std_logic_vector( 5 downto 0) := (others => '0');
    signal   BRAM_06_din             : std_logic_vector(15 downto 0) := (others => '0');
    signal   BRAM_06_dout            : std_logic_vector(15 downto 0);  
    
    signal   BRAM_07_WE              : std_logic_vector( 0 downto 0) := (others => '0');
    signal   BRAM_07_addr            : std_logic_vector( 5 downto 0) := (others => '0');
    signal   BRAM_07_din             : std_logic_vector(15 downto 0) := (others => '0');
    signal   BRAM_07_dout            : std_logic_vector(15 downto 0);
 
    signal   BRAM_08_WE              : std_logic_vector( 0 downto 0) := (others => '0');
    signal   BRAM_08_addr            : std_logic_vector( 5 downto 0) := (others => '0');
    signal   BRAM_08_din             : std_logic_vector(15 downto 0) := (others => '0');
    signal   BRAM_08_dout            : std_logic_vector(15 downto 0);
 
    signal   BRAM_09_WE              : std_logic_vector( 0 downto 0) := (others => '0');
    signal   BRAM_09_addr            : std_logic_vector( 5 downto 0) := (others => '0');
    signal   BRAM_09_din             : std_logic_vector(15 downto 0) := (others => '0');
    signal   BRAM_09_dout            : std_logic_vector(15 downto 0);
    

    signal   byte_counter            : std_logic_vector( 3 downto 0) := (others => '0');
    signal   BRAM_addr_inc_flag      : std_logic := '0';
    
    signal   BRAM_WE                 : std_logic_vector( 0 downto 0) := (others => '0');-- signal controler 
    signal   BRAM_addr               : std_logic_vector( 5 downto 0) := (others => '0');
    signal   BRAM_din                : std_logic_vector(15 downto 0) := (others => '0');
    signal   BRAM_dout               : std_logic_vector(15 downto 0);

begin
    RX_0: UART_RX
    port map (
        clk      => clk,
        rst      => rst,
        RX       => RX,
        RX_DATA  => RX_DATA,
        NEW_DATA => NEW_DATA
    );

    TX_0: UART_TX
    port map (
        clk      => clk,
        rst      => rst,
        TX_DATA  => TX_DATA,
        START_TX => START_TX,
        TX       => TX,
        BUSY     => BUSY
    );

    BRAM_00 : blk_mem
    PORT MAP (
        clka  => clk,
        ena   => '1',
        wea   => BRAM_00_WE,
        addra => BRAM_00_addr,
        dina  => BRAM_00_din,
        douta => BRAM_00_dout
    );

    BRAM_01 : blk_mem
    PORT MAP (
        clka  => clk,
        ena   => '1',
        wea   => BRAM_01_WE,
        addra => BRAM_01_addr,
        dina  => BRAM_01_din,
        douta => BRAM_01_dout
    );
    
     BRAM_02 : blk_mem
     PORT MAP (
        clka  => clk,
        ena   => '1',
        wea   => BRAM_02_WE,
        addra => BRAM_02_addr,
        dina  => BRAM_02_din,
        douta => BRAM_02_dout
    );
    
    BRAM_03 : blk_mem
    PORT MAP (
        clka  => clk,
        ena   => '1',
        wea   => BRAM_03_WE,
        addra => BRAM_03_addr,
        dina  => BRAM_03_din,
        douta => BRAM_03_dout
    );
    
    
    BRAM_04 : blk_mem
    PORT MAP (
        clka  => clk,
        ena   => '1',
        wea   => BRAM_04_WE,
        addra => BRAM_04_addr,
        dina  => BRAM_04_din,
        douta => BRAM_04_dout
    );
    
    BRAM_05 : blk_mem
    PORT MAP (
        clka  => clk,
        ena   => '1',
        wea   => BRAM_05_WE,
        addra => BRAM_05_addr,
        dina  => BRAM_05_din,
        douta => BRAM_05_dout
    );
    
    BRAM_06 : blk_mem
    PORT MAP (
        clka  => clk,
        ena   => '1',
        wea   => BRAM_06_WE,
        addra => BRAM_06_addr,
        dina  => BRAM_06_din,
        douta => BRAM_06_dout
    );
    
    BRAM_07 : blk_mem
    PORT MAP (
        clka  => clk,
        ena   => '1',
        wea   => BRAM_07_WE,
        addra => BRAM_07_addr,
        dina  => BRAM_07_din,
        douta => BRAM_07_dout
    );
    
    BRAM_08 : blk_mem
    PORT MAP (
        clka  => clk,
        ena   => '1',
        wea   => BRAM_08_WE,
        addra => BRAM_08_addr,
        dina  => BRAM_08_din,
        douta => BRAM_08_dout
    );
   
    BRAM_09 : blk_mem
    PORT MAP (
        clka  => clk,
        ena   => '1',
        wea   => BRAM_09_WE,
        addra => BRAM_09_addr,
        dina  => BRAM_09_din,
        douta => BRAM_09_dout
    );



    process(clk)
    begin
        if clk'event and clk = '1' then
            if rst = '1' then
                CHECK_START         <= (others => '0');
                CHECK_START_OK      <= '0';
                delay_8u7           <= (others => '0');
                START_TX            <= '0';
                count_ready         <= (others => '0');
                header              <= (others => '0');
                command             <= (others => '0');
                channel_number      <= (others => '0');
                data_size           <= (others => '0');
                header_is_done      <= '0';
                BRAM_WE             <= "0";
                BRAM_addr           <= (others => '0');
                BRAM_din            <= (others => '0');
                byte_counter        <= (others => '0');
                BRAM_addr_inc_flag  <= '0';
                BRAM_ADDR_OVERFLOW   <= '0';
            else
                if CHECK_START_OK = '0' and NEW_DATA = '1' then
                    case CHECK_START is
                        when X"0" =>
                            if RX_DATA = X"53" then  -- S
                                CHECK_START <= CHECK_START + 1;
                            else
                                CHECK_START <= (others => '0');
                            end if;
                        when X"1" =>
                            if RX_DATA = X"54" then  -- T
                                CHECK_START <= CHECK_START + 1;
                            else
                                CHECK_START <= (others => '0');
                            end if;
                        when X"2" =>
                            if RX_DATA = X"41" then  -- A
                                CHECK_START <= CHECK_START + 1;
                            else
                                CHECK_START <= (others => '0');
                            end if;
                        when X"3" =>
                            if RX_DATA = X"52" then  -- R
                                CHECK_START <= CHECK_START + 1;
                            else
                                CHECK_START <= (others => '0');
                            end if;
                        when X"4" =>
                            if RX_DATA = X"54" then  -- T
                                CHECK_START    <= CHECK_START + 1;
                                CHECK_START_OK <= '1';
                            else
                                CHECK_START <= (others => '0');
                            end if;
                        when others => null;
                    end case;                
                end if;
                
                if CHECK_START_OK = '1' and count_ready < 5 then
                    if delay_8u7 < C_DELAY_8u7 then
                        delay_8u7 <= delay_8u7 + 1;
                        START_TX <= '0';
                    else
                        delay_8u7   <= (others => '0');
                        START_TX    <= '1';                        
                        count_ready <= count_ready + 1;

                        case count_ready is
                            when X"0" => TX_DATA  <= X"52";  -- R
                            when X"1" => TX_DATA  <= X"45";  -- E
                            when X"2" => TX_DATA  <= X"41";  -- A
                            when X"3" => TX_DATA  <= X"44";  -- D
                            when X"4" => TX_DATA  <= X"59";  -- Y
                            when others => null;
                        end case;                
                    end if;
                else
                    START_TX  <= '0';
                    delay_8u7 <= (others => '0');
                end if;

                if CHECK_START_OK = '1' and NEW_DATA = '1' then
                    case header is
                        when X"0" =>
                            if RX_DATA = X"52" or RX_DATA = X"57" or RX_DATA = X"43" then  -- R or W or C
                                command <=  RX_DATA;            -- store the command in command
                                header     <= header + 1;          -- go to the next header
                            else
                                header <= (others => '0');         -- there is an error, start over
                            end if;
                        when X"1" =>
                            if RX_DATA < 10 then                   -- 10 is the maximum number of BRAMs
                                channel_number <= RX_DATA;         -- store the channel number in channel_number
                                header         <= header + 1;      -- go to the next header
                            else
                                header <= (others => '0');         -- there is an error, start over
                            end if;
                        when X"2" =>
                            data_size(15 downto 8) <= RX_DATA;     -- store the MSB of the data size
                            header                 <= header + 1;  -- go to the next header
                        when X"3" =>
                            data_size( 7 downto 0) <= RX_DATA;     -- store the LSB of the data size
                            header                 <= header + 1;  -- go to the next header
                            header_is_done         <= '1';
                            BRAM_addr              <= (others => '0');
                            BRAM_addr_inc_flag     <= '0';
                        when others => null;
                    end case;
                end if;

                -- PC ==> BRAM
        if header_is_done = '1' and command = X"57" and NEW_DATA = '1' and  BRAM_addr < data_size(6 downto 0) and data_size <= C_MAX_SIZE_BRAM then  -- Write
                    BRAM_WE      <= "1";  -- write to BRAM
                    byte_counter <= byte_counter + 1;
                    if byte_counter = 0 then
                        BRAM_din(15 downto 8) <= RX_DATA;     -- store the MSB of the data
                    else
                        BRAM_din( 7 downto 0) <= RX_DATA;     -- store the LSB of the data
                        byte_counter          <= (others => '0');
                        BRAM_addr_inc_flag    <= '1';
                    end if;
                -- BRAM ==> PC
                elsif header_is_done = '1' and  command = X"52" and  BRAM_addr < data_size(6 downto 0) and data_size <= C_MAX_SIZE_BRAM  then  -- Read
                    BRAM_WE <= "0";  -- read from BRAM
                    if delay_8u7 < C_DELAY_8u7 then
                        delay_8u7 <= delay_8u7 + 1;
                        START_TX  <= '0';
                    else
                        delay_8u7 <= (others => '0');
                        START_TX  <= '1';                        
           
                   
                     byte_counter <= byte_counter + 1;
                        if byte_counter = 0 then
                            TX_DATA            <= BRAM_dout(15 downto 8);  -- read data from MSB
                        else
                            TX_DATA            <= BRAM_dout( 7 downto 0);  -- read data from LSB
                            byte_counter       <= (others => '0');
                            BRAM_addr          <= BRAM_addr + 1;
                            BRAM_ADDR_OVERFLOW <= '1';
                        end if;
                --    end if;
                    
                end if;
                    
           end if;

         if header_is_done = '1' and command = X"57" and  BRAM_addr < data_size(6 downto 0) and data_size <= C_MAX_SIZE_BRAM  then  -- W
                    if BRAM_addr_inc_flag = '1' then
                        BRAM_addr          <= BRAM_addr + 1;
                        BRAM_ADDR_OVERFLOW <= '1';
                        BRAM_addr_inc_flag <= '0';
                    end if;
                end if;
        
          if header_is_done = '1' and BRAM_ADDR_OVERFLOW = '1' and (command = X"57" or command = X"52" ) and (BRAM_addr = data_size( 5 downto 0))and data_size <= C_MAX_SIZE_BRAM then  -- W or R
                    header             <= (others => '0');
                    header_is_done     <= '0';
                    BRAM_ADDR_OVERFLOW <='0';
                    BRAM_WE            <= "0";
                    command            <= (others => '0');

                    START_TX       <= '0';
                    delay_8u7      <= (others => '0');
                end if;
            end if;  -- if rst = '1' then
        end if;  -- if clk'event and clk = '1' then

       LED0 <= header_is_done; -- used to test if all values of the header was sent
    end process;
    
    process(channel_number) 
    begin
  
    case channel_number is
            when  X"0" =>                       ---------------------------------------
                BRAM_00_WE   <= BRAM_WE;
                BRAM_00_addr <= BRAM_addr;
                BRAM_00_din  <= BRAM_din ;
                
                BRAM_01_WE   <= (others => '0');
                BRAM_01_addr <= (others => '0');
                BRAM_01_din  <= (others => '0');
                
                BRAM_02_WE   <= (others => '0');
                BRAM_02_addr <= (others => '0');
                BRAM_02_din  <= (others => '0');
                
                BRAM_03_WE   <= (others => '0');
                BRAM_03_addr <= (others => '0');
                BRAM_03_din  <= (others => '0');
                
                BRAM_04_WE   <= (others => '0');
                BRAM_04_addr <= (others => '0');
                BRAM_04_din  <= (others => '0');
                
                BRAM_05_WE   <= (others => '0');
                BRAM_05_addr <= (others => '0');
                BRAM_05_din  <= (others => '0');
                
                BRAM_06_WE   <= (others => '0');
                BRAM_06_addr <= (others => '0');
                BRAM_06_din  <= (others => '0');               
                
                BRAM_07_WE   <= (others => '0');
                BRAM_07_addr <= (others => '0');
                BRAM_07_din  <= (others => '0');
                
                BRAM_08_WE   <= (others => '0');
                BRAM_08_addr <= (others => '0');
                BRAM_08_din  <= (others => '0');
                
                BRAM_09_WE   <= (others => '0');
                BRAM_09_addr <= (others => '0');
                BRAM_09_din  <= (others => '0');                     
                
            when  X"1" =>                       -----------------------------
                BRAM_00_WE   <= (others => '0');
                BRAM_00_addr <= (others => '0');
                BRAM_00_din  <= (others => '0');
                
                BRAM_01_WE   <= BRAM_WE;
                BRAM_01_addr <= BRAM_addr;
                BRAM_01_din  <= BRAM_din;
                
                BRAM_02_WE   <= (others => '0');
                BRAM_02_addr <= (others => '0');
                BRAM_02_din  <= (others => '0');
 
                BRAM_03_WE   <= (others => '0');
                BRAM_03_addr <= (others => '0');
                BRAM_03_din  <= (others => '0');
                
                BRAM_04_WE   <= (others => '0');
                BRAM_04_addr <= (others => '0');
                BRAM_04_din  <= (others => '0');
                
                BRAM_05_WE   <= (others => '0');
                BRAM_05_addr <= (others => '0');
                BRAM_05_din  <= (others => '0');
                
                BRAM_06_WE   <= (others => '0');
                BRAM_06_addr <= (others => '0');
                BRAM_06_din  <= (others => '0');               
                
                BRAM_07_WE   <= (others => '0');
                BRAM_07_addr <= (others => '0');
                BRAM_07_din  <= (others => '0');
                
                BRAM_08_WE   <= (others => '0');
                BRAM_08_addr <= (others => '0');
                BRAM_08_din  <= (others => '0');
                
                BRAM_09_WE   <= (others => '0');
                BRAM_09_addr <= (others => '0');
                BRAM_09_din  <= (others => '0');       
                          
            when  X"2" =>                     --------------------------------------
                BRAM_00_WE   <= (others => '0');
                BRAM_00_addr <= (others => '0');
                BRAM_00_din  <= (others => '0');
                
                BRAM_01_WE   <= (others => '0');
                BRAM_01_addr <= (others => '0');
                BRAM_01_din  <= (others => '0');
                
                BRAM_02_WE   <= BRAM_WE;
                BRAM_02_addr <= BRAM_addr;
                BRAM_02_din  <= BRAM_din;
                
                BRAM_03_WE   <= (others => '0');
                BRAM_03_addr <= (others => '0');
                BRAM_03_din  <= (others => '0');
                
                BRAM_04_WE   <= (others => '0');
                BRAM_04_addr <= (others => '0');
                BRAM_04_din  <= (others => '0');
                
                BRAM_05_WE   <= (others => '0');
                BRAM_05_addr <= (others => '0');
                BRAM_05_din  <= (others => '0');
                
                BRAM_06_WE   <= (others => '0');
                BRAM_06_addr <= (others => '0');
                BRAM_06_din  <= (others => '0');               
                
                BRAM_07_WE   <= (others => '0');
                BRAM_07_addr <= (others => '0');
                BRAM_07_din  <= (others => '0');
                
                BRAM_08_WE   <= (others => '0');
                BRAM_08_addr <= (others => '0');
                BRAM_08_din  <= (others => '0');
                
                BRAM_09_WE   <= (others => '0');
                BRAM_09_addr <= (others => '0');
                BRAM_09_din  <= (others => '0');      
                
                
           when  X"3" =>
                BRAM_00_WE   <= (others => '0');
                BRAM_00_addr <= (others => '0');
                BRAM_00_din  <= (others => '0');
                
                BRAM_01_WE   <= (others => '0');
                BRAM_01_addr <= (others => '0');
                BRAM_01_din  <= (others => '0');
                
                BRAM_02_WE   <= (others => '0');
                BRAM_02_addr <= (others => '0');
                BRAM_02_din  <= (others => '0');
                
                BRAM_03_WE   <= BRAM_WE;
                BRAM_03_addr <= BRAM_addr;
                BRAM_03_din  <= BRAM_din;
                
                BRAM_04_WE   <= (others => '0');
                BRAM_04_addr <= (others => '0');
                BRAM_04_din  <= (others => '0');
                
                BRAM_05_WE   <= (others => '0');
                BRAM_05_addr <= (others => '0');
                BRAM_05_din  <= (others => '0');
                
                BRAM_06_WE   <= (others => '0');
                BRAM_06_addr <= (others => '0');
                BRAM_06_din  <= (others => '0');               
                
                BRAM_07_WE   <= (others => '0');
                BRAM_07_addr <= (others => '0');
                BRAM_07_din  <= (others => '0');
                
                BRAM_08_WE   <= (others => '0');
                BRAM_08_addr <= (others => '0');
                BRAM_08_din  <= (others => '0');
                
                BRAM_09_WE   <= (others => '0');
                BRAM_09_addr <= (others => '0');
                BRAM_09_din  <= (others => '0');  
                 
        when  X"4" =>                         -------------------------------------------------
                BRAM_00_WE   <= (others => '0');
                BRAM_00_addr <= (others => '0');
                BRAM_00_din  <= (others => '0');
                
                BRAM_01_WE   <= (others => '0');
                BRAM_01_addr <= (others => '0');
                BRAM_01_din  <= (others => '0');
                
                BRAM_02_WE   <= (others => '0');
                BRAM_02_addr <= (others => '0');
                BRAM_02_din  <= (others => '0');
                
                BRAM_03_WE   <= (others => '0');
                BRAM_03_addr <= (others => '0');
                BRAM_03_din  <= (others => '0');
                
                BRAM_04_WE   <= BRAM_WE;
                BRAM_04_addr <= BRAM_addr;
                BRAM_04_din  <= BRAM_din;
                
                BRAM_05_WE   <= (others => '0');
                BRAM_05_addr <= (others => '0');
                BRAM_05_din  <= (others => '0');
                
                BRAM_06_WE   <= (others => '0');
                BRAM_06_addr <= (others => '0');
                BRAM_06_din  <= (others => '0');               
                
                BRAM_07_WE   <= (others => '0');
                BRAM_07_addr <= (others => '0');
                BRAM_07_din  <= (others => '0');
                
                BRAM_08_WE   <= (others => '0');
                BRAM_08_addr <= (others => '0');
                BRAM_08_din  <= (others => '0');
                
                BRAM_09_WE   <= (others => '0');
                BRAM_09_addr <= (others => '0');
                BRAM_09_din  <= (others => '0');  
    when  X"5" =>                         -------------------------------------------------
                BRAM_00_WE   <= (others => '0');
                BRAM_00_addr <= (others => '0');
                BRAM_00_din  <= (others => '0');
                
                BRAM_01_WE   <= (others => '0');
                BRAM_01_addr <= (others => '0');
                BRAM_01_din  <= (others => '0');
                
                BRAM_02_WE   <= (others => '0');
                BRAM_02_addr <= (others => '0');
                BRAM_02_din  <= (others => '0');
                
                BRAM_03_WE   <= (others => '0');
                BRAM_03_addr <= (others => '0');
                BRAM_03_din  <= (others => '0');
                
                BRAM_04_WE   <= (others => '0');
                BRAM_04_addr <= (others => '0');
                BRAM_04_din  <= (others => '0');
                
                BRAM_05_WE   <= BRAM_WE;
                BRAM_05_addr <= BRAM_addr;
                BRAM_05_din  <= BRAM_din;
                
                BRAM_06_WE   <= (others => '0');
                BRAM_06_addr <= (others => '0');
                BRAM_06_din  <= (others => '0');               
                
                BRAM_07_WE   <= (others => '0');
                BRAM_07_addr <= (others => '0');
                BRAM_07_din  <= (others => '0');
                
                BRAM_08_WE   <= (others => '0');
                BRAM_08_addr <= (others => '0');
                BRAM_08_din  <= (others => '0');
                
                BRAM_09_WE   <= (others => '0');
                BRAM_09_addr <= (others => '0');
                BRAM_09_din  <= (others => '0');   
                
         when  X"6" =>                         -------------------------------------------------
                BRAM_00_WE   <= (others => '0');
                BRAM_00_addr <= (others => '0');
                BRAM_00_din  <= (others => '0');
                
                BRAM_01_WE   <= (others => '0');
                BRAM_01_addr <= (others => '0');
                BRAM_01_din  <= (others => '0');
                
                BRAM_02_WE   <= (others => '0');
                BRAM_02_addr <= (others => '0');
                BRAM_02_din  <= (others => '0');
                
                BRAM_03_WE   <= (others => '0');
                BRAM_03_addr <= (others => '0');
                BRAM_03_din  <= (others => '0');
                
                BRAM_04_WE   <= (others => '0');
                BRAM_04_addr <= (others => '0');
                BRAM_04_din  <= (others => '0');
                
                BRAM_05_WE   <= (others => '0');
                BRAM_05_addr <= (others => '0');
                BRAM_05_din  <= (others => '0');
                
                BRAM_06_WE   <= BRAM_WE;
                BRAM_06_addr <= BRAM_addr;
                BRAM_06_din  <= BRAM_din;            
                
                BRAM_07_WE   <= (others => '0');
                BRAM_07_addr <= (others => '0');
                BRAM_07_din  <= (others => '0');
                
                BRAM_08_WE   <= (others => '0');
                BRAM_08_addr <= (others => '0');
                BRAM_08_din  <= (others => '0');
                
                BRAM_09_WE   <= (others => '0');
                BRAM_09_addr <= (others => '0');
                BRAM_09_din  <= (others => '0');   
                
          when  X"7" =>                         -------------------------------------------------
                BRAM_00_WE   <= (others => '0');
                BRAM_00_addr <= (others => '0');
                BRAM_00_din  <= (others => '0');
                
                BRAM_01_WE   <= (others => '0');
                BRAM_01_addr <= (others => '0');
                BRAM_01_din  <= (others => '0');
                
                BRAM_02_WE   <= (others => '0');
                BRAM_02_addr <= (others => '0');
                BRAM_02_din  <= (others => '0');
                
                BRAM_03_WE   <= (others => '0');
                BRAM_03_addr <= (others => '0');
                BRAM_03_din  <= (others => '0');
                
                BRAM_04_WE   <= (others => '0');
                BRAM_04_addr <= (others => '0');
                BRAM_04_din  <= (others => '0');
                
                BRAM_05_WE   <= (others => '0');
                BRAM_05_addr <= (others => '0');
                BRAM_05_din  <= (others => '0');
                
                BRAM_06_WE   <= (others => '0');
                BRAM_06_addr <= (others => '0');
                BRAM_06_din  <= (others => '0');          
                
                BRAM_07_WE   <= BRAM_WE;
                BRAM_07_addr <= BRAM_addr;
                BRAM_07_din  <= BRAM_din;
                
                BRAM_08_WE   <= (others => '0');
                BRAM_08_addr <= (others => '0');
                BRAM_08_din  <= (others => '0');
                
                BRAM_09_WE   <= (others => '0');
                BRAM_09_addr <= (others => '0');
                BRAM_09_din  <= (others => '0');          
       when  X"8" =>                         -------------------------------------------------
                BRAM_00_WE   <= (others => '0');
                BRAM_00_addr <= (others => '0');
                BRAM_00_din  <= (others => '0');
                
                BRAM_01_WE   <= (others => '0');
                BRAM_01_addr <= (others => '0');
                BRAM_01_din  <= (others => '0');
                
                BRAM_02_WE   <= (others => '0');
                BRAM_02_addr <= (others => '0');
                BRAM_02_din  <= (others => '0');
                
                BRAM_03_WE   <= (others => '0');
                BRAM_03_addr <= (others => '0');
                BRAM_03_din  <= (others => '0');
                
                BRAM_04_WE   <= (others => '0');
                BRAM_04_addr <= (others => '0');
                BRAM_04_din  <= (others => '0');
                
                BRAM_05_WE   <= (others => '0');
                BRAM_05_addr <= (others => '0');
                BRAM_05_din  <= (others => '0');
                
                BRAM_06_WE   <= (others => '0');
                BRAM_06_addr <= (others => '0');
                BRAM_06_din  <= (others => '0');          
                
                BRAM_07_WE   <= (others => '0');  
                BRAM_07_addr <= (others => '0');  
                BRAM_07_din  <= (others => '0');  
                
                BRAM_08_WE   <= BRAM_WE;
                BRAM_08_addr <= BRAM_addr;
                BRAM_08_din  <= BRAM_din;
                
                BRAM_09_WE   <= (others => '0');
                BRAM_09_addr <= (others => '0');
                BRAM_09_din  <= (others => '0');          
                       
     when  X"9" =>                         -------------------------------------------------
                BRAM_00_WE   <= (others => '0');
                BRAM_00_addr <= (others => '0');
                BRAM_00_din  <= (others => '0');
                
                BRAM_01_WE   <= (others => '0');
                BRAM_01_addr <= (others => '0');
                BRAM_01_din  <= (others => '0');
                
                BRAM_02_WE   <= (others => '0');
                BRAM_02_addr <= (others => '0');
                BRAM_02_din  <= (others => '0');
                
                BRAM_03_WE   <= (others => '0');
                BRAM_03_addr <= (others => '0');
                BRAM_03_din  <= (others => '0');
                
                BRAM_04_WE   <= (others => '0');
                BRAM_04_addr <= (others => '0');
                BRAM_04_din  <= (others => '0');
                
                BRAM_05_WE   <= (others => '0');
                BRAM_05_addr <= (others => '0');
                BRAM_05_din  <= (others => '0');
                
                BRAM_06_WE   <= (others => '0');
                BRAM_06_addr <= (others => '0');
                BRAM_06_din  <= (others => '0');          
                
                BRAM_07_WE   <= (others => '0');  
                BRAM_07_addr <= (others => '0');  
                BRAM_07_din  <= (others => '0');  
                
                BRAM_08_WE   <= (others => '0'); 
                BRAM_08_addr <= (others => '0'); 
                BRAM_08_din  <= (others => '0'); 
                
                BRAM_09_WE   <= BRAM_WE;
                BRAM_09_addr <= BRAM_addr;
                BRAM_09_din  <= BRAM_din;         
                                                        
            when others =>
                BRAM_00_WE   <= (others => '0');
                BRAM_00_addr <= (others => '0');
                BRAM_00_din  <= (others => '0');
                
                BRAM_01_WE   <= (others => '0');
                BRAM_01_addr <= (others => '0');
                BRAM_01_din  <= (others => '0');
                
                BRAM_02_WE   <= (others => '0');
                BRAM_02_addr <= (others => '0');
                BRAM_02_din  <= (others => '0');
                
                BRAM_03_WE   <= (others => '0');
                BRAM_03_addr <= (others => '0');
                BRAM_03_din  <= (others => '0');
                
                BRAM_04_WE   <= (others => '0');
                BRAM_04_addr <= (others => '0');
                BRAM_04_din  <= (others => '0');
                
                BRAM_05_WE   <= (others => '0');
                BRAM_05_addr <= (others => '0');
                BRAM_05_din  <= (others => '0');
                
                BRAM_06_WE   <= (others => '0');
                BRAM_06_addr <= (others => '0');
                BRAM_06_din  <= (others => '0'); 
                
                BRAM_07_WE   <= (others => '0');
                BRAM_07_addr <= (others => '0');
                BRAM_07_din  <= (others => '0'); 
                               
                BRAM_08_WE   <= (others => '0');
                BRAM_08_addr <= (others => '0');
                BRAM_08_din  <= (others => '0');  
                              
                BRAM_09_WE   <= (others => '0');
                BRAM_09_addr <= (others => '0');
                BRAM_09_din  <= (others => '0');  
        end case;

  
      case channel_number is
           when  X"0" =>
                BRAM_dout    <= BRAM_00_dout;
           when  X"1" =>
                BRAM_dout    <= BRAM_01_dout;
           when  X"2" =>
                BRAM_dout    <= BRAM_02_dout;
           when  X"3" =>
                BRAM_dout    <= BRAM_03_dout;
           when  X"4" =>
                BRAM_dout    <= BRAM_04_dout;
           when  X"5" =>
                BRAM_dout    <= BRAM_05_dout;
           when  X"6" =>
                BRAM_dout    <= BRAM_06_dout;
           when  X"7" =>
                BRAM_dout    <= BRAM_07_dout;
           when  X"8" =>
                BRAM_dout    <= BRAM_08_dout;
           when  X"9" =>
                BRAM_dout    <= BRAM_09_dout;
           when others =>
                BRAM_dout    <= (others => '0');
        end case;
      
        
    end process;
end Behavioral;
