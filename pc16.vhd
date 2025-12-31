library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PC16 is
port (
  clk : in std_logic;
  rst : in std_logic;
  inc : in std_logic;
  pc_out : out std_logic_vector(15 downto 0)
);
end PC16;

architecture Behavioral of PC16 is
  signal pc_reg : std_logic_vector(15 downto 0);
begin
  process(clk,rst)
  begin
    if rst = '1' then
      pc_reg <= (others => '0');
    elsif rising_edge(clk) then
      if inc = '1' then
        pc_reg <= std_logic_vector(unsigned(pc_reg) + 1);
      end if;
    end if;
  end process;
  pc_out <= pc_reg;
end Behavioral;

