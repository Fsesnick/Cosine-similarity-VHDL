library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity TMP_0 is
    port (
        clk  : in  std_logic;  -- A 100MHz clock
        rst  : in  std_logic;
        CH_N : in  std_logic_vector( 7 downto 0);
        ADDR : IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
        DATA : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
end TMP_0 ;

architecture Behavioral of TMP_0 is    

  COMPONENT blk_mem_gen_0
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    
  );
  END COMPONENT;
  
  COMPONENT blk_mem_gen_1
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    
  );
  END COMPONENT;
  
   COMPONENT blk_mem_gen_2
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    
  );
  END COMPONENT;
  
  COMPONENT blk_mem_gen_3
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    
  );
  END COMPONENT;
  
  COMPONENT blk_mem_gen_4
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    
  );
  END COMPONENT;
  
  COMPONENT blk_mem_gen_5
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    
  );
  END COMPONENT;
  
  COMPONENT blk_mem_gen_6
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    
  );
  END COMPONENT;
  
  
  COMPONENT blk_mem_gen_7
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    
  );
  END COMPONENT;
  
  COMPONENT blk_mem_gen_8
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    
  );
  END COMPONENT;
  
  COMPONENT blk_mem_gen_9
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    
  );
  END COMPONENT;
    
    signal   BROM_addr               : std_logic_vector( 5 downto 0) := (others => '0');
    signal   channel_number          : std_logic_vector( 7 downto 0) := (others => '0');
    signal   BROM_dout               :  std_logic_vector(15 downto 0);
  
    signal   BROM_00_addr            : std_logic_vector( 5 downto 0) := (others => '0');
    signal   BROM_00_dout            : std_logic_vector(15 downto 0);

    signal   BROM_01_addr            : std_logic_vector( 5 downto 0) := (others => '0');
    signal   BROM_01_dout            : std_logic_vector(15 downto 0);

    signal   BROM_02_addr            : std_logic_vector( 5 downto 0) := (others => '0');
    signal   BROM_02_dout            : std_logic_vector(15 downto 0);
    
    signal   BROM_03_addr            : std_logic_vector( 5 downto 0) := (others => '0');
    signal   BROM_03_dout            : std_logic_vector(15 downto 0);
    
    signal   BROM_04_addr            : std_logic_vector( 5 downto 0) := (others => '0');
    signal   BROM_04_dout            : std_logic_vector(15 downto 0);
    
    signal   BROM_05_addr            : std_logic_vector( 5 downto 0) := (others => '0');
    signal   BROM_05_dout            : std_logic_vector(15 downto 0);
    
    signal   BROM_06_addr            : std_logic_vector( 5 downto 0) := (others => '0');
    signal   BROM_06_dout            : std_logic_vector(15 downto 0);
    
    signal   BROM_07_addr            : std_logic_vector( 5 downto 0) := (others => '0');
    signal   BROM_07_dout            : std_logic_vector(15 downto 0);
    
    signal   BROM_08_addr            : std_logic_vector( 5 downto 0) := (others => '0');
    signal   BROM_08_dout            : std_logic_vector(15 downto 0);
    
    signal   BROM_09_addr            : std_logic_vector( 5 downto 0) := (others => '0');
    signal   BROM_09_dout            : std_logic_vector(15 downto 0);    
