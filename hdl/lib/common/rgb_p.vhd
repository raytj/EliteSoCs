library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package rgb_p is 

  type rgb_t is record
    Red   : std_logic;
    Green : std_logic;
    Blue  : std_logic;
  end record rgb_t;

  constant cDEFAULT_RGB : rgb_t := (
    Red   => '0',
    Green => '0',
    Blue  => '0'
  );

  type rgb_array_t is array(integer range <>) of rgb_t;

  type rgb_opcode_t is (
    OFF,    -- x"0"
    STATIC, -- x"1"
    BLINK,  -- x"2"
    CYCLE,  -- x"3"
    TWINKLE -- x"4"
  );

  constant cRGB_OPCODE_OFF     : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(rgb_opcode_t'pos(OFF),4));
  constant cRGB_OPCODE_STATIC  : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(rgb_opcode_t'pos(STATIC),4));
  constant cRGB_OPCODE_BLINK   : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(rgb_opcode_t'pos(BLINK),4));
  constant cRGB_OPCODE_CYCLE   : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(rgb_opcode_t'pos(CYCLE),4));
  constant cRGB_OPCODE_TWINKLE : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(rgb_opcode_t'pos(TWINKLE),4));

  type rgb_control_t is record
    OpCode : rgb_opcode_t;
    Red    : std_logic_vector(7 downto 0);
    Green  : std_logic_vector(7 downto 0);
    Blue   : std_logic_vector(7 downto 0);
  end record rgb_control_t;

   constant cDEFAULT_RGB_CONTROL : rgb_control_t := (
    OpCode => OFF,
    Red    => (others => '0'),
    Green  => (others => '0'),
    Blue   => (others => '0')
  );

  type rgb_control_array_t is array(integer range <>) of rgb_control_t;

  type rgb_command_t is record
    Control : rgb_control_t;
    Data    : std_logic_vector(31 downto 0);
  end record rgb_command_t;

  constant cDEFAULT_RGB_COMMAND : rgb_command_t := (
    Control => cDEFAULT_RGB_CONTROL,
    Data    => (others => '0')
  );

  type rgb_command_array_t is array(integer range <>) of rgb_command_t;

  function toRgbOpCode(
    vecIn : std_logic_vector
  ) return rgb_opcode_t;

  function toVector(
    recIn : rgb_opcode_t
  ) return std_logic_vector;

  function toRgbControl(
    vecIn : std_logic_vector
  ) return rgb_control_t;

  function toVector(
    recIn : rgb_control_t
  ) return std_logic_vector;

end rgb_p;

package body rgb_p is

  function toRgbOpCode(
    vecIn : std_logic_vector
  ) return rgb_opcode_t is
    variable recOut : rgb_opcode_t;
  begin
    case(vecIn(3 downto 0)) is
      when cRGB_OPCODE_OFF =>
        recOut := OFF;
      when cRGB_OPCODE_STATIC =>
        recOut := STATIC;
      when cRGB_OPCODE_BLINK =>
        recOut := BLINK;
      when cRGB_OPCODE_CYCLE =>
        recOut := CYCLE;
      when cRGB_OPCODE_TWINKLE =>
        recOut := TWINKLE;
      when others => 
        recOut := OFF;
    end case;
    return recOut;
  end function toRgbOpCode;

  function toVector(
    recIn : rgb_opcode_t
  ) return std_logic_vector is
    vecOut : std_logic_vector(3 downto 0) := (others => '0');
  begin
    case recIn is
      when OFF =>
        vecOut := cRGB_OPCODE_OFF;
      when STATIC =>
        vecOut := cRGB_OPCODE_STATIC;
      when BLINK =>
        vecOut := cRGB_OPCODE_BLINK;
      when CYCLE =>
        vecOut := cRGB_OPCODE_CYCLE;
      when TWINKLE =>
        vecOut := cRGB_OPCODE_TWINKLE;
      when others =>
        vecOut := cRGB_OPCODE_OFF;
    end case;

    return vecOut;
  end function toVector;

  function toRgbControl(
    vecIn : std_logic_vector
  ) return rgb_control_t is
    constant OPCODE_RANGE : std_logic_vector(vecIn'high downto vecIn'high - cRGB_OPCODE_OFF'high) := (others => '0');
    constant RED_RANGE    : std_logic_vector(OPCODE_RANGE'low-1 downto OPCODE_RANGE'low-1-rgb_control_t.Red'high) := (others => '0');
    constant GREEN_RANGE  : std_logic_vector(RED_RANGE'low-1 downto RED_RANGE'low-1-rgb_control_t.Green'high) := (others => '0');
    constant BLUE_RANGE   : std_logic_vector(GREEN_RANGE'low-1 downto GREEN_RANGE'low-1-rgb_control_t.Blue'high) := (others => '0');
    variable recOut : rgb_control_t := cDEFAULT_RGB_CONTROL;
  begin
    assert (vecIn'length > 4 + rgb_control_t.Red'length + rgb_control_t.Green'length + rgb_control_t.Blue'length)
      report "ERROR: toRgbControl vecIn must be at least " + integer'image(rgb_control_t.OpCode'length + rgb_control_t.Red'length + rgb_control_t.Green'length + rgb_control_t.Blue'length) +
        "bits wide!" severity failure;
    recOut.OpCode := toRgbOpCode(vecIn(OPCODE_RANGE'range));
    recOut.Red    := vecIn(RED_RANGE'range);
    recOut.Blue   := vecIn(GREEN_RANGE'range);
    recOut.Green  := vecIn(BLUE_RANGE'range);
    return recOut;
  end function toRgbControl;

  function toVector(
    recIn : rgb_control_t
  ) return std_logic_vector is
    variable vecOut : std_logic_vector(31 downto 0) := (others => '0');
  begin
    vecOut(31 downto 28) := toVector(recIn.OpCode);
    vecOut(23 downto 0)  := recIn.Red & recIn.Green & recIn.Blue;
    return vecOut;
  end function toVector;

end rgb_p;