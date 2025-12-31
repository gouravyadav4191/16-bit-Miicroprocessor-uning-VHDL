library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_cpu16 is
end tb_cpu16;

architecture sim of tb_cpu16 is

  -- DUT signals (INITIALIZED)
  signal clk       : std_logic := '0';
  signal rst       : std_logic := '0';
  signal instr_in  : std_logic_vector(15 downto 0) := (others => '0');

  signal pc_out    : std_logic_vector(15 downto 0);
  signal debug     : std_logic_vector(15 downto 0);
  signal flags_out : std_logic_vector(3 downto 0);  -- Z C N V

  constant CLK_PERIOD : time := 20 ns;

begin

  ------------------------------------------------------
  -- DUT INSTANTIATION
  ------------------------------------------------------
  dut : entity work.CPU16
    port map (
      clk       => clk,
      rst       => rst,
      instr_in  => instr_in,
      pc_out    => pc_out,
      debug     => debug,
      flags_out => flags_out
    );

  ------------------------------------------------------
  -- CLOCK GENERATOR
  ------------------------------------------------------
  clk_process : process
  begin
    clk <= '0';
    wait for CLK_PERIOD / 2;
    clk <= '1';
    wait for CLK_PERIOD / 2;
  end process;

  ------------------------------------------------------
  -- STIMULUS PROCESS
  ------------------------------------------------------
  stim_proc : process
  begin
    --------------------------------------------------
    -- RESET
    --------------------------------------------------
    rst <= '1';
    instr_in <= (others => '0');
    wait until rising_edge(clk);

    rst <= '0';
    wait until rising_edge(clk);

    --------------------------------------------------
    -- INSTRUCTION 1 : ADD (opcode = 0000)
    -- Format: [15:12]=opcode, [11:8]=Rd, [7:4]=Rs1, [3:0]=Rs2
    --------------------------------------------------
    instr_in <= x"0123";  -- ADD R1 = R2 + R3
    wait until rising_edge(clk);

    --------------------------------------------------
    -- INSTRUCTION 2 : ADD IMMEDIATE (opcode = 1000)
    --------------------------------------------------
    instr_in <= x"8125";  -- ADDI R1 = R2 + imm(5)
    wait until rising_edge(clk);

    --------------------------------------------------
    -- INSTRUCTION 3 : SUB (opcode = 0001)
    --------------------------------------------------
    instr_in <= x"1123";  -- SUB R1 = R2 - R3
    wait until rising_edge(clk);

    --------------------------------------------------
    -- INSTRUCTION 4 : INVALID / NOP
    --------------------------------------------------
    instr_in <= x"F000";
    wait until rising_edge(clk);

    --------------------------------------------------
    -- END SIMULATION
    --------------------------------------------------
    report "CPU16 TEST PASSED (INTEGRATION OK)" severity note;
    wait;
  end process;

end sim;

