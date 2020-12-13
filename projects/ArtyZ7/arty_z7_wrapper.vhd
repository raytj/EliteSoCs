library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

library common;
use common.rgb_p.all;

library system;

entity arty_z7_wrapper is 
  Port (
    -- Clock Signal
    clk : in std_logic; --IO_L13P_T2_MRCC_35 Sch=SYSCLK

    -- Switches
    sw : in std_logic_vector(1 downto 0); --IO_L7N_T1_AD2N_35 Sch=SW0
                                          --IO_L7P_T1_AD2P_35 Sch=SW1

    -- RGB LEDs
    led4_b : out std_logic; --IO_L22N_T3_AD7P_35 Sch=LED4_B
    led4_g : out std_logic; --IO_L16P_T2_35 Sch=LED4_G
    led4_r : out std_logic; --IO_L21P_T3_DQS_AD14P_35 Sch=LED4_R
    led5_b : out std_logic; --IO_0_35 Sch=LED5_B
    led5_g : out std_logic; --IO_L22P_T3_AD7P_35 Sch=LED5_G
    led5_r : out std_logic; --IO_L23N_T3_35 Sch=LED5_R

    -- LEDs
    led : out std_logic_vector(3 downto 0); --IO_L6N_T0_VREF_34 Sch=LED0
                                            --IO_L6P_T0_34 Sch=LED1
                                            --IO_L21N_T3_DQS_AD14N_35 Sch=LED2
                                            --IO_L23P_T3_35 Sch=LED3

    -- Buttons
    btn : in std_logic_vector(3 downto 0); --IO_L4P_T0_35 Sch=BTN0
                                           --IO_L4N_T0_35 Sch=BTN1
                                           --IO_L9N_T1_DQS_AD3N_35 Sch=BTN2
                                           --IO_L9P_T1_DQS_AD3P_35 Sch=BTN3

    ---- Pmod Header JA
    ---- Note: if using for single ended I/O, use only _p signals and connect _n to logic '0'
    --ja_p : in std_logic_vector(4 downto 1); --IO_L17P_T2_34 Sch=JA1_P 
    --ja_n : in std_logic_vector(4 downto 1); --IO_L17N_T2_34 Sch=JA1_N
    --                                        --IO_L7P_T1_34 Sch=JA2_P
    --                                        --IO_L7N_T1_34 Sch=JA2_N
    --                                        --IO_L12P_T1_MRCC_34 Sch=JA3_P
    --                                        --IO_L12N_T1_MRCC_34 Sch=JA3_N
    --                                        --IO_L22P_T3_34 Sch=JA4_P
    --                                        --IO_L22N_T3_34 Sch=JA4_N

    ---- Pmod Header JB
    ---- Note: if using for single ended I/O, use only _p signals and connect _n to logic '0'
    --jb_n : out std_logic_vector(4 downto 1); --IO_L8N_T1_34 Sch=JB1_N
    --jb_p : out std_logic_vector(4 downto 1); --IO_L8P_T1_34 Sch=JB1_P
    --                                         --IO_L1N_T0_34 Sch=JB2_N
    --                                         --IO_L1P_T0_34 Sch=JB2_P
    --                                         --IO_L18N_T2_34 Sch=JB3_N
    --                                         --IO_L18P_T2_34 Sch=JB3_P
    --                                         --IO_L4N_T0_34 Sch=JB4_N
    --                                         --IO_L4P_T0_34 Sch=JB4_P

    ---- Audio Out
    --aud_pwm : out std_logic; --IO_L20N_T3_34 Sch=AUD_PWM
    --aud_sd :  out std_logic; --IO_L20P_T3_34 Sch=AUD_SD

    ---- Crypto SDA 
    ---- 230 baud
    --crypto_sda : inout std_logic; --IO_25_35 Sch=CRYPTO_SDA

    ---- HDMI RX Signals
    --hdmi_rx_cec   : inout std_logic;                    --IO_L13N_T2_MRCC_35 Sch=HDMI_RX_CEC
    --hdmi_rx_clk_n : in    std_logic;                    --IO_L13N_T2_MRCC_34 Sch=HDMI_RX_CLK_N
    --hdmi_rx_clk_p : in    std_logic;                    --IO_L13P_T2_MRCC_34 Sch=HDMI_RX_CLK_P
    --hdmi_rx_d_n   : in    std_logic_vector(2 downto 0); --IO_L16N_T2_34 Sch=HDMI_RX_D0_N
    --hdmi_rx_d_p   : in    std_logic_vector(2 downto 0); --IO_L16P_T2_34 Sch=HDMI_RX_D0_P
    --                                                    --IO_L15N_T2_DQS_34 Sch=HDMI_RX_D1_N
    --                                                    --IO_L15P_T2_DQS_34 Sch=HDMI_RX_D1_P
    --                                                    --IO_L14N_T2_SRCC_34 Sch=HDMI_RX_D2_N
    --                                                    --IO_L14P_T2_SRCC_34 Sch=HDMI_RX_D2_P

    --hdmi_rx_hpd   : out   std_logic; --IO_25_34 Sch=HDMI_RX_HPD
    --hdmi_rx_scl   : inout std_logic; --IO_L11P_T1_SRCC_34 Sch=HDMI_RX_SCL
    --hdmi_rx_sda   : inout std_logic; --IO_L11N_T1_SRCC_34 Sch=HDMI_RX_SDA

    ---- HDMI TX Signals
    --hdmi_tx_cec   : inout std_logic;                    --IO_L19N_T3_VREF_35 Sch=HDMI_TX_CEC
    --hdmi_tx_clk_n : out   std_logic;                    --IO_L11N_T1_SRCC_35 Sch=HDMI_TX_CLK_N
    --hdmi_tx_clk_p : out   std_logic;                    --IO_L11P_T1_SRCC_35 Sch=HDMI_TX_CLK_P
    --hdmi_tx_d_n   : out   std_logic_vector(2 downto 0); --IO_L12N_T1_MRCC_35 Sch=HDMI_TX_D0_N
    --hdmi_tx_d_p   : out   std_logic_vector(2 downto 0); --IO_L12P_T1_MRCC_35 Sch=HDMI_TX_D0_P
    --                                                    --IO_L10N_T1_AD11N_35 Sch=HDMI_TX_D1_N
    --                                                    --IO_L10P_T1_AD11P_35 Sch=HDMI_TX_D1_P
    --                                                    --IO_L14N_T2_AD4N_SRCC_35 Sch=HDMI_TX_D2_N
    --                                                    --IO_L14P_T2_AD4P_SRCC_35 Sch=HDMI_TX_D2_P

    --hdmi_tx_hpdn  : in    std_logic; --IO_0_34 Sch=HDMI_TX_HDPN
    --hdmi_tx_scl   : inout std_logic; --IO_L8P_T1_AD10P_35 Sch=HDMI_TX_SCL
    --hdmi_tx_sda   : inout std_logic; --IO_L8N_T1_AD10N_35 Sch=HDMI_TX_SDA

    -- ChipKit Outer Digital Header
    ck_io_outer : inout std_logic_vector(13 downto 0);
    --ck_io0  : inout std_logic; --IO_L5P_T0_34            Sch=CK_IO0
    --ck_io1  : inout std_logic; --IO_L2N_T0_34            Sch=CK_IO1
    --ck_io2  : inout std_logic; --IO_L3P_T0_DQS_PUDC_B_34 Sch=CK_IO2
    --ck_io3  : inout std_logic; --IO_L3N_T0_DQS_34        Sch=CK_IO3
    --ck_io4  : inout std_logic; --IO_L10P_T1_34           Sch=CK_IO4
    --ck_io5  : inout std_logic; --IO_L5N_T0_34            Sch=CK_IO5
    --ck_io6  : inout std_logic; --IO_L19P_T3_34           Sch=CK_IO6
    --ck_io7  : inout std_logic; --IO_L9N_T1_DQS_34        Sch=CK_IO7
    --ck_io8  : inout std_logic; --IO_L21P_T3_DQS_34       Sch=CK_IO8
    --ck_io9  : inout std_logic; --IO_L21N_T3_DQS_34       Sch=CK_IO9
    --ck_io10 : inout std_logic; --IO_L9P_T1_DQS_34        Sch=CK_IO10
    --ck_io11 : inout std_logic; --IO_L19N_T3_VREF_34      Sch=CK_IO11
    --ck_io12 : inout std_logic; --IO_L23N_T3_34           Sch=CK_IO12
    --ck_io13 : inout std_logic; --IO_L23P_T3_34           Sch=CK_IO13

    -- ChipKit Inner Digital Header
    ck_io_inner : inout std_logic_vector(41 downto 14);
    --ck_io26 : inout std_logic; --IO_L19N_T3_VREF_13  Sch=CK_IO26
    --ck_io27 : inout std_logic; --IO_L6N_T0_VREF_13   Sch=CK_IO27
    --ck_io28 : inout std_logic; --IO_L22P_T3_13       Sch=CK_IO28
    --ck_io29 : inout std_logic; --IO_L11P_T1_SRCC_13  Sch=CK_IO29
    --ck_io30 : inout std_logic; --IO_L11N_T1_SRCC_13  Sch=CK_IO30
    --ck_io31 : inout std_logic; --IO_L17N_T2_13       Sch=CK_IO31
    --ck_io32 : inout std_logic; --IO_L15P_T2_DQS_13   Sch=CK_IO32
    --ck_io33 : inout std_logic; --IO_L21N_T3_DQS_13   Sch=CK_IO33
    --ck_io34 : inout std_logic; --IO_L16P_T2_13       Sch=CK_IO34
    --ck_io35 : inout std_logic; --IO_L22N_T3_13       Sch=CK_IO35
    --ck_io36 : inout std_logic; --IO_L13N_T2_MRCC_13  Sch=CK_IO36
    --ck_io37 : inout std_logic; --IO_L13P_T2_MRCC_13  Sch=cCK_IO37
    --ck_io38 : inout std_logic; --IO_L15N_T2_DQS_13   Sch=CK_IO38
    --ck_io39 : inout std_logic; --IO_L14N_T2_SRCC_13  Sch=CK_IO39
    --ck_io40 : inout std_logic; --IO_L16N_T2_13       Sch=CK_IO40
    --ck_io41 : inout std_logic; --IO_L14P_T2_SRCC_13  Sch=CK_IO41

    -- ChipKit Outer Analog Header - as Single-Ended Analog Inputs
    -- NOTE: These ports can be used as single-ended analog inputs with voltages from 0-3.3V (ChipKit analog pins A0-A5) or as digital I/O.
    -- WARNING: Do not use both sets of constraints at the same time!
    -- NOTE: The following constraints should be used with the XADC IP core when using these ports as analog inputs.
    -- vaux1_n  : in std_logic; --IO_L3N_T0_DQS_AD1N_35 Sch=CK_AN0_N   ChipKit pin=A0
    -- vaux1_p  : in std_logic; --IO_L3P_T0_DQS_AD1P_35 Sch=CK_AN0_P   ChipKit pin=A0
    -- vaux9_n  : in std_logic; --IO_L5N_T0_AD9N_35     Sch=CK_AN1_N   ChipKit pin=A1
    -- vaux9_p  : in std_logic; --IO_L5P_T0_AD9P_35     Sch=CK_AN1_P   ChipKit pin=A1
    -- vaux6_n  : in std_logic; --IO_L20N_T3_AD6N_35    Sch=CK_AN2_N   ChipKit pin=A2
    -- vaux6_p  : in std_logic; --IO_L20P_T3_AD6P_35    Sch=CK_AN2_P   ChipKit pin=A2
    -- vaux15_n : in std_logic; --IO_L24N_T3_AD15N_35   Sch=CK_AN3_N   ChipKit pin=A3
    -- vaux15_p : in std_logic; --IO_L24P_T3_AD15P_35   Sch=CK_AN3_P   ChipKit pin=A3
    -- vaux5_n  : in std_logic; --IO_L17N_T2_AD5N_35    Sch=CK_AN4_N   ChipKit pin=A4
    -- vaux5_p  : in std_logic; --IO_L17P_T2_AD5P_35    Sch=CK_AN4_P   ChipKit pin=A4
    -- vaux13_n : in std_logic; --IO_L18N_T2_AD13N_35   Sch=CK_AN5_N   ChipKit pin=A5
    -- vaux13_p : in std_logic; --IO_L18P_T2_AD13P_35   Sch=CK_AN5_P   ChipKit pin=A5
    -- ChipKit Outer Analog Header - as Digital I/O
    -- NOTE: The following constraints should be used when using these ports as digital I/O.
    --ck_a_outer : inout std_logic_vector(5 downto 0);
    --ck_a0 : inout std_logic; --IO_L18N_T2_13      Sch=CK_A0
    --ck_a1 : inout std_logic; --IO_L20P_T3_13      Sch=CK_A1
    --ck_a2 : inout std_logic; --IO_L18P_T2_13      Sch=CK_A2
    --ck_a3 : inout std_logic; --IO_L21P_T3_DQS_13  Sch=CK_A3
    --ck_a4 : inout std_logic; --IO_L19P_T3_13      Sch=CK_A4
    --ck_a5 : inout std_logic; --IO_L12N_T1_MRCC_13 Sch=CK_A5

    -- ChipKit Inner Analog Header - as Differential Analog Inputs
    -- NOTE: These ports can be used as differential analog inputs with voltages from 0-1.0V (ChipKit analog pins A6-A11) or as digital I/O.
    -- WARNING: Do not use both sets of constraints at the same time!
    -- NOTE: The following constraints should be used with the XADC core when using these ports as analog inputs.
    -- Uncomment below if using as analog inputs
    -- vaux12_p : in std_logic; --IO_L15P_T2_DQS_AD12P_35 Sch=AD12_P   ChipKit pin=A6
    -- vaux12_n : in std_logic; --IO_L15N_T2_DQS_AD12N_35 Sch=AD12_N   ChipKit pin=A7
    -- vaux0_p  : in std_logic; --IO_L1P_T0_AD0P_35       Sch=AD0_P    ChipKit pin=A8
    -- vaux0_n  : in std_logic; --IO_L1N_T0_AD0N_35       Sch=AD0_N    ChipKit pin=A9
    -- vaux8_p  : in std_logic; --IO_L2P_T0_AD8P_35       Sch=AD8_P    ChipKit pin=A10
    -- vaux8_n  : in std_logic; --IO_L2N_T0_AD8N_35       Sch=AD8_N    ChipKit pin=A11
    -- ChipKit Inner Analog Header - as Digital I/O
    -- NOTE: The following constraints should be used when using the inner analog header ports as digital I/O.
    -- Comment below if using as digital I/O.
    --ck_a_inner : inout std_logic_vector(11 downto 6);
    --ck_a6  : inout std_logic; --IO_L15P_T2_DQS_AD12P_35 Sch=AD12_P
    --ck_a7  : inout std_logic; --IO_L15N_T2_DQS_AD12N_35 Sch=AD12_N
    --ck_a8  : inout std_logic; --IO_L1P_T0_AD0P_35       Sch=AD0_P
    --ck_a9  : inout std_logic; --IO_L1N_T0_AD0N_35       Sch=AD0_N
    --ck_a10 : inout std_logic; --IO_L2P_T0_AD8P_35       Sch=AD8_P
    --ck_a11 : inout std_logic; --IO_L2N_T0_AD8N_35       Sch=AD8_N

    ---- ChipKit SPI
    ---- NOTE: The ChipKit SPI header ports can also be used as digital I/O
    --ck_miso : in  std_logic; --IO_L10N_T1_34 Sch=CK_MISO
    --ck_mosi : out std_logic; --IO_L2P_T0_34 Sch=CK_MISO
    --ck_sck  : out std_logic; --IO_L19P_T3_35 Sch=CK_SCK
    --ck_ss   : out std_logic; --IO_L6P_T0_35 Sch=CK_SS

    ---- ChipKit I2C
    --ck_scl : out   std_logic; --IO_L24N_T3_34 Sch=CK_SCL
    --ck_sda : inout std_logic; --IO_L24P_T3_34 Sch=CK_SDA

    -- Misc. ChipKit Ports
    -- Disconnect if analog input on ck_a1
    ck_ioa : inout std_logic --IO_L20N_T3_13 Sch=CK_IOA
  );
