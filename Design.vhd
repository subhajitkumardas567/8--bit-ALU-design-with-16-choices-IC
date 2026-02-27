library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_8_bit is
    Port (
        A   : in  STD_LOGIC_VECTOR(7 downto 0);
        B   : in  STD_LOGIC_VECTOR(7 downto 0);
        SEL : in  STD_LOGIC_VECTOR(3 downto 0);
        Y   : out STD_LOGIC_VECTOR(7 downto 0)
    );
end ALU_8_bit;

architecture Behavioral of ALU_8_bit is

    signal A_u, B_u : unsigned(7 downto 0);
    signal RESULT   : unsigned(7 downto 0);

begin

    A_u <= unsigned(A);
    B_u <= unsigned(B);

    process(A_u, B_u, SEL)
        variable MUL_FULL : unsigned(15 downto 0);
    begin

        case SEL is

            -- 0000 ADD
            when "0000" =>
                RESULT <= A_u + B_u;

            -- 0001 SUB
            when "0001" =>
                RESULT <= A_u - B_u;

            -- 0010 MUL (lower 8 bits only)
            when "0010" =>
                MUL_FULL := A_u * B_u;
                RESULT   <= MUL_FULL(7 downto 0);

            -- 0011 DIV
            when "0011" =>
                if B_u /= 0 then
                    RESULT <= A_u / B_u;
                else
                    RESULT <= (others => '0');
                end if;

            -- 0100 AND
            when "0100" =>
                RESULT <= A_u and B_u;

            -- 0101 OR
            when "0101" =>
                RESULT <= A_u or B_u;

            -- 0110 XOR
            when "0110" =>
                RESULT <= A_u xor B_u;

            -- 0111 NOT A
            when "0111" =>
                RESULT <= not A_u;

            -- 1000 NAND
            when "1000" =>
                RESULT <= not (A_u and B_u);

            -- 1001 NOR
            when "1001" =>
                RESULT <= not (A_u or B_u);

            -- 1010 XNOR
            when "1010" =>
                RESULT <= not (A_u xor B_u);

            -- 1011 INC (A + 1)
            when "1011" =>
                RESULT <= A_u + 1;

            -- 1100 DEC (A - 1)
            when "1100" =>
                RESULT <= A_u - 1;

            -- 1101 SHL (Shift Left Logical)
            when "1101" =>
                RESULT <= shift_left(A_u, 1);

            -- 1110 SHR (Shift Right Logical)
            when "1110" =>
                RESULT <= shift_right(A_u, 1);

            -- 1111 PASS (Output A)
            when "1111" =>
                RESULT <= A_u;

            -- Default
            when others =>
                RESULT <= (others => '0');

        end case;

    end process;

    Y <= std_logic_vector(RESULT);

end Behavioral;
