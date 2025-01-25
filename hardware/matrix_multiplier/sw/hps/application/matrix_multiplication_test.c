#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>

#define HW_REGS_BASE (0xFF200000)
#define HW_REGS_SPAN (0x00200000)
#define HW_REGS_MASK (HW_REGS_SPAN-1)
#define HEX_5_BASE 0x50
#define HEX_4_BASE 0x40
#define HEX_3_BASE 0x30
#define HEX_2_BASE 0x20
#define HEX_1_BASE 0x10
#define HEX_0_BASE 0x00
#define BUTTONS_0_BASE 0x60
#define SWITCHES_0_BASE 0x70
#define LEDS_0_BASE 0x80
#define REG_AVALON_0_BASE 0x0

#define STRT_REG_OFT 1
#define REDY_REG_OFT 2
#define DONE_REG_OFT 3
#define CLR_REG_OFT 4

#define GPIO1_BASE 0xFF709999
#define GPIO1_EXT_OFFSET 0x14

#define bit_24 0x01000000
#define bit_25 0x02000000

#define bit_24 0x01000000
#define bit_26 0x04000000

int empty[]={0x00,0x00,0x00,0x00,0x00,0x00};
int fpga[]={0x00,0x00,0x71,0x73,0x6F,0x77};
int and[]={0x00,0x00,0x00,0x77,0x54,0x5E};
int soc[]={0x00,0x00,0x00,0x6D,0x3F,0x39};
int are_the[]={0x77,0x50,0x79,0x78,0x76,0x79};
int future[]={0x71,0x3E,0x78,0x3E,0x50,0x79};
  
bool is_fpga_button_pressed(int button_number, volatile unsigned int *base){
  return(*base)&(1<<button_number);
}


int main(){
int fd;
void *h2p_lw_virtual_base=NULL;
volatile unsigned int *h2p_lw_hex_0_addr=NULL;
volatile unsigned int *h2p_lw_hex_1_addr=NULL;
volatile unsigned int *h2p_lw_hex_2_addr=NULL;
volatile unsigned int *h2p_lw_hex_3_addr=NULL;
volatile unsigned int *h2p_lw_hex_4_addr=NULL;
volatile unsigned int *h2p_lw_hex_5_addr=NULL;
volatile unsigned int *h2p_lw_button_addr=NULL;
volatile unsigned int *h2p_lw_leds_addr=NULL;
volatile unsigned int *h2p_lw_switch_addr=NULL;

volatile int i;

volatile int quo100000,rem100000;
volatile int quo10000,rem10000;
volatile int quo1000,rem1000;
volatile int quo100,rem100;
volatile int quo10,rem10;

volatile int sw_reading;

printf("Manage LEDs, Switches and 7-seg Displays in the FPGA\n");

fd= open("/dev/mem",O_RDWR|O_SYNC);
if((fd=open("/dev/mem",O_RDWR|O_SYNC))==-1){
 printf("ERROR:Could not open \*/dev/mem\*\n");
 printf(" errno=%s\n",strerror(errno));
 exit(EXIT_FAILURE);
}

h2p_lw_virtual_base=mmap(NULL,HW_REGS_SPAN,(PROT_READ|PROT_WRITE),MAP_SHARED,fd,HW_REGS_BASE);
if(h2p_lw_virtual_base==MAP_FAILED){
 printf("Error:h2p_lw_virtual_base mmap()failed\n");
 printf(" errno=%s\n",strerror(errno));
close(fd);
exit(EXIT_FAILURE);
}

h2p_lw_leds_addr=(unsigned int*)(h2p_lw_virtual_base + LEDS_0_BASE);
h2p_lw_hex_0_addr=(unsigned int*)(h2p_lw_virtual_base + HEX_0_BASE);
h2p_lw_hex_1_addr=(unsigned int*)(h2p_lw_virtual_base + HEX_1_BASE);
h2p_lw_hex_2_addr=(unsigned int*)(h2p_lw_virtual_base + HEX_2_BASE);
h2p_lw_hex_3_addr=(unsigned int*)(h2p_lw_virtual_base + HEX_3_BASE);
h2p_lw_hex_4_addr=(unsigned int*)(h2p_lw_virtual_base + HEX_4_BASE);
h2p_lw_hex_5_addr=(unsigned int*)(h2p_lw_virtual_base + HEX_5_BASE);
h2p_lw_button_addr=(unsigned int*)(h2p_lw_virtual_base + BUTTONS_0_BASE);
h2p_lw_switch_addr=(unsigned int*)(h2p_lw_virtual_base + SWITCHES_0_BASE);

while(1){
  int num_button = 0;
  int * current_string;
  for(char i = 0; i < 4; i++){
    num_button += (!is_fpga_button_pressed(i, h2p_lw_button_addr)) << i;
  }
  switch(num_button){
  case 1:
    current_string = fpga;
    break;
  case 2:
    current_string = and;
    break;
  case 3:
    current_string = soc;
    break;
  case 4:
    current_string = are_the;
    break;
  case 5:
    current_string = future;
    break;
  default:
    current_string = empty;
    break;
  }
  *h2p_lw_hex_0_addr=~current_string[5];
  *h2p_lw_hex_1_addr=~current_string[4];
  *h2p_lw_hex_2_addr=~current_string[3];
  *h2p_lw_hex_3_addr=~current_string[2];
  *h2p_lw_hex_4_addr=~current_string[1];
  *h2p_lw_hex_5_addr=~current_string[0];
}

 close(fd);
 return 0;
}
