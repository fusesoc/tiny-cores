LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE shift_reg_components IS

    COMPONENT piso
        GENERIC (
            width      : INTEGER := 50;
            extra_bits : INTEGER := 25
        );
        PORT (
            clk      : IN  std_logic;
            load     : IN  std_logic;
            data_in  : IN  std_logic_vector(width-1 downto 0);
            data_out : OUT std_logic
        );
    END COMPONENT;

    COMPONENT sipo
        GENERIC (
            width : INTEGER := 500
        );
        port (
            clk      : IN  std_logic;
            load     : IN  std_logic;
            data_IN  : IN  std_logic;
            data_out : OUT std_logic_vector(width-1 downto 0)
        );
    END COMPONENT;

END PACKAGE shift_reg_components;