begin

    ROM_00 : blk_mem_gen_0
    PORT MAP (
    clka   => clk,
    ena    => '1',
    addra  => BROM_00_addr,
    douta  => BROM_00_dout
    );
    
    ROM_01 : blk_mem_gen_1
    PORT MAP (
    clka   => clk,
    ena    => '1',
    addra  => BROM_01_addr,
    douta  => BROM_01_dout
    );  
    
    ROM_02 : blk_mem_gen_2
    PORT MAP (
    clka   => clk,
    ena    => '1',
    addra  => BROM_02_addr,
    douta  => BROM_02_dout
    );  
   
    ROM_03 : blk_mem_gen_3
    PORT MAP (
    clka   => clk,
    ena    => '1',
    addra  => BROM_03_addr,
    douta  => BROM_03_dout
    );
    
    ROM_04 : blk_mem_gen_4
    PORT MAP (
    clka   => clk,
    ena    => '1',
    addra  => BROM_04_addr,
    douta  => BROM_04_dout
    ); 
       
    ROM_05 : blk_mem_gen_5
    PORT MAP (
    clka   => clk,
    ena    => '1',
    addra  => BROM_05_addr,
    douta  => BROM_05_dout
    );
    
    ROM_06 : blk_mem_gen_6
    PORT MAP (
    clka   => clk,
    ena    => '1',
    addra  => BROM_06_addr,
    douta  => BROM_06_dout
    );
        
    ROM_07 : blk_mem_gen_7
    PORT MAP (
    clka   => clk,
    ena    => '1',
    addra  => BROM_07_addr,
    douta  => BROM_07_dout
    );  
        
    ROM_08 : blk_mem_gen_8
    PORT MAP (
    clka   => clk,
    ena    => '1',
    addra  => BROM_08_addr,
    douta  => BROM_08_dout
    ); 
     
    ROM_09 : blk_mem_gen_9
    PORT MAP (
    clka   => clk,
    ena    => '1',
    addra  => BROM_09_addr,
    douta  => BROM_09_dout
    );  
    
    process(clk)
    begin
        if clk'event and clk = '1' then
            if rst = '1' then
               
                channel_number      <= (others => '0');
                BROM_addr           <= (others => '0');
                
            else
                channel_number      <= CH_N;     
                BROM_addr           <= ADDR ;
                
             end if;
         end if;
               
    end process;
    
    
    process(channel_number, BROM_addr,BROM_dout)
    begin
  
    case channel_number is
            when  X"00" =>                       

                BROM_00_addr <= BROM_addr;   
                BROM_01_addr <= (others => '0');    
                BROM_02_addr <= (others => '0');   
                BROM_03_addr <= (others => '0');   
                BROM_04_addr <= (others => '0');   
                BROM_05_addr <= (others => '0');   
                BROM_06_addr <= (others => '0');   
                BROM_07_addr <= (others => '0');   
                BROM_08_addr <= (others => '0');   
                BROM_09_addr <= (others => '0');   
        
            when  X"01" =>                       

                BROM_00_addr <= (others => '0');   
                BROM_01_addr <= BROM_addr;
                BROM_02_addr <= (others => '0');   
                BROM_03_addr <= (others => '0');   
                BROM_04_addr <= (others => '0');   
                BROM_05_addr <= (others => '0');   
                BROM_06_addr <= (others => '0');   
                BROM_07_addr <= (others => '0');   
                BROM_08_addr <= (others => '0');   
                BROM_09_addr <= (others => '0');    
                
           when  X"02" =>                       

                BROM_00_addr <= (others => '0');   
                BROM_01_addr <= (others => '0');  
                BROM_02_addr <= BROM_addr;  
                BROM_03_addr <= (others => '0');   
                BROM_04_addr <= (others => '0');   
                BROM_05_addr <= (others => '0');   
                BROM_06_addr <= (others => '0');   
                BROM_07_addr <= (others => '0');   
                BROM_08_addr <= (others => '0');   
                BROM_09_addr <= (others => '0'); 
           
          when X"03" => 
                
                BROM_00_addr <= (others => '0');   
                BROM_01_addr <= (others => '0');
                BROM_02_addr <= (others => '0');   
                BROM_03_addr <=  BROM_addr;   
                BROM_04_addr <= (others => '0');   
                BROM_05_addr <= (others => '0');   
                BROM_06_addr <= (others => '0');   
                BROM_07_addr <= (others => '0');   
                BROM_08_addr <= (others => '0');   
                BROM_09_addr <= (others => '0'); 
                
         when X"04" =>
        
                BROM_00_addr <= (others => '0');   
                BROM_01_addr <= (others => '0');
                BROM_02_addr <= (others => '0');   
                BROM_03_addr <= (others => '0'); 
                BROM_04_addr <=  BROM_addr;   
                BROM_05_addr <= (others => '0');   
                BROM_06_addr <= (others => '0');   
                BROM_07_addr <= (others => '0');   
                BROM_08_addr <= (others => '0');   
                BROM_09_addr <= (others => '0'); 
                
          when X"05" =>
        
                BROM_00_addr <= (others => '0');   
                BROM_01_addr <= (others => '0');
                BROM_02_addr <= (others => '0');   
                BROM_03_addr <= (others => '0'); 
                BROM_04_addr <= (others => '0');   
                BROM_05_addr <=  BROM_addr;    
                BROM_06_addr <= (others => '0');   
                BROM_07_addr <= (others => '0');   
                BROM_08_addr <= (others => '0');   
                BROM_09_addr <= (others => '0'); 
                 
         when X"06" =>
        
                BROM_00_addr <= (others => '0');   
                BROM_01_addr <= (others => '0');
                BROM_02_addr <= (others => '0');   
                BROM_03_addr <= (others => '0'); 
                BROM_04_addr <= (others => '0');   
                BROM_05_addr <= (others => '0');   
                BROM_06_addr <=  BROM_addr; 
                BROM_07_addr <= (others => '0');   
                BROM_08_addr <= (others => '0');   
                BROM_09_addr <= (others => '0'); 
                
          when X"07" =>
        
                BROM_00_addr <= (others => '0');   
                BROM_01_addr <= (others => '0');
                BROM_02_addr <= (others => '0');   
                BROM_03_addr <= (others => '0'); 
                BROM_04_addr <= (others => '0');   
                BROM_05_addr <= (others => '0');   
                BROM_06_addr <= (others => '0');
                BROM_07_addr <=  BROM_addr;   
                BROM_08_addr <= (others => '0');   
                BROM_09_addr <= (others => '0'); 
                
        when X"08" =>
         
                BROM_00_addr <= (others => '0');   
                BROM_01_addr <= (others => '0');
                BROM_02_addr <= (others => '0');   
                BROM_03_addr <= (others => '0'); 
                BROM_04_addr <= (others => '0');   
                BROM_05_addr <= (others => '0');   
                BROM_06_addr <= (others => '0');
                BROM_07_addr <= (others => '0');   
                BROM_08_addr <=  BROM_addr;    
                BROM_09_addr <= (others => '0'); 
                
        when X"09" =>
         
                BROM_00_addr <= (others => '0');   
                BROM_01_addr <= (others => '0');
                BROM_02_addr <= (others => '0');   
                BROM_03_addr <= (others => '0'); 
                BROM_04_addr <= (others => '0');   
                BROM_05_addr <= (others => '0');   
                BROM_06_addr <= (others => '0');
                BROM_07_addr <= (others => '0');   
                BROM_08_addr <= (others => '0');   
                BROM_09_addr <=  BROM_addr;
                
            when others =>
       
                BROM_00_addr <= (others => '0');
                BROM_01_addr <= (others => '0');
                BROM_02_addr <= (others => '0');
                BROM_03_addr <= (others => '0');   
                BROM_04_addr <= (others => '0');   
                BROM_05_addr <= (others => '0');   
                BROM_06_addr <= (others => '0');   
                BROM_07_addr <= (others => '0');   
                BROM_08_addr <= (others => '0');   
                BROM_09_addr <= (others => '0'); 

      end case;

  
     case channel_number is
          when  X"00" =>         
              DATA     <= BROM_00_dout;
          when  X"01" =>
              DATA     <= BROM_01_dout;  
          when  X"02" =>         
              DATA     <= BROM_02_dout;
          when  X"03" =>
              DATA     <= BROM_03_dout;     
          when  X"04" =>         
              DATA     <= BROM_04_dout;
          when  X"05" =>
              DATA     <= BROM_05_dout;  
          when  X"06" =>         
              DATA     <= BROM_06_dout;
          when  X"07" =>
              DATA     <= BROM_07_dout;     
          when  X"08" =>         
              DATA     <= BROM_08_dout;
          when  X"09" =>
              DATA     <= BROM_09_dout;             
          when others =>
              DATA   <= (others => '0');
        end case;
   
    end process;
end Behavioral;
