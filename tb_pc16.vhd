
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_pc16 is
end tb_pc16;

architecture sim of tb_pc16 is

  -- DUT signals
  signal clk    : std_logic := '0';
  signal rst    : std_logic := '0';
  signal inc    : std_logic := '0';
  signal pc_out : std_logic_vector(15 downto 0);

  constant CLK_PERIOD : time := 10 ns;

begin

  ------------------------------------------------------
  -- DUT INSTANTIATION
  ------------------------------------------------------
  dut : entity work.PC16
    port map (
      clk    => clk,
      rst    => rst,
      inc    => inc,
      pc_out => pc_out
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
    -- Apply reset (synchronous)
    rst <= '1';
    inc <= '0';
    wait until rising_edge(clk);

    rst <= '0';
    wait until rising_edge(clk);

    -- Check reset value
    assert pc_out = x"0000"
      report "ERROR: PC not zero after reset"
      severity error;

    -- Increment for 5 clock cycles
    inc <= '1';
    for i in 1 to 5 loop
      wait until rising_edge(clk);
    end loop;

    inc <= '0';
    wait until rising_edge(clk);

    -- Check PC = 5
    assert pc_out = std_logic_vector(to_unsigned(5,16))
      report "ERROR: PC increment failed"
      severity error;

    -- Hold value when inc = 0
    wait until rising_edge(clk);
    wait until rising_edge(clk);

    assert pc_out = std_logic_vector(to_unsigned(5,16))
      report "ERROR: PC changed when inc = 0"
      severity error;

    -- Wrap-around test (short & practical)
    rst <= '1';
    wait until rising_edge(clk);
    rst <= '0';

    inc <= '1';
    for i in 1 to 10 loop
      wait until rising_edge(clk);
    end loop;

    -- End simulation
    report "PC16 TEST PASSED" severity note;
    wait;
  end process;

end sim;

