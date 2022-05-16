defmodule Atomix.Esp32.Core.IOMux do
  @input_index [0..18, 23..36, 39..58, 61..90, 95..124, 140..155, 164..181, 190..195, 198..206]

  @doc """
    ESP32 has 71 peripheral interrupt sources in total. All peripheral interrupt sources are listed in table 7. 67 of 71
    ESP32 peripheral interrupt sources can be allocated to either CPU.
    The four remaining peripheral interrupt sources are CPU-specific, two per CPU. GPIO_INTERRUPT_PRO and
    GPIO_INTERRUPT_PRO_NMI can only be allocated to PRO_CPU. GPIO_INTERRUPT_APP and GPIO_INTERRUPT
    _APP_NMI can only be allocated to APP_CPU. As a result, PRO_CPU and APP_CPU each have 69 peripheral interrupt sources.
  """
  def interrupt_sources() do
  end

  def peripheral_interrupt_configuration_register() do
    %{
      picr: [
        {0x00, :DPORT_PRO_MAC_INTR_MAP_REG},
        {0x01, :DPORT_PRO_MAC_NMI_MAP_REG},
        {0x02, :DPORT_PRO_BB_INT_MAP_REG},
        {0x03, :DPORT_PRO_BT_BB_MAP_REG},
        {0x04, :DPORT_PRO_BT_BB_INT_MAP_REG},
        {0x05, :DPORT_PRO_BT_BB_NMI_MAP_REG},
        {0x06, :DPORT_PRO_RWBT_IRQ_MAP_REG},
        {0x07, :DPORT_PRO_RWBLE_IRQ_MAP_REG},
        {0x08, :DPORT_PRO_RWBT_NMI_MAP_REG},
        {0x09, :DPORT_PRO_RWBLE_NMI_MAP_REG},
        # 10
        {0x0A, :DPORT_PRO_SLC0_INTR_MAP_REG},
        # 11
        {0x0B, :DPORT_PRO_SLC1_INTR_MAP_REG},
        # 12
        {0x0C, :DPORT_PRO_UHCIO_INTR_MAP_REG},
        # 13
        {0x0D, :DPORT_PRO_UHCI1_INTR_MAP_REG},
        # 14
        {0x0E, :DPORT_PRO_TG_T0_LEVEL_INT_MAP_REG},
        # 15
        {0x0F, :DPORT_PRO_TG_T1_LEVEL_INT_MAP_REG},
        # 16
        {0x10, :DPORT_PRO_TG_WDT_LEVEL_INT_MAP_REG},
        # 17
        {0x11, :DPORT_PRO_TG_LACT_LEVEL_INT_MAP_REG},
        # 18
        {0x12, :DPORT_PRO_TG1_T0_LEVEL_INT_MAP_REG},
        # 19
        {0x13, :DPORT_PRO_TG1_T1_LEVEL_INT_MAP_REG},
        # 20
        {0x14, :DPORT_PRO_TG1_WDT_LEVEL_INT_MAP_REG},
        # 21
        {0x15, :DPORT_PRO_TG1_LACT_LEVEL_INT_MAP_REG},
        # 22
        {0x16, :DPORT_PRO_GPIO_INTERRUPT_MAP_REG},
        # 23
        {0x17, :DPORT_PRO_GPIO_NMI_MAP_REG},
        # 24
        {0x18, :DPORT_PRO_CPU_INTR_FROM_CPU0_MAP_REG},
        # 25
        {0x19, :DPORT_PRO_CPU_INTR_FROM_CPU1_MAP_REG},
        # 26
        {0x20, :DPORT_PRO_CPU_INTR_FROM_CPU2_MAP_REG},
        # 27
        {0x21, :DPORT_PRO_CPU_INTR_FROM_CPU3_MAP_REG},
        # 28
        {0x22, :DPORT_PRO_SPI_INTR_0_MAP_REG},
        # 29
        {0x23, :DPORT_PRO_SPI_INTR_1_MAP_REG},
        # 30
        {0x24, :DPORT_PRO_SPI_INTR_2_MAP_REG},
        # 31
        {0x25, :DPORT_PRO_SPI_INTR_3_MAP_REG}
      ]
    }
  end

  def peripheral_input_source() do
    %{
      pi_source: [
        {0x00, :MAC_INTR},
        {0x01, :MAC_NMI},
        {0x02, :BB_INT},
        {0x03, :BT_MAC_INT},
        {0x04, :BT_BB_INT},
        {0x05, :BT_BB_NMI},
        {0x06, :RWBT_IRQ},
        {0x07, :RWBLE_IRQ},
        {0x08, :RWBT_NMI},
        {0x09, :RWBLE_NMI},
        # 10
        {0x0A, :SLC0_INTR},
        # 11
        {0x0B, :SLC1_INTR},
        # 12
        {0x0C, :UHCI0_INTR},
        # 13
        {0x0D, :UHCI1_INTR},
        # 14
        {0x0E, :TG_T0_LEVEL_INT},
        # 15
        {0x0F, :TG_T1_LEVEL_INT},
        # 16
        {0x10, :TG_WDT_LEVEL_INT},
        # 17
        {0x11, :TG_LACT_LEVEL_INT},
        # 18
        {0x12, :TG1_T0_LEVEL_INT},
        # 19
        {0x13, :TG1_T1_LEVEL_INT},
        # 20
        {0x14, :TG1_WDT_LEVEL_INT},
        # 21
        {0x15, :TG1_LACT_LEVEL_INT},
        # 22
        {0x16, {:GPIO_INTERRUPT_PRO, :GPIO_INTERRUPT_APP}},
        # 23
        {0x17, {:GPIO_INTERRUPT_NMI, :GPIO_INTERRUPT_APP_NMI}},
        # 24
        {0x18, :CPU_INTR_FROM_CPU_0},
        # 25
        {0x19, :CPU_INTR_FROM_CPU_1},
        # 26
        {0x20, :CPU_INTR_FROM_CPU_2},
        # 27
        {0x21, :CPU_INTR_FROM_CPU_3},
        # 28
        {0x22, :SPI_INTR_0},
        # 29
        {0x23, :SPI_INTR_1},
        # 30
        {0x24, :SPI_INTR_2},
        # 31
        {0x25, :SPI_INTR_3}
      ]
    }
  end
end
