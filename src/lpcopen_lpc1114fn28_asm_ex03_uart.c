/*
===============================================================================
 Name        : lpcopen_lpc1114fn28_asm_ex03_uart.c
 Author      : $(author)
 Version     :
 Copyright   : $(copyright)
 Description : main definition
===============================================================================
*/

#if defined (__USE_LPCOPEN)
#if defined(NO_BOARD_LIB)
#include "chip.h"
#else
#include "board.h"
#endif
#endif

#include <cr_section_macros.h>

// TODO: insert other include files here
#include "led.h"

// TODO: insert other definitions and declarations here
extern void gpio_config_request(void);
extern void USART_Config_Request(uint32_t baudrate);
extern void USART_putc(char data);
extern void USART_puts(char *str);
extern int USART_getc(void);

int main(void) {

#if defined (__USE_LPCOPEN)
    // Read clock settings and update SystemCoreClock variable
    SystemCoreClockUpdate();
#if !defined(NO_BOARD_LIB)
    // Set up and initialize all required blocks and
    // functions related to the board hardware
    Board_Init();
    // Set the LED to the state of "On"
    Board_LED_Set(0, true);
#endif
#endif

    // TODO: insert code here
    uint8_t rcv_data;

    gpio_config_request();
    USART_Config_Request(115200);
    USART_puts("lpcopen_lpc1114fn28_asm_ex03_uart\r\n");

    // Force the counter to be placed into memory
    volatile static int i = 0 ;
    // Enter an infinite loop, just incrementing a counter
    while(1) {
    	rcv_data = USART_getc();
    	USART_putc(rcv_data);
    	LPC_GPIO[LED2_PORT].DATA[(1 << LED2_BIT)] ^= (1 << LED2_BIT);
    	LPC_GPIO[LED1_PORT].DATA[(1 << LED1_BIT)] ^= (1 << LED1_BIT);
		i++ ;
    	// "Dummy" NOP to allow source level single
    	// stepping of tight while() loop
    	__asm volatile ("nop");
    }
    return 0 ;
}
/*
void baudrate_config_request(uint32_t baudrate)
{
	uint32_t DL;
    DL = (SystemCoreClock * LPC_SYSCTL->SYSAHBCLKDIV)
       / (16 * baudrate * LPC_SYSCTL->USARTCLKDIV);
    LPC_USART->LCR |= (1<<7);
    LPC_USART->DLM = DL / 256;
    LPC_USART->DLL = DL % 256;
}
*/
