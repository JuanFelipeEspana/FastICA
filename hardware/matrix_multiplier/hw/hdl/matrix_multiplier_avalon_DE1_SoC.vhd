-- #############################################################################
-- DE1_SoC_top_level.vhd
--
-- BOARD         		: DE1-SoC from Terasic
-- Author        		: Sahand Kashani-Akhavan from Terasic documentation
-- Modified				: Eduardo Gerlein				
-- Revision      		: 1.0
-- Creation date 		: 2015-04-02
-- Modofication Date	: 2021-04-02
--
-- Syntax Rule : GROUP_NAME_N[bit]
--
-- GROUP  : specify a particular INterface (ex: SDR_)
-- NAME   : signal name (ex: CONFIG, D, ...)
-- bit    : signal index
-- _N     : to specify an active-low signal
-- #############################################################################

LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;

ENTITY matrix_multiplier_avalon_DE1_SoC IS
    PORT(
        -- ADC
     -- ADC_CS_n         : OUT   STD_LOGIC;
     -- ADC_DIN          : OUT   STD_LOGIC;
     -- ADC_DOUT         : IN    STD_LOGIC;
     -- ADC_SCLK         : OUT   STD_LOGIC;

        -- Audio
     -- AUD_ADCDAT       : IN    STD_LOGIC;
     -- AUD_ADCLRCK      : INOUT STD_LOGIC;
     -- AUD_BCLK         : INOUT STD_LOGIC;
     -- AUD_DACDAT       : OUT   STD_LOGIC;
     -- AUD_DACLRCK      : INOUT STD_LOGIC;
     -- AUD_XCK          : OUT   STD_LOGIC;

        -- CLOCK
        CLOCK_50 : IN STD_LOGIC;
     -- CLOCK2_50        : IN    STD_LOGIC;
     -- CLOCK3_50        : IN    STD_LOGIC;
     -- CLOCK4_50        : IN    STD_LOGIC;

        -- SDRAM
        DRAM_ADDR  		: OUT   STD_LOGIC_VECTOR(12 DOWNTO 0);
        DRAM_BA    		: OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
        DRAM_CAS_N 		: OUT   STD_LOGIC;
        DRAM_CKE   		: OUT   STD_LOGIC;
        DRAM_CLK  		: OUT   STD_LOGIC;
        DRAM_CS_N  		: OUT   STD_LOGIC;
        DRAM_DQ   		: INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        DRAM_LDQM  		: OUT   STD_LOGIC;
        DRAM_RAS_N 		: OUT   STD_LOGIC;
        DRAM_UDQM  		: OUT   STD_LOGIC;
        DRAM_WE_N  		: OUT   STD_LOGIC;

        -- I2C for Audio and Video-IN
     -- FPGA_I2C_SCLK	: OUT   STD_LOGIC;
     -- FPGA_I2C_SDAT	: INOUT STD_LOGIC;

        -- SEG7
		  --HEX0_N           : OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);
        --HEX1_N           : OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);
        --HEX2_N           : OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);
        --HEX3_N           : OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);
        --HEX4_N           : OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);
        --HEX5_N           : OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);

        -- IR
     -- IRDA_RXD         : IN    STD_LOGIC;
     -- IRDA_TXD         : OUT   STD_LOGIC;

        -- KEY_N
        --KEY_N 				: IN STD_LOGIC_VECTOR(3 DOWNTO 0);

        -- LED
        --LEDR 				: OUT STD_LOGIC_VECTOR(9 DOWNTO 0);

        -- PS2
     -- PS2_CLK          : INOUT STD_LOGIC;
     -- PS2_CLK2         : INOUT STD_LOGIC;
     -- PS2_DAT          : INOUT STD_LOGIC;
     -- PS2_DAT2         : INOUT STD_LOGIC;

        -- SW
        --SW 					: IN STD_LOGIC_VECTOR(9 DOWNTO 0);

        -- Video-IN
     -- TD_CLK27         : INOUT STD_LOGIC;
     -- TD_DATA          : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
     -- TD_HS            : OUT   STD_LOGIC;
     -- TD_RESET_N       : OUT   STD_LOGIC;
     -- TD_VS            : OUT   STD_LOGIC;

        -- VGA
     -- VGA_B            : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
     -- VGA_BLANK_N      : OUT   STD_LOGIC;
     -- VGA_CLK          : OUT   STD_LOGIC;
     -- VGA_G            : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
     -- VGA_HS           : OUT   STD_LOGIC;
     -- VGA_R            : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
     -- VGA_SYNC_N       : OUT   STD_LOGIC;
     -- VGA_VS           : OUT   STD_LOGIC;

        -- GPIO_0
     -- GPIO_0           : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);

        -- GPIO_1
     -- GPIO_1           : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);

        -- HPS
        HPS_CONV_USB_N   : INOUT STD_LOGIC;
        HPS_DDR3_ADDR    : OUT   STD_LOGIC_VECTOR(14 DOWNTO 0);
        HPS_DDR3_BA      : OUT   STD_LOGIC_VECTOR(2 DOWNTO 0);
        HPS_DDR3_CAS_N   : OUT   STD_LOGIC;
        HPS_DDR3_CK_N    : OUT   STD_LOGIC;
        HPS_DDR3_CK_P    : OUT   STD_LOGIC;
        HPS_DDR3_CKE     : OUT   STD_LOGIC;
        HPS_DDR3_CS_N    : OUT   STD_LOGIC;
        HPS_DDR3_DM      : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
        HPS_DDR3_DQ      : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        HPS_DDR3_DQS_N   : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        HPS_DDR3_DQS_P   : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        HPS_DDR3_ODT     : OUT   STD_LOGIC;
        HPS_DDR3_RAS_N   : OUT   STD_LOGIC;
        HPS_DDR3_RESET_N : OUT   STD_LOGIC;
        HPS_DDR3_RZQ     : IN    STD_LOGIC;
        HPS_DDR3_WE_N    : OUT   STD_LOGIC;
        HPS_ENET_GTX_CLK : OUT   STD_LOGIC;
        HPS_ENET_INT_N   : INOUT STD_LOGIC;
        HPS_ENET_MDC     : OUT   STD_LOGIC;
        HPS_ENET_MDIO    : INOUT STD_LOGIC;
        HPS_ENET_RX_CLK  : IN    STD_LOGIC;
        HPS_ENET_RX_DATA : IN    STD_LOGIC_VECTOR(3 DOWNTO 0);
        HPS_ENET_RX_DV   : IN    STD_LOGIC;
        HPS_ENET_TX_DATA : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
        HPS_ENET_TX_EN   : OUT   STD_LOGIC;
        HPS_FLASH_DATA   : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        HPS_FLASH_DCLK   : OUT   STD_LOGIC;
        HPS_FLASH_NCSO   : OUT   STD_LOGIC;
        HPS_GSENSOR_INT  : INOUT STD_LOGIC;
        HPS_I2C_CONTROL  : INOUT STD_LOGIC;
        HPS_I2C1_SCLK    : INOUT STD_LOGIC;
        HPS_I2C1_SDAT    : INOUT STD_LOGIC;
        HPS_I2C2_SCLK    : INOUT STD_LOGIC;
        HPS_I2C2_SDAT    : INOUT STD_LOGIC;
        --HPS_KEY_N        : INOUT STD_LOGIC;
        --HPS_LED          : INOUT STD_LOGIC;
        HPS_LTC_GPIO     : INOUT STD_LOGIC;
        HPS_SD_CLK       : OUT   STD_LOGIC;
        HPS_SD_CMD       : INOUT STD_LOGIC;
        HPS_SD_DATA      : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        HPS_SPIM_CLK     : OUT   STD_LOGIC;
        HPS_SPIM_MISO    : IN    STD_LOGIC;
        HPS_SPIM_MOSI    : OUT   STD_LOGIC;
        HPS_SPIM_SS      : INOUT STD_LOGIC;
        HPS_UART_RX      : IN    STD_LOGIC;
        HPS_UART_TX      : OUT   STD_LOGIC;
        HPS_USB_CLKOUT   : IN    STD_LOGIC;
        HPS_USB_DATA     : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        HPS_USB_DIR      : IN    STD_LOGIC;
        HPS_USB_NXT      : IN    STD_LOGIC;
        HPS_USB_STP      : OUT   STD_LOGIC
    );
