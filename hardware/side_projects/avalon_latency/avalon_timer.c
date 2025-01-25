#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

#define REG_AVALON_0_BASE 0x0
#define HW_REGS_BASE (0xC0000000)
#define HW_REGS_SPAN (0x00200000)
#define HW_REGS_MASK (HW_REGS_SPAN - 1)
#define DMA_0 	   0x80
#define TIMER_BASE 0x00
#define HEX_5_BASE 0xa0
#define HEX_4_BASE 0xb0
#define HEX_3_BASE 0xc0
#define HEX_2_BASE 0xd0
#define HEX_1_BASE 0xe0
#define HEX_0_BASE 0xf0
#define BUTTONS_0_BASE 0x100
#define SWITCHES_0_BASE 0x110
#define LEDS_0_BASE 0x120

#define GPIO1_BASE 0xFF709000
#define GPIO1_EXT_OFFSET 0x14
#define bit_24 0x01000000
#define bit_25 0x02000000
#define bit_26 0x04000000

typedef volatile unsigned int vuint;

int main()
{
    int fd;
    void *h2p_hw_virtual_base = NULL;
    vuint *h2p_hw_hex_0_addr = NULL;
    vuint *h2p_hw_hex_1_addr = NULL;
    vuint *h2p_hw_hex_2_addr = NULL;
    vuint *h2p_hw_hex_3_addr = NULL;
    vuint *h2p_hw_hex_4_addr = NULL;
    vuint *h2p_hw_hex_5_addr = NULL;
    vuint *h2p_hw_leds_addr = NULL;
    vuint *h2p_hw_button_addr = NULL;
    vuint *h2p_hw_switch_addr = NULL;
    vuint *h2p_hw_timer_addr = NULL;
    volatile int *h2p_hw_dma_addr = NULL;

    printf("PRUEBAS DE LATENCIA CON EL AVALON");

    fd = open("/dev/mem", O_RDWR|O_SYNC);
    if((fd = open("/dev/mem", (O_RDWR|O_SYNC))) == -1)
    {
        printf("ERROR: couldn't open \"/dev/mem\"...\n");
        printf("    errno = %s\n", strerror(errno));
        exit(EXIT_FAILURE);

    }
    h2p_hw_virtual_base = mmap(NULL, HW_REGS_SPAN, (PROT_READ|PROT_WRITE), MAP_SHARED, fd, HW_REGS_BASE);
    if(h2p_hw_virtual_base == MAP_FAILED)
    {
        printf("ERROR_ h2p_hw_virtual_base mmap() failed...\n");
        printf("    errno = %s\n", strerror(errno));
        close(fd);
        exit(EXIT_FAILURE);
    }

    h2p_hw_hex_0_addr = (unsigned int *)(h2p_hw_virtual_base + HEX_0_BASE);
    h2p_hw_hex_1_addr = (unsigned int *)(h2p_hw_virtual_base + HEX_1_BASE);
    h2p_hw_hex_2_addr = (unsigned int *)(h2p_hw_virtual_base + HEX_2_BASE);
    h2p_hw_hex_3_addr = (unsigned int *)(h2p_hw_virtual_base + HEX_3_BASE);
    h2p_hw_hex_4_addr = (unsigned int *)(h2p_hw_virtual_base + HEX_4_BASE);
    h2p_hw_hex_5_addr = (unsigned int *)(h2p_hw_virtual_base + HEX_5_BASE);
    h2p_hw_leds_addr  = (unsigned int *)(h2p_hw_virtual_base + LEDS_0_BASE);
    h2p_hw_button_addr  = (unsigned int *)(h2p_hw_virtual_base + BUTTONS_0_BASE);
    h2p_hw_switch_addr  = (unsigned int *)(h2p_hw_virtual_base + SWITCHES_0_BASE);
    h2p_hw_timer_addr  = (unsigned int *)(h2p_hw_virtual_base + TIMER_BASE);
    h2p_hw_dma_addr = (unsigned int *)(h2p_hw_virtual_base + DMA_0);

    unsigned int parameters[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0};
    unsigned int addr = (unsigned int) &parameters[0];

    *(h2p_hw_dma_addr+1) = (unsigned int) &parameters[0];
    *(h2p_hw_dma_addr+2) = 0x0000;
    *(h2p_hw_dma_addr+6) |= 0x0000000C;
    *(h2p_hw_timer_addr) = 0x01;
    while(true){
      /*
	printf("Direccion del vector: %x, direccion\n", addr);
	printf("Registro de configuracion: %x %p\n", *(h2p_hw_dma_addr), h2p_hw_dma_addr);
	printf("Registro de lectura: %x %p\n", *(h2p_hw_dma_addr+1), h2p_hw_dma_addr+1);
	printf("Registro de escritura: %x %p\n", *(h2p_hw_dma_addr+2), h2p_hw_dma_addr+2);
	printf("Registro de longitud: %x %p\n", *(h2p_hw_dma_addr+3), h2p_hw_dma_addr+3);
	printf("Registro de control: %x %p\n", *(h2p_hw_dma_addr+6), h2p_hw_dma_addr+6);

        *(h2p_hw_dma_addr+3) = 0x00000010;
	while(*(h2p_hw_dma_addr) & 0x00000002){}
	*(h2p_hw_dma_addr+3) = 0x00000008;
	*(h2p_hw_timer_addr) = 1;
	*(h2p_hw_timer_addr) = 0;
	while(*(h2p_hw_dma_addr) & 0x00000002){}
      */
	printf("Se demora: %d\n", *(h2p_hw_timer_addr+19));
	//*(h2p_hw_timer_addr+18) = 0x000001;
    }
    close(fd);
    return 0;
}


