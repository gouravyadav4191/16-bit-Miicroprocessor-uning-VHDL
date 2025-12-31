library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ControlUnit16 is
port (
  opcode : in std_logic_vector(3 downto 0);
  alu_op : out std_logic_vector(3 downto 0);
  reg_wr_en : out std_logic;
  use_imm : out std_logic;
  pc_inc : out std_logic
);
end ControlUnit16;

architecture Behavioral of ControlUnit16 is
begin
  process(opcode)
  begin
    alu_op <= "0000";
    reg_wr_en <= '0';
    use_imm <= '0';
    pc_inc <= '1';
    
    case opcode is
      when "0000" => 
        alu_op <= "0000";
        reg_wr_en <= '1';
      when "0001" => 
        alu_op <= "0001";
        reg_wr_en <= '1';
      when "1000" => 
        alu_op <= "0000";
        reg_wr_en <= '1';
        use_imm <= '1';
      when others => 
        null;
    end case;
  end process;
end Behavioral;

