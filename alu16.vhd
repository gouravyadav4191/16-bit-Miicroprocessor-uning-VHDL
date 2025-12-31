library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU16 is
port (
  A : in std_logic_vector(15 downto 0);
  B : in std_logic_vector(15 downto 0);
  alu_op : in std_logic_vector(3 downto 0);
  result : out std_logic_vector(15 downto 0);

  -- STATUS FLAGS
  Z : out std_logic; -- Zero
  C : out std_logic; -- Carry
  N : out std_logic; -- Negative
  V : out std_logic  -- Overflow
);
end ALU16;

architecture Behavioral of ALU16 is
  signal add_ext : unsigned(16 downto 0);
  signal sub_ext : unsigned(16 downto 0);
  signal internal_result : std_logic_vector(15 downto 0);
begin

  -- Extended arithmetic for carry detection
  add_ext <= ('0' & unsigned(A)) + ('0' & unsigned(B));
  sub_ext <= ('0' & unsigned(A)) - ('0' & unsigned(B));

  -- ALU operation select
  internal_result <= std_logic_vector(add_ext(15 downto 0)) when alu_op = "0000" else
                     std_logic_vector(sub_ext(15 downto 0)) when alu_op = "0001" else
                     (A and B) when alu_op = "0010" else
                     (A or B)  when alu_op = "0011" else
                     (others => '0');

  result <= internal_result;

  ------------------------------------------------
  -- STATUS FLAGS
  ------------------------------------------------
  Z <= '1' when internal_result = x"0000" else '0';
  N <= internal_result(15);

  C <= add_ext(16) when alu_op = "0000" else
       sub_ext(16) when alu_op = "0001" else
       '0';

  -- Signed overflow detection
  V <= (A(15) xor internal_result(15)) and not (A(15) xor B(15))
       when alu_op = "0000" else
       (A(15) xor internal_result(15)) and (A(15) xor B(15))
       when alu_op = "0001" else
       '0';

end Behavioral;

