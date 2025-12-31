library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_controlunit16 is
end tb_controlunit16;

architecture sim of tb_controlunit16 is

  -- DUT signals (INITIALIZED)
  signal opcode    : std_logic_vector(3 downto 0) := (others => '0');
  signal alu_op    : std_logic_vector(3 downto 0);
  signal reg_wr_en : std_logic;
  signal use_imm   : std_logic;
  signal pc_inc    : std_logic;

begin

  ------------------------------------------------------
  -- DUT INSTANTIATION
  ------------------------------------------------------
  dut : entity work.ControlUnit16
    port map (
      opcode    => opcode,
      alu_op    => alu_op,
      reg_wr_en => reg_wr_en,
      use_imm   => use_imm,
      pc_inc    => pc_inc
    );

  ------------------------------------------------------
  -- STIMULUS + CHECKS (COMBINATIONAL)
  ------------------------------------------------------
  stim_proc : process
  begin

    --------------------------------------------------
    -- OPCODE 0000 : ADD (Register)
    --------------------------------------------------
    opcode <= "0000";
    wait for 5 ns;

    assert alu_op = "0000" and
           reg_wr_en = '1' and
           use_imm   = '0' and
           pc_inc    = '1'
      report "ERROR: Opcode 0000 (ADD) failed"
      severity error;

    --------------------------------------------------
    -- OPCODE 0001 : SUB (Register)
    --------------------------------------------------
    opcode <= "0001";
    wait for 5 ns;

    assert alu_op = "0001" and
           reg_wr_en = '1' and
           use_imm   = '0' and
           pc_inc    = '1'
      report "ERROR: Opcode 0001 (SUB) failed"
      severity error;

    --------------------------------------------------
    -- OPCODE 1000 : ADD IMMEDIATE
    --------------------------------------------------
    opcode <= "1000";
    wait for 5 ns;

    assert alu_op = "0000" and
           reg_wr_en = '1' and
           use_imm   = '1' and
           pc_inc    = '1'
      report "ERROR: Opcode 1000 (ADDI) failed"
      severity error;

    --------------------------------------------------
    -- INVALID OPCODE (NOP)
    --------------------------------------------------
    opcode <= "1111";
    wait for 5 ns;

    assert alu_op = "0000" and
           reg_wr_en = '0' and
           use_imm   = '0' and
           pc_inc    = '1'
      report "ERROR: Invalid opcode handling failed"
      severity error;

    --------------------------------------------------
    -- END SIMULATION
    --------------------------------------------------
    report "CONTROLUNIT16 TEST PASSED" severity note;
    wait;

  end process;

end sim;

