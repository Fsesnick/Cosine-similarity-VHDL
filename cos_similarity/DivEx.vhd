library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DivEx is
port(
    X    : in STD_LOGIC_VECTOR(31 downto 0);
    Y    : in STD_LOGIC_VECTOR(31 downto 0);
    R    : out STD_LOGIC_VECTOR(31 downto 0)

);
end DivEx;

architecture Behavioral of DivEx is

signal scaled :STD_LOGIC_VECTOR(31 downto 0); -- Multiply to not have a result 0, but a integer

signal num : std_logic_vector (31 downto 0);
--signal done : std_logic:='0';

begin
    scaled <= std_logic_vector(to_signed(to_integer(signed( X)*32),32));
 --X_10000 <= std_logic_vector(to_signed(to_integer(signed( X"00000000" & X)*512),64)); -- resultado é multiplicado por 10000 no final 
 
test_0:process(X,Y)
begin
if(Y = x"00000000") then
   -- num <= x"FFFFFFFF";
    num <= (others => '0');
else

    num <= std_logic_vector((signed(scaled))/signed(Y));

     --num <= (std_logic_vector(to_signed(to_integer(unsigned(scaled) / (unsigned(Y)) ),32))) ; 
    -- num <= (std_logic_vector(to_signed(to_integer(signed(x_10000) / (x"00000000" & signed(Y)) ),64))) ; -- Y concatenado cm mais 8 bits, pra dividir por 64 bit
end if;

end process;

      R <= num (31 downto 0);
     --R <=  std_logic_vector((signed(X)*64)/signed(Y));
    
end Behavioral;