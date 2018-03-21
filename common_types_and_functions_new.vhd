----------------------------------------------------------------------------------

-- Company: 

-- Engineer: 

-- 

-- Create Date: 01/29/2018 12:31:59 PM

-- Design Name: 

-- Module Name: common_types_and_functions - Behavioral

-- Project Name: 

-- Target Devices: 

-- Tool Versions: 

-- Description: 

-- 

-- Dependencies: 

-- 

-- Revision:

-- Revision 0.01 - File Created

-- Additional Comments:

-- 

----------------------------------------------------------------------------------





library IEEE;

use IEEE.STD_LOGIC_1164.all;

use IEEE.STD_LOGIC_ARITH.all;

use ieee.numeric_std.all;



library work;



-- Uncomment the following library declaration if using

-- arithmetic functions with Signed or Unsigned values

--use IEEE.NUMERIC_STD.ALL;



-- Uncomment the following library declaration if instantiating

-- any Xilinx leaf cells in this code.

--library UNISIM;

--use UNISIM.VComponents.all;



package Common_types_and_functions is

  -- N_PIXELS is the number of pixels in the hyperspectral image

  constant N_PIXELS : integer;

  -- P_BANDS  is the number of spectral bands

constant P_BANDS: integer := 12;
  -- K is size of the kernel used in LRX. 

  constant K        : integer;

  --constant pixel_data_size is std_logic_vector(11 downto 0);

  --type pixel_vector is array (0 to 100 -1) of std_logic_vector(pixel_data_size downto 0);

  --generic ( N_PIXELS: integer := 2578;

  --          P_BANDS : integer := 100);

  --assuming pixel_data_size is 16 bit;          

  type matrix is array (natural range <>, natural range <>) of std_logic_vector(15 downto 0);

  -- for correlation results

  type matrix_32 is array (natural range <>, natural range <>) of std_logic_vector(31 downto 0);



  -- drive signals

  constant STATE_IDLE_DRIVE                        : std_logic_vector(2 downto 0) := "000";

  constant STATE_FORWARD_ELIM_TRIANGULAR_FINISHED  : std_logic_vector(2 downto 0) := "001";

  constant STATE_FORWARD_ELIMINATION_FINISHED      : std_logic_vector(2 downto 0) := "010";

  constant STATE_BACKWARD_ELIMINATION_FINISHED     : std_logic_vector(2 downto 0) := "011";

  constant STATE_IDENTITY_MATRIX_BUILDING_FINISHED : std_logic_vector(2 downto 0) := "111";



  -- start signals for fsm

  constant IDLING                         : std_logic_vector(1 downto 0) := "00";

  constant START_FORWARD_ELIMINATION      : std_logic_vector(1 downto 0) := "01";

  constant START_BACKWARD_ELIMINATION     : std_logic_vector(1 downto 0) := "10";

  constant START_IDENTITY_MATRIX_BUILDING : std_logic_vector(1 downto 0) := "11";



  -- Forward-elimination specific signals



  constant START_FORWARD_ELIM_TRIANGULAR : std_logic_vector (1 downto 0) := "10";

  constant START_FORWARD_ELIM_CORE       : std_logic_vector(1 downto 0)  := "11";

  constant STATE_FORWARD_TRIANGULAR      : std_logic_vector(1 downto 0)  := "10";

  constant STATE_FORWARD_ELIM            : std_logic_vector(1 downto 0)  := "11";



  type state_type is (STATE_IDLE, STATE_FORWARD_ELIMINATION, STATE_BACKWARD_ELIMINATION, STATE_IDENTITY_MATRIX_BUILDING);



  type reg_state_type is record

    state                           : state_type;

    drive                           : std_logic_vector(2 downto 0);

    fsm_start_signal                : std_logic_vector(1 downto 0);

    inner_loop_iter_finished        : std_logic;

    inner_loop_last_iter_finished   : std_logic;

    start_inner_loop                : std_logic;

    forward_elim_ctrl_signal        : std_logic_vector(1 downto 0);

    forward_elim_state_signal       : std_logic_vector(1 downto 0);

    flag_forward_core_started       : std_logic;

    flag_forward_triangular_started : std_logic;

  end record;



  type row_reg_type is record

    row_j        : matrix_32(0 to 0, 0 to P_BANDS-1);

    row_i        : matrix_32(0 to 0, 0 to P_BANDS-1);

    inv_row_j    : matrix_32(0 to 0, 0 to P_BANDS-1);

    inv_row_i    : matrix_32(0 to 0, 0 to P_BANDS-1);

    a_j_i        : std_logic_vector(0 to 31);

    a_i_i        : std_logic_vector(0 to 31);

    elim_index_i : std_logic_vector(0 to 31);  -- outer loop index

    elim_index_j : std_logic_vector(0 to 31);  -- inner loop index

    valid_data   : std_logic;

  end record;



  type matrix_reg_type is record

    matrix            : matrix_32 (0 to P_BANDS-1, 0 to P_BANDS-1);

    matrix_inv        : matrix_32 (0 to P_BANDS-1, 0 to P_BANDS-1);

    valid_matrix_data : std_logic;

    row_reg           : row_reg_type;

    state_reg         : reg_state_type;

  end record;



  constant C_ROW_REG_TYPE_INIT : row_reg_type := (

    row_j        => (others => (others => (others => '0'))),

    row_i        => (others => (others => (others => '0'))),

    inv_row_j    => (others => (others => (others => '0'))),

    inv_row_i    => (others => (others => (others => '0'))),

    a_j_i        => (others => '0'),

    a_i_i        => (others => '0'),

    elim_index_i => (others => '0'),

    elim_index_j => (others => '0'),

    valid_data   => '0'

    );





  constant C_STATE_REG_TYPE_INIT : reg_state_type := (

    state                           => STATE_IDLE,

    drive                           => STATE_IDLE_DRIVE,

    fsm_start_signal                => IDLING,

    inner_loop_iter_finished        => '0',

    inner_loop_last_iter_finished   => '0',

    start_inner_loop                => '0',

    forward_elim_ctrl_signal        => IDLING,

    forward_elim_state_signal       => IDLING,

    flag_forward_core_started       => '0',

    flag_forward_triangular_started => '0'

    );



  constant C_MATRIX_REG_TYPE_INIT : matrix_reg_type := (

    matrix            => (others => (others => (others => '0'))),

    matrix_inv        => (others => (others => (others => '0'))),

    valid_matrix_data => '0',

    row_reg           => C_ROW_REG_TYPE_INIT,

    state_reg         => C_STATE_REG_TYPE_INIT

    );



  function log2(i                    : natural) return integer;

  function sel (n                    : natural) return integer;

  function create_identity_matrix (n : natural) return matrix_32;



end Common_types_and_functions;



package body Common_types_and_functions is

  -- Found in SmallSat project description:

  --constant N_PIXELS : integer := 2578;

constant P_BANDS: integer := 12;
  constant N_PIXELS : integer := 3;

constant P_BANDS: integer := 12;


  constant K : integer := 0;





  function log2(i : natural) return integer is

    variable temp    : integer := i;

    variable ret_val : integer := 0;

  begin

    while (temp > 1) loop

      ret_val := ret_val + 1;

      temp    := temp / 2;

    end loop;



    return ret_val;

  end function;



  function create_identity_matrix(n : natural) return matrix_32 is

    variable M_identity_matrix : matrix_32( 0 to P_BANDS-1, 0 to P_BANDS-1);

  begin

    M_identity_matrix := (others => (others => (others => '0')));

    for i in 0 to n-1 loop

      M_identity_matrix(i, i) := std_logic_vector(to_unsigned(1, 32));

    end loop;

    return M_identity_matrix;

  end function;



  function sel(n : natural) return integer is

  begin

    return n;

  end function;







end Common_types_and_functions;

