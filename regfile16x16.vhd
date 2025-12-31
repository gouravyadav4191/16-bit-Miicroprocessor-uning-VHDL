library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegFile16x16 is
port (
  clk : in std_logic;
  rst : in std_logic;
  rd_addr1 : in std_logic_vector(3 downto 0);
  rd_addr2 : in std_logic_vector(3 downto 0);
  wr_addr : in std_logic_vector(3 downto 0);
  wr_data : in std_logic_vector(15 downto 0);
  wr_en : in std_logic;
  rd_data1 : out std_logic_vector(15 downto 0);
  rd_data2 : out std_logic_vector(15 downto 0)
);
end RegFile16x16;

architecture Behavioral of RegFile16x16 is
  type reg_array is array (0 to 15) of std_logic_vector(15 downto 0);
  signal regs : reg_array;
begin
  process(clk,rst)
  begin
    if rst = '1' then
      for i in 0 to 15 loop
        regs(i) <= (others => '0');
      end loop;
    elsif rising_edge(clk) then
      if wr_en = '1' then
        regs(to_integer(unsigned(wr_addr))) <= wr_data;
      end if;
    end if;
  end process;
  
  rd_data1 <= regs(to_integer(unsigned(rd_addr1)));
  rd_data2 <= regs(to_integer(unsigned(rd_addr2)));
end Behavioral;