end arty_z7_wrapper;

architecture hdl_wrapper of arty_z7_wrapper is
  -- TODO: Add HI-Z signalling
  signal ck_i    : std_logic_vector(41 downto 0) := (others => '0');
  signal ck_o    : std_logic_vector(41 downto 0) := (others => '0');
  signal ck_en   : std_logic_vector(41 downto 0) := (others => '0');
  -- signal ck_a_in  : std_logic_vector(11 downto 0) := (others => '0');
  -- signal ck_a_out : std_logic_vector(11 downto 0) := (others => '0');
  signal rgb      : rgb_array_t(4 to 5) := (others => cDEFAULT_RGB);
begin

  Gen_ck_io_outer: for I in ck_io_outer'range generate begin
    IOBUF_io_outer_inst : IOBUF
    generic map (
      DRIVE      => 12,
      IOSTANDARD => "DEFAULT",
      SLEW       => "SLOW"
    )
    port map (
      O  => ck_o(I),        -- Buffer output
      IO => ck_io_outer(I), -- Buffer inout port (connect directly to top-level port)
      I  => ck_i(I),        -- Buffer input
      T  => ck_en(I)        -- 3-state enable input, high=input, low=output
    );
  end generate Gen_ck_io_outer;

  Gen_ck_io_outer: for I in ck_io_inner'range generate begin
    IOBUF_io_outer_inst : IOBUF
    generic map (
      DRIVE      => 12,
      IOSTANDARD => "DEFAULT",
      SLEW       => "SLOW"
    )
    port map (
      O  => ck_o(I),        -- Buffer output
      IO => ck_io_inner(I), -- Buffer inout port (connect directly to top-level port)
      I  => ck_i(I),        -- Buffer input
      T  => ck_en(I)        -- 3-state enable input, high=input, low=output
    );
  end generate Gen_ck_io_outer;

  Inst_Main: entity system.project_main_arty_z7
  Port Map (
    CLOCK_IN      => clk,
    PUSHBUTTON_IN => btn,
    DIPSWITCH_IN  => sw,
    CK_IN         => ck_i,
    CK_OUT        => ck_o,
    CK_EN         => ck_en,
    LED_OUT       => led,
    RGB_OUT       => rgb
  );

  led4_r <= rgb(4).red;
  led4_g <= rgb(4).green;
  led4_b <= rgb(4).blue;

  led5_r <= rgb(5).red;
  led5_g <= rgb(5).green;
  led5_b <= rgb(5).blue;


end hdl_wrapper;