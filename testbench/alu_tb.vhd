library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_ALU_full is
end tb_ALU_full;

architecture Behavioral of tb_ALU_full is

    component ALU_8_bit
        Port (
            A   : in  STD_LOGIC_VECTOR(7 downto 0);
            B   : in  STD_LOGIC_VECTOR(7 downto 0);
            SEL : in  STD_LOGIC_VECTOR(3 downto 0);
            Y   : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    signal A   : STD_LOGIC_VECTOR(7 downto 0);
    signal B   : STD_LOGIC_VECTOR(7 downto 0);
    signal SEL : STD_LOGIC_VECTOR(3 downto 0);
    signal Y   : STD_LOGIC_VECTOR(7 downto 0);

begin

    UUT: ALU_8_bit
        port map (
            A   => A,
            B   => B,
            SEL => SEL,
            Y   => Y
        );

    stimulus : process
        variable A_int, B_int : unsigned(7 downto 0);
        variable expected     : unsigned(7 downto 0);
        variable mul_full     : unsigned(15 downto 0);
    begin

        -- Test several input combinations
        for i in 0 to 5 loop

            A_int := to_unsigned(i*15 + 5, 8);
            B_int := to_unsigned(i + 3, 8);

            A <= std_logic_vector(A_int);
            B <= std_logic_vector(B_int);

            for op in 0 to 15 loop

                SEL <= std_logic_vector(to_unsigned(op,4));
                wait for 10 ns;

                case op is

                    when 0 =>  -- ADD
                        expected := A_int + B_int;

                    when 1 =>  -- SUB
                        expected := A_int - B_int;

                    when 2 =>  -- MUL
                        mul_full := A_int * B_int;
                        expected := mul_full(7 downto 0);

                    when 3 =>  -- DIV
                        if B_int /= 0 then
                            expected := A_int / B_int;
                        else
                            expected := (others => '0');
                        end if;

                    when 4 =>  -- AND
                        expected := A_int and B_int;

                    when 5 =>  -- OR
                        expected := A_int or B_int;

                    when 6 =>  -- XOR
                        expected := A_int xor B_int;

                    when 7 =>  -- NOT
                        expected := not A_int;

                    when 8 =>  -- NAND
                        expected := not (A_int and B_int);

                    when 9 =>  -- NOR
                        expected := not (A_int or B_int);

                    when 10 => -- XNOR
                        expected := not (A_int xor B_int);

                    when 11 => -- INC
                        expected := A_int + 1;

                    when 12 => -- DEC
                        expected := A_int - 1;

                    when 13 => -- SHL
                        expected := shift_left(A_int,1);

                    when 14 => -- SHR
                        expected := shift_right(A_int,1);

                    when 15 => -- PASS
                        expected := A_int;

                    when others =>
                        expected := (others => '0');

                end case;

                -- Automatic checking
                assert Y = std_logic_vector(expected)
                report "Mismatch! A=" & integer'image(to_integer(A_int)) &
                       " B=" & integer'image(to_integer(B_int)) &
                       " OP=" & integer'image(op)
                severity error;

            end loop;
        end loop;

        report "ALL 16-OPERATION TESTS COMPLETED SUCCESSFULLY!"
        severity note;

        wait;
    end process;

end Behavioral;
