library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_alu16 is
end tb_alu16;

architecture sim of tb_alu16 is

  -- DUT signals
  signal A      : std_logic_vector(15 downto 0);
  signal B      : std_logic_vector(15 downto 0);
  signal alu_op : std_logic_vector(3 downto 0);
  signal result : std_logic_vector(15 downto 0);

  -- STATUS FLAGS
  signal Z : std_logic;
  signal C : std_logic;
  signal N : std_logic;
  signal V : std_logic;

begin

  ------------------------------------------------------
  -- DUT INSTANTIATION
  ------------------------------------------------------
  dut : entity work.ALU16
    port map (
      A      => A,
      B      => B,
      alu_op => alu_op,
      result => result,
      Z      => Z,
      C      => C,
      N      => N,
      V      => V
    );

  ------------------------------------------------------
  -- STIMULUS PROCESS
  ------------------------------------------------------
  stim_proc : process
  begin

    -- ADD
    A <= x"0005"; B <= x"0003"; alu_op <= "0000";
    wait for 10 ns;
    assert result = x"0008" and Z='0' and C='0'
      report "ADD failed" severity error;

    -- ADD with carry
    A <= x"FFFF"; B <= x"0001"; alu_op <= "0000";
    wait for 10 ns;
    assert result = x"0000" and Z='1' and C='1'
      report "ADD carry failed" severity error;

    -- SUB zero
    A <= x"0008"; B <= x"0008"; alu_op <= "0001";
    wait for 10 ns;
    assert result = x"0000" and Z='1'
      report "SUB zero failed" severity error;

    -- SUB negative
    A <= x"0003"; B <= x"0005"; alu_op <= "0001";
    wait for 10 ns;
    assert N='1'
      report "Negative flag failed" severity error;

    -- Signed overflow
    A <= x"7FFF"; B <= x"0001"; alu_op <= "0000";
    wait for 10 ns;
    assert V='1'
      report "Overflow flag failed" severity error;

    -- AND
    A <= x"00F0"; B <= x"0F0F"; alu_op <= "0010";
    wait for 10 ns;
    assert result = x"0000" and Z='1'
      report "AND failed" severity error;

    -- OR
    A <= x"00F0"; B <= x"000F"; alu_op <= "0011";
    wait for 10 ns;
    assert result = x"00FF" and Z='0'
      report "OR failed" severity error;

    -- INVALID OPCODE
    alu_op <= "1111";
    wait for 10 ns;
    assert result = x"0000" and Z='1'
      report "Invalid opcode failed" severity error;

    report "ALU16 FLAG TEST PASSED" severity note;
    wait;

  end process;

end sim;

