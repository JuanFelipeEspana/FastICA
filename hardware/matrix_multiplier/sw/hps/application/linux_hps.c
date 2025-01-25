#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

//=== FPGA side=====
#define HW_REGS_BASE (0xFF200000)
#define HW_REGS_SPAN (0x00200000)
#define HW_REGS_MASK (HW_REGS_SPAN - 1)
#define HEX_5_BASE 0x0
#define HEX_4_BASE 0x10
#define HEX_3_BASE 0x20
#define HEX_2_BASE 0x30
#define HEX_1_BASE 0x40
#define HEX_0_BASE 0x50
#define BUTTONS_0_BASE 0x60
#define SWITCHES_0_BASE 0x70
#define LEDS_0_BASE 0x80
#define REG_AVALON_0_BASE 0x0

#define STRT_REG_OFT 1
#define READY_REG_OFT 2
#define DONE_REG_OFT 3
#define CLR_REG_OFT 4

//=== HPS side =======
#define GPIO1_BASE 0xFF709000
#define GPIO1_EXT_OFFSET 0x14
// the position of the green led
#define bit_24 0x01000000
#define bit_25 0x02000000
// the postion of the gpio1 reset bit
#define bit_26 0x04000000

static const char HEX_LUT[16] = {
					0x40, 0x79, 0x24, 0x30, 0x19, 0x92, 0x02, 0x78, 0x00, 0x10, // 0-9
					0x88, 0x03, 0x46, 0x21, 0x06, 0x0E}; // a-f


int main()
{
        // ========= FPGA Peripherals =================
	int fd; // Variable to store /dev/mem pointer
	void *h2p_hw_virtual_base = NULL; // To store virtual base of HPS2FPGA lightweight bridge
	volatile unsigned int *h2p_hw_hex_0_addr = NULL; // to store HEX0 address
	volatile unsigned int *h2p_hw_hex_1_addr = NULL; // to store HEX1 address
	volatile unsigned int *h2p_hw_hex_2_addr = NULL; // to store HEX2 address
	volatile unsigned int *h2p_hw_hex_3_addr = NULL; // to store HEX3 address
	volatile unsigned int *h2p_hw_hex_4_addr = NULL; // to store HEX4 address
	volatile unsigned int *h2p_hw_hex_5_addr = NULL; // to store HEX5 address
	volatile unsigned int *h2p_hw_leds_addr = NULL; // to store led pio address
	volatile unsigned int *h2p_hw_button_addr = NULL; // to store buttons pio address
	volatile unsigned int *h2p_hw_switch_addr = NULL; // to store switches pio address
		
	volatile int i;
        
    volatile int quo100000, rem100000;
	volatile int quo10000, rem10000;
	volatile int quo1000, rem1000;
	volatile int quo100, rem100;
	volatile int quo10, rem10;
		
	volatile int sw_reading;
	
	printf("Manage LEDS, Switches and 7-seg Displays in the FPGA");

    //=== Get the virtual addresses ===============
    // Open /dev/mem
	fd = open( "/dev/mem", O_RDWR|O_SYNC );
    if( ( fd = open( "/dev/mem", (O_RDWR|O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		printf("	errno = %s\n", strerror(errno));
		exit(EXIT_FAILURE);
    }

    // get virtual addr that maps to physical address
	h2p_hw_virtual_base = mmap( NULL, HW_REGS_SPAN, (PROT_READ|PROT_WRITE), MAP_SHARED, fd, HW_REGS_BASE);
    if( h2p_hw_virtual_base == MAP_FAILED ) {
		printf( "ERROR: h2p_hw_virtual_base mmap() failed...\n" );
		printf("	errno = %s\n", strerror(errno));
        close( fd );
        exit(EXIT_FAILURE);
    }
		
	
	h2p_hw_hex_0_addr = (unsigned int *)(h2p_hw_virtual_base + HEX_0_BASE);
	h2p_hw_hex_1_addr = (unsigned int *)(h2p_hw_virtual_base + HEX_1_BASE);
	h2p_hw_hex_2_addr = (unsigned int *)(h2p_hw_virtual_base + HEX_2_BASE);
	h2p_hw_hex_3_addr = (unsigned int *)(h2p_hw_virtual_base + HEX_3_BASE);
	h2p_hw_hex_4_addr = (unsigned int *)(h2p_hw_virtual_base + HEX_4_BASE);
	h2p_hw_hex_5_addr = (unsigned int *)(h2p_hw_virtual_base + HEX_5_BASE);
	h2p_hw_leds_addr = (unsigned int *)(h2p_hw_virtual_base + LEDS_0_BASE);
	h2p_hw_button_addr = (unsigned int *)(h2p_hw_virtual_base + BUTTONS_0_BASE);
	h2p_hw_switch_addr = (unsigned int *)(h2p_hw_virtual_base + SWITCHES_0_BASE);
	
	while(1){
		sw_reading = *h2p_hw_switch_addr;
		*h2p_hw_leds_addr = sw_reading;
		
		//DEC-to-BCD
		i = sw_reading;
		quo100000 = i/100000;
		rem100000 = i%100000;
		quo10000 = rem100000/10000;
		rem10000 = rem100000%10000;
		quo1000 = rem10000/1000;
		rem1000 = rem10000%1000;
		quo100 = rem1000/100;
		rem100 = rem1000%100;
		quo10 = rem100/10;
		rem10 = rem100%10;
		
		// Write HEX 0-5
		*h2p_hw_hex_5_addr = HEX_LUT[quo100000];
		*h2p_hw_hex_4_addr = HEX_LUT[quo10000];
		*h2p_hw_hex_3_addr = HEX_LUT[quo1000];
		*h2p_hw_hex_2_addr = HEX_LUT[quo100];
		*h2p_hw_hex_1_addr = HEX_LUT[quo10];
		*h2p_hw_hex_0_addr = HEX_LUT[rem10];
		
	}
	
	close(fd);
    return 0;
}