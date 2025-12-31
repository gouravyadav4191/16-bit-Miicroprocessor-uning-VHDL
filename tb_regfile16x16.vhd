library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_regfile16x16 is
end tb_regfile16x16;

architecture sim of tb_regfile16x16 is

  -- DUT signals (INITIALIZED)
  signal clk      : std_logic := '0';
  signal rst      : std_logic := '0';
  signal rd_addr1 : std_logic_vector(3 downto 0) := (others => '0');
  signal rd_addr2 : std_logic_vector(3 downto 0) := (others => '0');
  signal wr_addr  : std_logic_vector(3 downto 0) := (others => '0');
  signal wr_data  : std_logic_vector(15 downto 0) := (others => '0');
  signal wr_en    : std_logic := '0';
  signal rd_data1 : std_logic_vector(15 downto 0);
  signal rd_data2 : std_logic_vector(15 downto 0);

  constant CLK_PERIOD : time := 10 ns;

begin

  ------------------------------------------------------
  -- DUT INSTANTIATION
  ------------------------------------------------------
  dut : entity work.RegFile16x16
    port map (
      clk      => clk,
      rst      => rst,
      rd_addr1 => rd_addr1,
      rd_addr2 => rd_addr2,
      wr_addr  => wr_addr,
      wr_data  => wr_data,
      wr_en    => wr_en,
      rd_data1 => rd_data1,
      rd_data2 => rd_data2
    );

  ------------------------------------------------------
  -- CLOCK GENERATOR
  ------------------------------------------------------
  clk_process : process
  begin
    clk <= '0';
    wait for CLK_PERIOD/2;
    clk <= '1';
    wait for CLK_PERIOD/2;
  end process;

  ------------------------------------------------------
  -- STIMULUS + CHECKS
  ------------------------------------------------------
  stim_proc : process
  begin
    --------------------------------------------------
    -- RESET (SYNCHRONIZED)
    --------------------------------------------------
    rst <= '1';
    wr_en <= '0';
    wait until rising_edge(clk);
    rst <= '0';
    wait until rising_edge(clk);

    -- Check reset cleared registers
    rd_addr1 <= "0000";
    rd_addr2 <= "0001";
    wait for 1 ns;

    assert rd_data1 = x"0000" and rd_data2 = x"0000"
      report "ERROR: Registers not cleared on reset"
      severity error;

    --------------------------------------------------
    -- WRITE TO REGISTER 3
    --------------------------------------------------
    wr_addr <= "0011";     -- R3
    wr_data <= x"00AA";
    wr_en   <= '1';
    wait until rising_edge(clk);
    wr_en <= '0';

    --------------------------------------------------
    -- READ REGISTER 3
    --------------------------------------------------
    rd_addr1 <= "0011";
    wait for 1 ns;

    assert rd_data1 = x"00AA"
      report "ERROR: Write/Read failed for R3"
      severity error;

    --------------------------------------------------
    -- WRITE TO REGISTER 5
    --------------------------------------------------
    wr_addr <= "0101";     -- R5
    wr_data <= x"1234";
    wr_en   <= '1';
    wait until rising_edge(clk);
    wr_en <= '0';

    --------------------------------------------------
    -- READ BOTH REGISTERS
    --------------------------------------------------
    rd_addr1 <= "0011";    -- R3
    rd_addr2 <= "0101";    -- R5
    wait for 1 ns;

    assert rd_data1 = x"00AA" and rd_data2 = x"1234"
      report "ERROR: Dual read failed"
      severity error;

    --------------------------------------------------
    -- WRITE DISABLED CHECK
    --------------------------------------------------
    wr_addr <= "0011";
    wr_data <= x"FFFF";
    wr_en   <= '0';
    wait until rising_edge(clk);

    rd_addr1 <= "0011";
    wait for 1 ns;

    assert rd_data1 = x"00AA"
      report "ERROR: Register changed when wr_en = 0"
      severity error;

    --------------------------------------------------
    -- END SIMULATION
    --------------------------------------------------
    report "REGFILE16x16 TEST PASSED" severity note;
    wait;
  end process;

end sim;

