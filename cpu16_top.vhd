library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CPU16 is
    Port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        instr_in : in  std_logic_vector(15 downto 0);

        pc_out   : out std_logic_vector(15 downto 0);
        debug    : out std_logic_vector(15 downto 0);

        -- STATUS FLAGS OUTPUT
        flags_out : out std_logic_vector(3 downto 0)  -- Z C N V
    );
end CPU16;

architecture Structural of CPU16 is

    -- Instruction fields
    signal opcode, dest_reg, src1_reg, src2_reg : std_logic_vector(3 downto 0);

    -- Control signals
    signal alu_op_sig : std_logic_vector(3 downto 0);
    signal reg_wr_en, use_imm, pc_inc : std_logic;

    -- Datapath signals
    signal rd_data1, rd_data2 : std_logic_vector(15 downto 0);
    signal alu_b, alu_result  : std_logic_vector(15 downto 0);
    signal imm16              : std_logic_vector(15 downto 0);

    -- ALU flags (combinational)
    signal Z_i, C_i, N_i, V_i : std_logic;

    -- Registered flags
    signal Z, C, N, V : std_logic;

begin

    --------------------------------------------------
    -- INSTRUCTION DECODE
    --------------------------------------------------
    opcode   <= instr_in(15 downto 12);
    dest_reg <= instr_in(11 downto 8);
    src1_reg <= instr_in(7 downto 4);
    src2_reg <= instr_in(3 downto 0);

    -- Sign-extend 4-bit immediate
    imm16 <= std_logic_vector(resize(signed(instr_in(3 downto 0)), 16));

    --------------------------------------------------
    -- REGISTER FILE
    --------------------------------------------------
    regfile_inst : entity work.RegFile16x16
    port map (
        clk      => clk,
        rst      => rst,
        rd_addr1 => src1_reg,
        rd_addr2 => src2_reg,
        wr_addr  => dest_reg,
        wr_data  => alu_result,
        wr_en    => reg_wr_en,
        rd_data1 => rd_data1,
        rd_data2 => rd_data2
    );

    --------------------------------------------------
    -- CONTROL UNIT
    --------------------------------------------------
    cu_inst : entity work.ControlUnit16
    port map (
        opcode    => opcode,
        alu_op    => alu_op_sig,
        reg_wr_en => reg_wr_en,
        use_imm   => use_imm,
        pc_inc    => pc_inc
    );

    --------------------------------------------------
    -- PROGRAM COUNTER
    --------------------------------------------------
    pc_inst : entity work.PC16
    port map (
        clk    => clk,
        rst    => rst,
        inc    => pc_inc,
        pc_out => pc_out
    );

    --------------------------------------------------
    -- ALU
    --------------------------------------------------
    alu_inst : entity work.ALU16
    port map (
        A      => rd_data1,
        B      => alu_b,
        alu_op => alu_op_sig,
        result => alu_result,
        Z      => Z_i,
        C      => C_i,
        N      => N_i,
        V      => V_i
    );

    alu_b <= imm16 when use_imm = '1' else rd_data2;

    --------------------------------------------------
    -- FLAG REGISTER (STORE FLAGS)
    --------------------------------------------------
    process(clk, rst)
    begin
        if rst = '1' then
            Z <= '0';
            C <= '0';
            N <= '0';
            V <= '0';
        elsif rising_edge(clk) then
            Z <= Z_i;
            C <= C_i;
            N <= N_i;
            V <= V_i;
        end if;
    end process;

    flags_out <= Z & C & N & V;

    --------------------------------------------------
    -- DEBUG
    --------------------------------------------------
    debug <= rd_data1;

end Structural;

