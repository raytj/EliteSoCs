library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library common;
use common.std_logic_subtypes_p.all;
use common.numeric_subtypes_p.all;

package toggle_p is
  type toggle_status_t is record
    ToggleCount : std_logic_vector(6 downto 0);
    State       : std_logic;
  end record toggle_status_t;

  constant cDEFAULT_TOGGLE_STATUS : toggle_status_t := (
    ToggleCount => (others => '0'),
    State       => '0'
  );

  constant cTOGGLE_STATUS_WIDTH : natural := toggle_status_t.ToggleCount'length + 1;

  type toggle_status_array_t is array(integer range <>) of toggle_status_t;

  function toToggleStatus(
    vecIn : std_logic_vector
  ) return toggle_status_t;

  function toVector(
    recIn : toggle_status_t
  ) return std_logic_vector;

  function toToggleStatusArray(
    vecIn : std_logic_vector
  ) return toggle_status_array_t;

  function toToggleStatusArray(
    vecIn : vec32_array_t
  ) return toggle_status_array_t;
-- TODO:
  --function toVector(
  --  arrayIn : toggle_status_array_t
  --) return std_logic_vector;

  --function toVec32Array(
  --  arrayIn : toggle_status_array_t
  --) return vec32_array_t;

end toggle_p;

package body toggle_p is
  
  function toToggleStatus(
    vecIn : std_logic_vector
  ) return toggle_status_t is
    constant toggleCountRange : std_logic_vector(vecIn'high downto vecIn'high - toggle_status_t.ToggleCount'high) := (others => '0');
    variable recOut : toggle_status_t;
  begin
    recOut.ToggleCount := vecIn(toggleCountRange'range);
    recOut.State       := vecIn(toggleCountRange'low-1);
    return recOut;
  end function toToggleStatus;

  function toVector(
    recIn : toggle_status_t
  ) return std_logic_vector is
    variable vecOut : std_logic_vector(toggle_status_t.ToggleCount'length downto 0) := (others => '0');
  begin
    vecOut(vecOut'high downto 1) := recIn.ToggleCount;
    vecOut(0)                    := recIn.State;
    return vecOut;
  end function toVector;

  function toToggleStatusArray(
    vecIn : std_logic_vector
  ) return toggle_status_array_t is
    constant arrayOutLength : integer := vecIn'length / (cTOGGLE_STATUS_WIDTH);
    variable arrayOut : toggle_status_array_t(0 to arrayOutLength-1);
    variable idx      : integer := 0;
  begin
    assert (arrayOutLength > 0) report "ERROR: toToggleStatusArray vecIn must be >= 8 bits wide" severity failure;
    for I in arrayOut'range loop
      arrayOut(I) := toToggleStatus(vecIn(idx + (cTOGGLE_STATUS_WIDTH-1) downto idx));
      idx := idx + cTOGGLE_STATUS_WIDTH;
    end loop;
    return arrayOut;
  end function toToggleStatusArray;

  function toToggleStatusArray(
    arrayIn : vec32_array_t
  ) return toggle_status_array_t is
    constant recsIn32Bits   : intger := 32 / cTOGGLE_STATUS_WIDTH;
    constant arrayOutLength : integer := recsIn32Bits * arrayIn'length;
    variable arrayOut : toggle_status_array_t(0 to arrayOutLength-1);
    variable idxOut   : integer := 0;
    variable idxIn    : integer := 0;
  begin
    for I in arrayIn'range loop
      arrayOut(idxOut + recsIn32Bits-1 downto idxOut) := toToggleStatusArray(arrayIn(I));
      idxOut := idxOut + recsIn32Bits;
    end loop;
    return arrayOut;
  end function toToggleStatusArray;
-- TODO:
  --function toVector(
  --  arrayIn : toggle_status_array_t
  --) return std_logic_vector is
  --  variable vecOut : std_logic_vector( downto 0) := (others => '0');
  --begin

  --end function toVector;

  --function toVec32Array(
  --  arrayIn : toggle_status_array_t
  --) return vec32_array_t is
  --  variable arrayOut : vec32_array_t(0 to );
  --begin

  --end function toVec32Array;

end toggle_p;