END ENTITY matrix_multiplier_avalon_DE1_SoC;

ARCHITECTURE rtl OF matrix_multiplier_avalon_DE1_SoC IS
    	COMPONENT soc_system IS
		PORT (
			--buttons_0_external_connection_export  : IN    STD_LOGIC_VECTOR(3 DOWNTO 0)  := (OTHERS => 'X'); -- export
			clk_clk                               : IN    STD_LOGIC                     := 'X';             -- clk
			--hex_0_external_connection_export      : OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);                     -- export
			--hex_1_external_connection_export      : OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);                     -- export
			--hex_2_external_connection_export      : OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);                     -- export
			--hex_3_external_connection_export      : OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);                     -- export
			--hex_4_external_connection_export      : OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);                     -- export
			--hex_5_external_connection_export      : OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);                     -- export
			hps_0_ddr_mem_a                       : OUT   STD_LOGIC_VECTOR(14 DOWNTO 0);                    -- mem_a
			hps_0_ddr_mem_ba                      : OUT   STD_LOGIC_VECTOR(2 DOWNTO 0);                     -- mem_ba
			hps_0_ddr_mem_ck                      : OUT   STD_LOGIC;                                        -- mem_ck
			hps_0_ddr_mem_ck_n                    : OUT   STD_LOGIC;                                        -- mem_ck_n
			hps_0_ddr_mem_cke                     : OUT   STD_LOGIC;                                        -- mem_cke
			hps_0_ddr_mem_cs_n                    : OUT   STD_LOGIC;                                        -- mem_cs_n
			hps_0_ddr_mem_ras_n                   : OUT   STD_LOGIC;                                        -- mem_ras_n
			hps_0_ddr_mem_cas_n                   : OUT   STD_LOGIC;                                        -- mem_cas_n
			hps_0_ddr_mem_we_n                    : OUT   STD_LOGIC;                                        -- mem_we_n
			hps_0_ddr_mem_reset_n                 : OUT   STD_LOGIC;                                        -- mem_reset_n
			hps_0_ddr_mem_dq                      : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => 'X'); -- mem_dq
			hps_0_ddr_mem_dqs                     : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0)  := (OTHERS => 'X'); -- mem_dqs
			hps_0_ddr_mem_dqs_n                   : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0)  := (OTHERS => 'X'); -- mem_dqs_n
			hps_0_ddr_mem_odt                     : OUT   STD_LOGIC;                                        -- mem_odt
			hps_0_ddr_mem_dm                      : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);                     -- mem_dm
			hps_0_ddr_oct_rzqIN                   : IN    STD_LOGIC                     := 'X';             -- oct_rzqIN
			hps_0_io_hps_io_emac1_INst_TX_CLK     : OUT   STD_LOGIC;                                        -- hps_io_emac1_INst_TX_CLK
			hps_0_io_hps_io_emac1_INst_TXD0       : OUT   STD_LOGIC;                                        -- hps_io_emac1_INst_TXD0
			hps_0_io_hps_io_emac1_INst_TXD1       : OUT   STD_LOGIC;                                        -- hps_io_emac1_INst_TXD1
			hps_0_io_hps_io_emac1_INst_TXD2       : OUT   STD_LOGIC;                                        -- hps_io_emac1_INst_TXD2
			hps_0_io_hps_io_emac1_INst_TXD3       : OUT   STD_LOGIC;                                        -- hps_io_emac1_INst_TXD3
			hps_0_io_hps_io_emac1_INst_RXD0       : IN    STD_LOGIC                     := 'X';             -- hps_io_emac1_INst_RXD0
			hps_0_io_hps_io_emac1_INst_MDIO       : INOUT STD_LOGIC                     := 'X';             -- hps_io_emac1_INst_MDIO
			hps_0_io_hps_io_emac1_INst_MDC        : OUT   STD_LOGIC;                                        -- hps_io_emac1_INst_MDC
			hps_0_io_hps_io_emac1_INst_RX_CTL     : IN    STD_LOGIC                     := 'X';             -- hps_io_emac1_INst_RX_CTL
			hps_0_io_hps_io_emac1_INst_TX_CTL     : OUT   STD_LOGIC;                                        -- hps_io_emac1_INst_TX_CTL
			hps_0_io_hps_io_emac1_INst_RX_CLK     : IN    STD_LOGIC                     := 'X';             -- hps_io_emac1_INst_RX_CLK
			hps_0_io_hps_io_emac1_INst_RXD1       : IN    STD_LOGIC                     := 'X';             -- hps_io_emac1_INst_RXD1
			hps_0_io_hps_io_emac1_INst_RXD2       : IN    STD_LOGIC                     := 'X';             -- hps_io_emac1_INst_RXD2
			hps_0_io_hps_io_emac1_INst_RXD3       : IN    STD_LOGIC                     := 'X';             -- hps_io_emac1_INst_RXD3
			hps_0_io_hps_io_qspi_INst_IO0         : INOUT STD_LOGIC                     := 'X';             -- hps_io_qspi_INst_IO0
			hps_0_io_hps_io_qspi_INst_IO1         : INOUT STD_LOGIC                     := 'X';             -- hps_io_qspi_INst_IO1
			hps_0_io_hps_io_qspi_INst_IO2         : INOUT STD_LOGIC                     := 'X';             -- hps_io_qspi_INst_IO2
			hps_0_io_hps_io_qspi_INst_IO3         : INOUT STD_LOGIC                     := 'X';             -- hps_io_qspi_INst_IO3
			hps_0_io_hps_io_qspi_INst_SS0         : OUT   STD_LOGIC;                                        -- hps_io_qspi_INst_SS0
			hps_0_io_hps_io_qspi_INst_CLK         : OUT   STD_LOGIC;                                        -- hps_io_qspi_INst_CLK
			hps_0_io_hps_io_sdio_INst_CMD         : INOUT STD_LOGIC                     := 'X';             -- hps_io_sdio_INst_CMD
			hps_0_io_hps_io_sdio_INst_D0          : INOUT STD_LOGIC                     := 'X';             -- hps_io_sdio_INst_D0
			hps_0_io_hps_io_sdio_INst_D1          : INOUT STD_LOGIC                     := 'X';             -- hps_io_sdio_INst_D1
			hps_0_io_hps_io_sdio_INst_CLK         : OUT   STD_LOGIC;                                        -- hps_io_sdio_INst_CLK
			hps_0_io_hps_io_sdio_INst_D2          : INOUT STD_LOGIC                     := 'X';             -- hps_io_sdio_INst_D2
			hps_0_io_hps_io_sdio_INst_D3          : INOUT STD_LOGIC                     := 'X';             -- hps_io_sdio_INst_D3
			hps_0_io_hps_io_usb1_INst_D0          : INOUT STD_LOGIC                     := 'X';             -- hps_io_usb1_INst_D0
			hps_0_io_hps_io_usb1_INst_D1          : INOUT STD_LOGIC                     := 'X';             -- hps_io_usb1_INst_D1
			hps_0_io_hps_io_usb1_INst_D2          : INOUT STD_LOGIC                     := 'X';             -- hps_io_usb1_INst_D2
			hps_0_io_hps_io_usb1_INst_D3          : INOUT STD_LOGIC                     := 'X';             -- hps_io_usb1_INst_D3
			hps_0_io_hps_io_usb1_INst_D4          : INOUT STD_LOGIC                     := 'X';             -- hps_io_usb1_INst_D4
			hps_0_io_hps_io_usb1_INst_D5          : INOUT STD_LOGIC                     := 'X';             -- hps_io_usb1_INst_D5
			hps_0_io_hps_io_usb1_INst_D6          : INOUT STD_LOGIC                     := 'X';             -- hps_io_usb1_INst_D6
			hps_0_io_hps_io_usb1_INst_D7          : INOUT STD_LOGIC                     := 'X';             -- hps_io_usb1_INst_D7
			hps_0_io_hps_io_usb1_INst_CLK         : IN    STD_LOGIC                     := 'X';             -- hps_io_usb1_INst_CLK
			hps_0_io_hps_io_usb1_INst_STP         : OUT   STD_LOGIC;                                        -- hps_io_usb1_INst_STP
			hps_0_io_hps_io_usb1_INst_DIR         : IN    STD_LOGIC                     := 'X';             -- hps_io_usb1_INst_DIR
			hps_0_io_hps_io_usb1_INst_NXT         : IN    STD_LOGIC                     := 'X';             -- hps_io_usb1_INst_NXT
			hps_0_io_hps_io_spim1_INst_CLK        : OUT   STD_LOGIC;                                        -- hps_io_spim1_INst_CLK
			hps_0_io_hps_io_spim1_INst_MOSI       : OUT   STD_LOGIC;                                        -- hps_io_spim1_INst_MOSI
			hps_0_io_hps_io_spim1_INst_MISO       : IN    STD_LOGIC                     := 'X';             -- hps_io_spim1_INst_MISO
			hps_0_io_hps_io_spim1_INst_SS0        : OUT   STD_LOGIC;                                        -- hps_io_spim1_INst_SS0
			hps_0_io_hps_io_uart0_INst_RX         : IN    STD_LOGIC                     := 'X';             -- hps_io_uart0_INst_RX
			hps_0_io_hps_io_uart0_INst_TX         : OUT   STD_LOGIC;                                        -- hps_io_uart0_INst_TX
			hps_0_io_hps_io_i2c0_INst_SDA         : INOUT STD_LOGIC                     := 'X';             -- hps_io_i2c0_INst_SDA
			hps_0_io_hps_io_i2c0_INst_SCL         : INOUT STD_LOGIC                     := 'X';             -- hps_io_i2c0_INst_SCL
			hps_0_io_hps_io_i2c1_INst_SDA         : INOUT STD_LOGIC                     := 'X';             -- hps_io_i2c1_INst_SDA
			hps_0_io_hps_io_i2c1_INst_SCL         : INOUT STD_LOGIC                     := 'X';             -- hps_io_i2c1_INst_SCL
			hps_0_io_hps_io_gpio_INst_GPIO09      : INOUT STD_LOGIC                     := 'X';             -- hps_io_gpio_INst_GPIO09
			hps_0_io_hps_io_gpio_INst_GPIO35      : INOUT STD_LOGIC                     := 'X';             -- hps_io_gpio_INst_GPIO35
			hps_0_io_hps_io_gpio_INst_GPIO40      : INOUT STD_LOGIC                     := 'X';             -- hps_io_gpio_INst_GPIO40
			hps_0_io_hps_io_gpio_INst_GPIO48      : INOUT STD_LOGIC                     := 'X';             -- hps_io_gpio_INst_GPIO48
			--hps_0_io_hps_io_gpio_INst_GPIO53      : INOUT STD_LOGIC                     := 'X';             -- hps_io_gpio_INst_GPIO53
			--hps_0_io_hps_io_gpio_INst_GPIO54      : INOUT STD_LOGIC                     := 'X';             -- hps_io_gpio_INst_GPIO54
			hps_0_io_hps_io_gpio_INst_GPIO61      : INOUT STD_LOGIC                     := 'X';             -- hps_io_gpio_INst_GPIO61
			--leds_0_external_connection_export     : OUT   STD_LOGIC_VECTOR(9 DOWNTO 0);                     -- export
			pll_0_sdram_clk                       : OUT   STD_LOGIC;                                        -- clk
			reset_reset_n                         : IN    STD_LOGIC                     := 'X'             -- reset_n
			--switches_0_external_connection_export : IN    STD_LOGIC_VECTOR(9 DOWNTO 0)  := (OTHERS => 'X');
			--enable_leds_export						  : OUT   std_logic_vector(1 downto 0) --                     enable_led.export
		);
	END COMPONENT soc_system;
