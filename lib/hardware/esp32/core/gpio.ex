defmodule Atomix.Esp32.Core.GPIO do
  @gpio [0..19, 21..23, 25..27, 32..39]

  def matrix_peripheral_signals() do
    [
      %{signal: 0, input_signal: :SPCLK_in, output_signal: :SPCLK_out, direct_io: :yes},
      %{signal: 1, input_signal: :SPIQ_in, output_signal: :SPIQ_out, direct_io: :yes},
      %{signal: 2, input_signal: :SPID_in, output_signal: :SPID_out, direct_io: :yes},
      %{signal: 3, input_signal: :SPIHD_in, output_signal: :SPIHD_out, direct_io: :yes},
      %{signal: 4, input_signal: :SPIWP_in, output_signal: :SPIWP_out, direct_io: :yes},
      %{signal: 5, input_signal: :SPIICS0_in, output_signal: :SPIDCS0_out, direct_io: :yes},
      %{signal: 6, input_signal: :SPICS1_in, output_signal: :SPICS1_out, direct_io: :na},
      %{signal: 7, input_signal: :SPICS2_in, output_signal: :SPICS2_out, direct_io: :na},
      %{signal: 8, input_signal: :HSCPICLK_in, output_signal: :HPICLK_out, direct_io: :yes},
      %{signal: 9, input_signal: :HSCPIQ_in, output_signal: :HSPIQ_out, direct_io: :yes},
      %{signal: 10, input_signal: :HSPID_in, output_signal: :HPID_out, direct_io: :yes},
      %{signal: 11, input_signal: :HSPICS0_in, output_signal: :HSPICS0_out, direct_io: :yes},
      %{signal: 12, input_signal: :HSPIHD_in, output_signal: :HSPIHD_out, direct_io: :yes},
      %{signal: 13, input_signal: :HSPIWP_in, output_signal: :HSPIWP_out, direct_io: :yes},
      %{signal: 14, input_signal: :U0RXD_in, output_signal: :U0RXD_out, direct_io: :yes},
      %{signal: 15, input_signal: :U0CTS_in, output_signal: :U0RTS_out, direct_io: :yes},
      %{signal: 16, input_signal: :U0DSR_in, output_signal: :U0DTR_out, direct_io: :na},
      %{signal: 17, input_signal: :U1RXD_in, output_signal: :U1TXD_out, direct_io: :yes},
      %{signal: 18, input_signal: :U1CTS_in, output_signal: :UIRTS_out, direct_io: :yes},
      %{signal: 23, input_signal: :I2S0O_BCK_in, output_signal: :I2S0O_out, direct_io: :na},
      %{signal: 24, input_signal: :I2S1O_BCK_in, output_signal: :I2S10_BCK_out, direct_io: :na},
      %{signal: 25, input_signal: :I2S0O_WS_in, output_signal: :I2S0O_out, direct_io: :na},
      %{signal: 26, input_signal: :I2S10_WS_in, output_signal: :I2S10_WS_out, direct_io: :na},
      %{signal: 27, input_signal: :I2S01_BCK, output_signal: :I2S01_BCK_out, direct_io: :na},
      %{signal: 28, input_signal: :I2S01_WS_in, output_signal: :I2S01_WS_out, direct_io: :na},
      %{
        signal: 29,
        input_signal: :I2CEXT0_SCL_in,
        output_signal: :I2CEXT0_SCL_out,
        direct_io: :na
      },
      %{
        signal: 30,
        input_signal: :I2CEXT0_SDA_in,
        output_signal: :I2CEXT0_SDA_out,
        direct_io: :na
      },
      %{
        signal: 31,
        input_signal: :pwm0_sync0_in,
        output_signal: :sdio_tohost_int_out,
        direct_io: :na
      },
      %{signal: 32, input_signal: :pwm0_sync1_in, output_signal: :pwm0_out0a, direct_io: :na},
      %{signal: 33, input_signal: :pwm0_sync2_in, output_signal: :pwm0_out0b, direct_io: :na},
      %{signal: 34, input_signal: :pwm0_f0_in, output_signal: :pwm0_out1a, direct_io: :na},
      %{signal: 35, input_signal: :pwm0_f1_in, output_signal: :pwm0_out1b, direct_io: :na},
      %{signal: 36, input_signal: :pwm0_f2_in, output_signal: :pwm0_out2a, direct_io: :na},
      %{signal: 37, input_signal: :na, output_signal: :pwm0_out2b, direct_io: :na},
      %{signal: 39, input_signal: :pcnt_sig_ch0_in0, output_signal: :na, direct_io: :na},
      %{signal: 40, input_signal: :pcnt_sig_ch1_in0, output_signal: :na, direct_io: :na},
      %{signal: 41, input_signal: :pcnt_ctrl_ch0_in0, output_signal: :na, direct_io: :na},
      %{signal: 42, input_signal: :pcnt_ctrl_ch1_in0, output_signal: :na, direct_io: :na},
      %{signal: 43, input_signal: :pcnt_sig_ch0_in1, output_signal: :na, direct_io: :na},
      %{signal: 44, input_signal: :pcnt_sig_ch1_in1, output_signal: :na, direct_io: :na},
      %{signal: 45, input_signal: :pcnt_ctrl_ch0_in1, output_signal: :na, direct_io: :na},
      %{signal: 46, input_signal: :pcnt_ctrl_ch1_in1, output_signal: :na, direct_io: :na},
      %{signal: 47, input_signal: :pcnt_sig_ch0_in2, output_signal: :na, direct_io: :na},
      %{signal: 48, input_signal: :pcnt_sig_ch1_in2, output_signal: :na, direct_io: :na},
      %{signal: 49, input_signal: :pcnt_ctrl_ch0_in2, output_signal: :na, direct_io: :na},
      %{signal: 50, input_signal: :pcnt_ctrl_ch1_in2, output_signal: :na, direct_io: :na},
      %{signal: 51, input_signal: :pcnt_sig_ch0_in3, output_signal: :na, direct_io: :na},
      %{signal: 52, input_signal: :pcnt_sig_ch1_in3, output_signal: :na, direct_io: :na},
      %{signal: 53, input_signal: :pcnt_ctrl_ch0_in3, output_signal: :na, direct_io: :na},
      %{signal: 54, input_signal: :pcnt_ctrl_ch1_in3, output_signal: :na, direct_io: :na},
      %{signal: 55, input_signal: :pcnt_sig_ch0_in4, output_signal: :na, direct_io: :na},
      %{signal: 56, input_signal: :pcnt_sig_ch1_in4, output_signal: :na, direct_io: :na},
      %{signal: 57, input_signal: :pcnt_ctrl_ch0_in4, output_signal: :na, direct_io: :na},
      %{signal: 58, input_signal: :pcnt_ctrl_ch1_in4, output_signal: :na, direct_io: :na},
      %{signal: 61, input_signal: :HSPICS1_in, output_signal: :HSPICS1_out, direct_io: :na},
      %{signal: 62, input_signal: :HSPICS2_in, output_signal: :HSPICS2_out, direct_io: :na},
      %{signal: 63, input_signal: :VSPICLK_in, output_signal: :VSPICLK_out_mux, direct_io: :na},
      %{signal: 64, input_signal: :VSPIQ_in, output_signal: :VSPIQ_out, direct_io: :na},
      %{signal: 65, input_signal: :VSPID_in, output_signal: :VSPID_out, direct_io: :na},
      %{signal: 66, input_signal: :VSPIHD_in, output_signal: :VSPIHD_out, direct_io: :na},
      %{signal: 67, input_signal: :VSPIWP_in, output_signal: :VSPIWP_out, direct_io: :na},
      %{signal: 68, input_signal: :VSPICS0_in, output_signal: :VSPICS0_out, direct_io: :na},
      %{signal: 69, input_signal: :VSPICS1_in, output_signal: :VSPICS1_out, direct_io: :na},
      %{signal: 70, input_signal: :VSPICS2_in, output_signal: :VSPICS2_out, direct_io: :na},
      %{
        signal: 71,
        input_signal: :pcnt_sig_ch0_in5,
        output_signal: :ledc_hs_sig_out0,
        direct_io: :na
      },
      %{
        signal: 72,
        input_signal: :pcnt_sig_ch1_in5,
        output_signal: :ledc_hs_sig_out1,
        direct_io: :na
      },
      %{
        signal: 73,
        input_signal: :pcnt_ctrl_ch0_in5,
        output_signal: :ledc_hs_sig_out2,
        direct_io: :na
      },
      %{
        signal: 74,
        input_signal: :pcnt_ctrl_ch1_in5,
        output_signal: :ledc_hs_sig_out0,
        direct_io: :na
      },
      %{
        signal: 75,
        input_signal: :pcnt_sig_ch0_in6,
        output_signal: :ledc_hs_sig_out4,
        direct_io: :na
      },
      %{
        signal: 76,
        input_signal: :pcnt_sig_ch1_in6,
        output_signal: :ledc_hs_sig_out3,
        direct_io: :na
      },
      %{
        signal: 77,
        input_signal: :pcnt_ctrl_ch0_in6,
        output_signal: :ledc_hs_sig_out6,
        direct_io: :na
      },
      %{
        signal: 78,
        input_signal: :pcnt_ctrl_ch1_in6,
        output_signal: :ledc_hs_sig_out7,
        direct_io: :na
      },
      %{
        signal: 79,
        input_signal: :pcnt_sig_ch0_in7,
        output_signal: :ledc_ls_sig_out0,
        direct_io: :na
      },
      %{
        signal: 80,
        input_signal: :pcnt_sig_ch1_in7,
        output_signal: :ledc_ls_sig_out1,
        direct_io: :na
      },
      %{
        signal: 81,
        input_signal: :pcnt_ctrl_ch0_in7,
        output_signal: :ledc_ls_sig_out2,
        direct_io: :na
      },
      %{
        signal: 82,
        input_signal: :pcnt_ctrl_ch1_in7,
        output_signal: :ledc_ls_sig_out3,
        direct_io: :na
      },
      %{
        signal: 83,
        input_signal: :rmt_sig_in0,
        output_signal: :ledc_ls_sig_out4,
        direct_io: :na
      },
      %{
        signal: 84,
        input_signal: :rmt_sig_in1,
        output_signal: :ledc_ls_sig_out5,
        direct_io: :na
      },
      %{
        signal: 85,
        input_signal: :rmt_sig_in2,
        output_signal: :ledc_ls_sig_out6,
        direct_io: :na
      },
      %{
        signal: 86,
        input_signal: :rmt_sig_in3,
        output_signal: :ledc_ls_sig_out7,
        direct_io: :na
      },
      %{
        signal: 87,
        input_signal: :rmt_sig_in4,
        output_signal: :rmt_sig_out0,
        direct_io: :na
      },
      %{
        signal: 88,
        input_signal: :rmt_sig_in5,
        output_signal: :rmt_sig_out1,
        direct_io: :na
      },
      %{
        signal: 89,
        input_signal: :rmt_sig_in6,
        output_signal: :rmt_sig_out2,
        direct_io: :na
      },
      %{
        signal: 90,
        input_signal: :rmt_sig_in7,
        output_signal: :rmt_sig_out3,
        direct_io: :na
      },
      %{
        signal: 91,
        input_signal: :na,
        output_signal: :rmt_sig_out4,
        direct_io: :na
      },
      %{
        signal: 92,
        input_signal: :na,
        output_signal: :rmt_sig_out5,
        direct_io: :na
      },
      %{
        signal: 93,
        input_signal: :rmt_sig_in5,
        output_signal: :rmt_sig_out6,
        direct_io: :na
      },
      %{
        signal: 94,
        input_signal: :na,
        output_signal: :rmt_sig_out7,
        direct_io: :na
      },
      %{
        signal: 95,
        input_signal: :I2CEXT1_SCL_in,
        output_signal: :I2CEXT1_SCL_out,
        direct_io: :na
      },
      %{
        signal: 96,
        input_signal: :I2CEXT1_SDA_in,
        output_signal: :I2CEXT1_SDA_out,
        direct_io: :na
      },
      %{
        signal: 97,
        input_signal: :host_card_detect_n_1,
        output_signal: :host_ccmd_od_pullup_en_n,
        direct_io: :na
      },
      %{
        signal: 98,
        input_signal: :host_card_detect_n_2,
        output_signal: :host_rst_n_1,
        direct_io: :na
      },
      %{
        signal: 99,
        input_signal: :host_card_write_prt_1,
        output_signal: :host_rst_n_2,
        direct_io: :na
      },
      %{
        signal: 100,
        input_signal: :host_card_write_prt_2,
        output_signal: :gpio_sd0_out,
        direct_io: :na
      },
      %{
        signal: 101,
        input_signal: :host_card_int_n_1,
        output_signal: :gpio_sd1_out,
        direct_io: :na
      },
      %{
        signal: 102,
        input_signal: :host_card_int_n_2,
        output_signal: :gpio_sd2_out,
        direct_io: :na
      },
      %{
        signal: 103,
        input_signal: :pwm1_sync0_in,
        output_signal: :gpio_sd3_out,
        direct_io: :na
      },
      %{
        signal: 104,
        input_signal: :pwm1_sync1_in,
        output_signal: :gpio_sd4_out,
        direct_io: :na
      },
      %{
        signal: 105,
        input_signal: :pwm1_sync2_in,
        output_signal: :gpio_sd5_out,
        direct_io: :na
      },
      %{
        signal: 106,
        input_signal: :pwm1_f0_in,
        output_signal: :gpio_sd6_out,
        direct_io: :na
      },
      %{
        signal: 107,
        input_signal: :pwm1_f1_in,
        output_signal: :gpio_sd7_out,
        direct_io: :na
      },
      %{
        signal: 108,
        input_signal: :pwm1_f2_in,
        output_signal: :pwm1_out0a,
        direct_io: :na
      },
      %{
        signal: 109,
        input_signal: :pwm0_cap0_in,
        output_signal: :pwm1_out0b,
        direct_io: :na
      },
      %{
        signal: 110,
        input_signal: :pwm0_cap1_in,
        output_signal: :pwm1_out1a,
        direct_io: :na
      },
      %{
        signal: 111,
        input_signal: :pwm0_cap2_in,
        output_signal: :pwm1_out1b,
        direct_io: :na
      },
      %{
        signal: 112,
        input_signal: :pwm1_cap0_in,
        output_signal: :pwm1_out2a,
        direct_io: :na
      },
      %{
        signal: 113,
        input_signal: :pwm1_cap1_in,
        output_signal: :pwm1_out2b,
        direct_io: :na
      },
      %{
        signal: 114,
        input_signal: :pwm1_cap2_in,
        output_signal: :na,
        direct_io: :na
      },
      %{
        signal: 115,
        input_signal: :na,
        output_signal: :na,
        direct_io: :na
      },
      %{
        signal: 116,
        input_signal: :na,
        output_signal: :na,
        direct_io: :na
      },
      %{
        signal: 117,
        input_signal: :na,
        output_signal: :na,
        direct_io: :na
      },
      %{
        signal: 118,
        input_signal: :na,
        output_signal: :na,
        direct_io: :na
      },
      %{
        signal: 119,
        input_signal: :na,
        output_signal: :na,
        direct_io: :na
      },
      %{
        signal: 120,
        input_signal: :na,
        output_signal: :na,
        direct_io: :na
      },
      %{
        signal: 121,
        input_signal: :na,
        output_signal: :na,
        direct_io: :na
      },
      %{
        signal: 122,
        input_signal: :na,
        output_signal: :na,
        direct_io: :na
      },
      %{
        signal: 123,
        input_signal: :na,
        output_signal: :na,
        direct_io: :na
      },
      %{
        signal: 124,
        input_signal: :na,
        output_signal: :na,
        direct_io: :na
      }
    ]
  end
end
