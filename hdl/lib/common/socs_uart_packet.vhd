library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library common;
use common.led_p.all;
use common.rgb_p.all;
use common.toggle_p.all;

--32 bit words
-- Command Packet
--0   - Header              -> (31:0) ASCII "SOCC" SoC Command Packet
--1   - IO Output Word 0    -> (31:0) CK_IO(31 downto 0) Set Output
--2   - IO Output Word 1    -> (31:10) Blank (9:0) CK_IO(41 downto 32) Set Output
--3   - LED Word 0          -> (31:28) LED1 OpCode NoteX (27:16) LED1 Command NoteX (15:12) LED0 OpCode NoteX (11:0) LED0 Command NoteX
--4   - LED Word 1          -> (31:28) LED3 OpCode NoteX (27:16) LED3 Command NoteX (15:12) LED2 OpCode NoteX (11:0) LED2 Command NoteX
--5   - RGB Word 0          -> (31:28) RGB0 OpCode NoteX (23:16) RGB0 Blue Command (15:8) RGB0 Green Command (7:0) RGB0 Red Command
--6   - RGB Word 1          -> (31:0) RGB0 Command Data
--7   - RGB Word 2          -> (31:28) RGB1 OpCode NoteX (23:16) RGB1 Blue Command (15:8) RGB1 Green Command (7:0) RGB1 Red Command
--8   - RGB Word 3          -> (31:0) RGB1 Command Data
--9   - Footer              -> (31:0) ASCII "socc"

-- IO Status Packet
--0   - Header                  -> (31:0) ASCII "SOCS" SoC Status Packet
--1   - IO Enable Status Word 0 -> (31:0) CK_EN(31 downto 0) Input Enable State
--2   - IO Enable Status Word 1 -> (31:10) Blank (9:0) CK_EN(41 downto 32) Input Enable
--3   - IO Input Status Word 0  -> (31:0) CK_IO(31 downto 0) Input State
--4   - IO Input Status Word 1  -> (31:10) Blank (9:0) CK_IO(41 downto 32) Input State
--5   - DIP Input Status Word 0 -> (31:25) DIP3 Toggle Count (24) DIP3 State (23:17) DIP2 Toggle Count (16) DIP2 State (15:9) DIP1 Toggle Count (8) DIP1 State (7:1) DIP0 Toggle Count (0) DIP0 State
--6   - PB Input Status Word 0  -> (31:25) PB3 Toggle Count (24) PB3 State (23:17) PB2 Toggle Count (16) PB2 State (15:9) PB1 Toggle Count (8) PB1 State (7:1) PB0 Toggle Count (0) PB0 State
--7   - Footer                  -> (31:0) ASCII "socs"

-- Reset Packet
--0   - Header              -> (31:0) ASCII "SOCR" SoC Reset Packet
--1   - IO_EN Word 0        -> (31:0) CK_IO(31 downto 0) Input Enable
--2   - IO_EN Word 1        -> (31:10) Blank (9:0) CK_IO(41 downto 32) Input Enable
--3   - Status Update Rate  -> (31:0) Status Update Rate in FPGA cc NoteX
--4   - Footer              -> (31:0) ASCII "socr"

package socs_uart_packet_p is 

  type packet_info_t is record
    Header : std_logic_vector(31 downto 0);
    Footer : std_logic_vector(31 downto 0);
    Length : integer;
  end record packet_info_t;

  type message_enum_t is (
    SOCC,
    SOCS,
    SOCR
  );

  type soc_packet_info_array_t is array(message_enum_t) of packet_info_t;

  constant cPACKET_INFO : soc_packet_info_array_t := (
    SOCC => (
      Header => x"534f4343",
      Footer => x"736f6363",
      Length => 10
    ),
    SOCS => (
      Header => x"534f4353",
      Footer => x"736f6373",
      Length => 8
    ),
    SOCR => (
      Header => x"534f4352",
      Footer => x"736f6372",
      Length => 4
    )
  );

  type SOCC_t is record
    Header : std_logic_vector(31 downto 0);
    CK_IO  : std_logic_vector(41 downto 0);
    LED    : led_control_array_t(0 to 3);
    RGB    : rgb_command_array_t(0 to 1);
    Footer : std_logic_vector(31 downto 0);
  end record SOCC_t;

  type SOCS_t is record
    Header : std_logic_vector(31 downto 0);
    CK_EN  : std_logic_vector(41 downto 0);
    CK_IO  : std_logic_vector(41 downto 0);
    DIP    : toggle_status_array_t(0 to 3);
    PB     : toggle_status_array_t(0 to 3);
    Footer : std_logic_vector(31 downto 0);
  end record SOCS_t;

  type SOCR_t is record
    Header           : std_logic_vector(31 downto 0);
    IO_EN            : std_logic_vector(41 downto 0);
    StatusUpdateRate : std_logic_vector(31 downto 0);
    Footer           : std_logic_vector(31 downto 0);
  end record SOCR_t;

end socs_uart_packet_p;

package body socs_uart_packet_p is

end socs_uart_packet_p;