BEGIN
    soc_system_inst : COMPONENT soc_system
    PORT MAP(	clk_clk	=>	CLOCK_50,
					hps_0_ddr_mem_a								=>	HPS_DDR3_ADDR,
					hps_0_ddr_mem_ba								=>	HPS_DDR3_BA,
					hps_0_ddr_mem_ck								=>	HPS_DDR3_CK_P,
					hps_0_ddr_mem_ck_n							=>	HPS_DDR3_CK_N,
					hps_0_ddr_mem_cke								=>	HPS_DDR3_CKE,
					hps_0_ddr_mem_cs_n							=>	HPS_DDR3_CS_N,
					hps_0_ddr_mem_ras_n							=>	HPS_DDR3_RAS_N,
					hps_0_ddr_mem_cas_n							=>	HPS_DDR3_CAS_N,
					hps_0_ddr_mem_we_n							=>	HPS_DDR3_WE_N,
					hps_0_ddr_mem_reset_n						=>	HPS_DDR3_RESET_N,
					hps_0_ddr_mem_dq								=>	HPS_DDR3_DQ,
					hps_0_ddr_mem_dqs								=>	HPS_DDR3_DQS_P,
					hps_0_ddr_mem_dqs_n							=>	HPS_DDR3_DQS_N,
					hps_0_ddr_mem_odt								=>	HPS_DDR3_ODT,
					hps_0_ddr_mem_dm								=>	HPS_DDR3_DM,
					hps_0_ddr_oct_rzqIN							=>	HPS_DDR3_RZQ,
					hps_0_io_hps_io_emac1_INst_TX_CLK		=>	HPS_ENET_GTX_CLK,
					hps_0_io_hps_io_emac1_INst_TX_CTL		=>	HPS_ENET_TX_EN,
					hps_0_io_hps_io_emac1_INst_TXD0			=>	HPS_ENET_TX_DATA(0),
					hps_0_io_hps_io_emac1_INst_TXD1			=>	HPS_ENET_TX_DATA(1),
					hps_0_io_hps_io_emac1_INst_TXD2			=>	HPS_ENET_TX_DATA(2),
					hps_0_io_hps_io_emac1_INst_TXD3			=>	HPS_ENET_TX_DATA(3),
					hps_0_io_hps_io_emac1_INst_RX_CLK		=>	HPS_ENET_RX_CLK,
					hps_0_io_hps_io_emac1_INst_RX_CTL		=>	HPS_ENET_RX_DV,
					hps_0_io_hps_io_emac1_INst_RXD0			=>	HPS_ENET_RX_DATA(0),
					hps_0_io_hps_io_emac1_INst_RXD1			=>	HPS_ENET_RX_DATA(1),
					hps_0_io_hps_io_emac1_INst_RXD2			=>	HPS_ENET_RX_DATA(2),
					hps_0_io_hps_io_emac1_INst_RXD3			=>	HPS_ENET_RX_DATA(3),
					hps_0_io_hps_io_emac1_INst_MDIO			=>	HPS_ENET_MDIO,
					hps_0_io_hps_io_emac1_INst_MDC			=>	HPS_ENET_MDC,
					hps_0_io_hps_io_qspi_INst_CLK				=>	HPS_FLASH_DCLK,
					hps_0_io_hps_io_qspi_INst_SS0				=>	HPS_FLASH_NCSO,
					hps_0_io_hps_io_qspi_INst_IO0				=>	HPS_FLASH_DATA(0),
					hps_0_io_hps_io_qspi_INst_IO1				=>	HPS_FLASH_DATA(1),
					hps_0_io_hps_io_qspi_INst_IO2				=>	HPS_FLASH_DATA(2),
					hps_0_io_hps_io_qspi_INst_IO3				=>	HPS_FLASH_DATA(3),
					hps_0_io_hps_io_sdio_INst_CLK				=>	HPS_SD_CLK,
					hps_0_io_hps_io_sdio_INst_CMD				=>	HPS_SD_CMD,
					hps_0_io_hps_io_sdio_INst_D0				=>	HPS_SD_DATA(0),
					hps_0_io_hps_io_sdio_INst_D1				=>	HPS_SD_DATA(1),
					hps_0_io_hps_io_sdio_INst_D2				=>	HPS_SD_DATA(2),
					hps_0_io_hps_io_sdio_INst_D3				=>	HPS_SD_DATA(3),
					hps_0_io_hps_io_usb1_INst_CLK				=>	HPS_USB_CLKOUT,
					hps_0_io_hps_io_usb1_INst_STP				=>	HPS_USB_STP,
					hps_0_io_hps_io_usb1_INst_DIR				=>	HPS_USB_DIR,
					hps_0_io_hps_io_usb1_INst_NXT				=>	HPS_USB_NXT,
					hps_0_io_hps_io_usb1_INst_D0				=>	HPS_USB_DATA(0),
					hps_0_io_hps_io_usb1_INst_D1				=>	HPS_USB_DATA(1),
					hps_0_io_hps_io_usb1_INst_D2				=>	HPS_USB_DATA(2),
					hps_0_io_hps_io_usb1_INst_D3				=>	HPS_USB_DATA(3),
					hps_0_io_hps_io_usb1_INst_D4				=>	HPS_USB_DATA(4),
					hps_0_io_hps_io_usb1_INst_D5				=>	HPS_USB_DATA(5),
					hps_0_io_hps_io_usb1_INst_D6				=>	HPS_USB_DATA(6),
					hps_0_io_hps_io_usb1_INst_D7				=>	HPS_USB_DATA(7),
					hps_0_io_hps_io_spim1_INst_CLK			=>	HPS_SPIM_CLK,
					hps_0_io_hps_io_spim1_INst_MOSI			=>	HPS_SPIM_MOSI,
					hps_0_io_hps_io_spim1_INst_MISO			=>	HPS_SPIM_MISO,
					hps_0_io_hps_io_spim1_INst_SS0			=>	HPS_SPIM_SS,
					hps_0_io_hps_io_uart0_INst_RX				=>	HPS_UART_RX,
					hps_0_io_hps_io_uart0_INst_TX				=>	HPS_UART_TX,
					hps_0_io_hps_io_i2c0_INst_SDA				=>	HPS_I2C1_SDAT,
					hps_0_io_hps_io_i2c0_INst_SCL				=>	HPS_I2C1_SCLK,
					hps_0_io_hps_io_i2c1_INst_SDA				=>	HPS_I2C2_SDAT,
					hps_0_io_hps_io_i2c1_INst_SCL				=>	HPS_I2C2_SCLK,
					hps_0_io_hps_io_gpio_INst_GPIO09			=>	HPS_CONV_USB_N,
					hps_0_io_hps_io_gpio_INst_GPIO35			=>	HPS_ENET_INT_N,
					hps_0_io_hps_io_gpio_INst_GPIO40			=>	HPS_LTC_GPIO,
					hps_0_io_hps_io_gpio_INst_GPIO48			=>	HPS_I2C_CONTROL,
					--hps_0_io_hps_io_gpio_INst_GPIO53			=>	HPS_LED,
					--hps_0_io_hps_io_gpio_INst_GPIO54			=>	HPS_KEY_N,
					hps_0_io_hps_io_gpio_INst_GPIO61			=>	HPS_GSENSOR_INT,
					pll_0_sdram_clk								=>	DRAM_CLK,
					reset_reset_n									=>	'1'
					--leds_0_external_connection_export		=>	open,
					--switches_0_external_connection_export	=>	SW,
					--buttons_0_external_connection_export	=>	KEY_N,
					--hex_0_external_connection_export			=>	HEX0_N,
					--hex_1_external_connection_export			=>	HEX1_N,
					--hex_2_external_connection_export			=>	HEX2_N,
					--hex_3_external_connection_export			=>	HEX3_N,
					--hex_4_external_connection_export			=>	HEX4_N,
					--hex_5_external_connection_export			=>	HEX5_N,
					--enable_leds_export 							=> real_led
		);
		--LEDR <= x"00" & real_led;
END ARCHITECTURE;
