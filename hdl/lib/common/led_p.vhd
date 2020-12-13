library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library common;
use common.std_logic_subtypes_p.all;
use common.numeric_subtypes_p.all;

package led_p is 
  type led_opcode_t is (
    OFF,    -- x"0"
    STATIC, -- x"1"
    BLINK,  -- x"2"
    TWINKLE -- x"3"
  );

  constant cLED_OPCODE_OFF     : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(led_opcode_t'pos(OFF),4));
  constant cLED_OPCODE_STATIC  : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(led_opcode_t'pos(STATIC),4));
  constant cLED_OPCODE_BLINK   : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(led_opcode_t'pos(BLINK),4));
  constant cLED_OPCODE_TWINKLE : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(led_opcode_t'pos(TWINKLE),4));

  type led_control_t is record
    OpCode : led_opcode_t;
    Data   : std_logic_vector(11 downto 0);
  end record led_control_t;

  constant cDEFAULT_LED_CONTROL : led_control_t := (
    OpCode => OFF,
    Data   => (others => '0')
  );

  type led_control_array_t is array(integer range <>) of led_control_t;

  function toLedOpCode(
    vecIn : std_logic_vector
  ) return led_opcode_t;

  function toVector(
    recIn : led_opcode_t
  ) return std_logic_vector;

  function toLedControl(
    vecIn : std_logic_vector
  ) return led_control_t;

  function toVector(
    recIn : led_control_t
  ) return std_logic_vector;

  function toLedControlArray(
    vecIn : std_logic_vector
  ) return led_control_array_t;

  function toVec32Array(
    recIn : led_control_array_t
  ) return vec32_array_t;

end led_p;

package body led_p is

  function toLedOpCode(
    vecIn : std_logic_vector
  ) return led_opcode_t is
    variable recOut : led_opcode_t;
  begin
    assert (vecIn'length > 3) report "ERROR: toLedOpCode requires a std_logic_vector of at least 4 bits" severity failure;
    case vecIn(vecIn'high downto vecIn'high - 3) is
      when cLED_OPCODE_OFF =>
        recOut := led_opcode_t(OFF);
      when cLED_OPCODE_STATIC =>
        recOut := led_opcode_t(STATIC);
      when cLED_OPCODE_BLINK =>
        recOut := led_opcode_t(BLINK);
      when cLED_OPCODE_TWINKLE =>
        recOut := led_opcode_t(TWINKLE);
      when others =>
        recOut := led_opcode_t(OFF);
    end case;
    return recOut;
  end function toLedOpCode;

  function toVector(
    recIn : led_opcode_t
  ) return std_logic_vector is
    variable vecOut : std_logic_vector(cLED_OPCODE_OFF'range) := (others => '0');
  begin
    case recIn is
      when OFF =>
        vecOut := cLED_OPCODE_OFF;
      when STATIC =>
        vecOut := cLED_OPCODE_STATIC;
      when BLINK =>
        vecOut := cLED_OPCODE_BLINK;
      when TWINKLE =>
        vecOut := cLED_OPCODE_TWINKLE;
      when others =>
        vecOut := cLED_OPCODE_OFF;
    end case;
    return vecOut;
  end function toVector;

  function toLedControl(
    vecIn : std_logic_vector
  ) return led_control_t is
    variable recOut : led_control_t;
  begin
    assert (vecIn'length > 15) report "ERROR: toLedControl requires vecIn to be at least 16 bits wide"
    recOut.OpCode := toLedOpCode(vecIn);
    recOut.Data   := vecIn(vecIn'high-4 downto vecIn'high-15);
    return recOut;
  end function toLedControl;

  function toVector(
    recIn : led_control_t
  ) return std_logic_vector is
    constant OpCodeRange : std_logic_vector(led_control_t.Data'high+cLED_OPCODE_OFF'length downto led_control_t.Data'length) := (others => '0');
    variable vecOut : std_logic_vector(15 downto 0) := (others => '0');
  begin
    vecOut(OpCodeRange'range)         := toVector(recIn.OpCode);
    vecOut(led_control_t.Data'range)  := recIn.Data;
  end function toVector;

  function toLedControlArray(
    vecIn : std_logic_vector
  ) return led_control_array_t is
    constant ArrayLength : integer := vecIn'length / 16;
    variable arrayOut    : led_control_array_t(0 to ArrayLength-1);
    variable idx         : integer := 15;
  begin
    for I in arrayOut'range loop
      arrayOut(I) := toLedControl(vecIn(idx downto idx-15));
      idx         := idx + 16;
    end loop;
    return arrayOut;
  end function toLedControlArray;

  function toVec32Array(
    arrayIn : led_control_array_t
  ) return vec32_array_t is
    constant isEven      : boolean := (arrayIn'length mod 2) = 0;
    constant ArrayLength : integer := arrayIn'length / 2 + (arrayIn'length mod 2);
    variable vecArrayOut : vec32_array_t(0 to ArrayLength-1) := (others => (others => '0'));
    variable idx : integer := 0;
  begin
    for I in vecArrayOut'range loop
      vecArrayOut(I)(15 downto 0) := toVector(arrayIn(idx));
      if (I = vecArrayOut'high and not isEven) then
        vecArrayOut(I)(31 downto 16) := (others => '0');
      else
        vecArrayOut(I)(31 downto 16) := toVector(arrayIn(idx + 1));
      end if;
      idx := idx + 2;
    end loop;
    return vecArrayOut;
  end function toVec32Array;

end led_p;