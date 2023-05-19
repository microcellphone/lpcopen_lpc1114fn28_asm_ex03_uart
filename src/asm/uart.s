/*
Here are some common GCC directives for ARM Cortex-M0 assembly:

.align: Specifies the byte alignment of the following instruction or data item.
.ascii: Specifies a string of characters to be included in the output file.
.asciz: Specifies a zero-terminated string of characters to be included in the output file.
.byte: Specifies one or more bytes of data to be included in the output file.
.data: Marks the start of a data section.
.global: Marks a symbol as visible outside of the current file.
.section: Specifies the section of memory where the following instructions or data items should be placed.
.space: Reserves a block of memory with a specified size.
.thumb: Instructs the assembler to generate Thumb code.
.thumb_func: Marks a function as using the Thumb instruction set.
.word: Specifies one or more words of data to be included in the output file.

Note that this is not an exhaustive list, and different versions of GCC may support additional or different directives.
*/

#include "uart_11xx_asm.h"
#include "iocon_11xx_asm.h"
#include "sysctl_11xx_asm.h"

    .syntax unified

    .text
    .global  USART_Config_Request
	.thumb
	.thumb_func
    .type	USART_Config_Request, %function
USART_Config_Request:
	push {lr}
	ldr		r1, =LPC_IOCON_BASE
	ldr		r2, =IOCON_OFFSET_PIO1_6
	ldr 	r3, [r1, r2]
	movs	r4, #IOCON_FUNC1
	orrs 	r3, r3, r4
	str		r3, [r1, r2]

	ldr		r2, =IOCON_OFFSET_PIO1_7
	ldr 	r3, [r1, r2]
	movs	r4, #IOCON_FUNC1
	orrs 	r3, r3, r4
	str		r3, [r1, r2]

	ldr		r1, =LPC_SYSCTL_BASE
	ldr		r2, =SYSCTL_OFFSET_SYSAHBCLKCTRL
	ldr 	r3, [r1, r2]
	ldr		r4, =(1 << 12)
	orrs 	r3, r3, r4
	str		r3, [r1, r2]

    movs r2, #0x01
    ldr r3, =SYSCTL_OFFSET_USARTCLKDIV
    str r2, [r1, r3]

    mov r0, r0
    bl baudrate_config_request

    ldr r1, =LPC_USART_BASE
    ldr r2, [r1, #USART_OFFSET_LCR]
    ldr r3, =~(1 << 7)
    ands r2, r2, r3
    str r2, [r1, #USART_OFFSET_LCR]

    movs r2, #0x03
    str r2, [r1, #USART_OFFSET_LCR]

    movs r2, #0x07
    str r2, [r1, #USART_OFFSET_FCR]

    pop {pc}


    .text
    .global  USART_putc
	.thumb
	.thumb_func
    .type	USART_putc, %function
USART_putc:
	movs r1, #UART_LSR_THRE
	ldr		r2, =LPC_USART_BASE
wait_for_transfer:
	ldr r0, [r2, #USART_OFFSET_LSR]
	tst r0, r1
	beq wait_for_transfer
	str r3, [r2, #USART_OFFSET_THR]
	bx lr

     .text
    .global  USART_puts
	.thumb_func
    .type	USART_puts, %function
USART_puts:
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #0
	str	r0, [r7, #4]
	b	check
send:
	ldr	r3, [r7, #4]
	ldrb	r3, [r3]
	movs	r0, r3
	bl	USART_putc
	ldr	r3, [r7, #4]
	adds	r3, r3, #1
	str	r3, [r7, #4]
check:
	ldr	r3, [r7, #4]
	ldrb	r3, [r3]
	cmp	r3, #0
	bne	send
	nop
	nop
	mov	sp, r7
	add	sp, sp, #8
	pop	{r7, pc}
	.size	USART_puts, .-USART_puts

     .text
    .global  USART_getc
	.thumb_func
    .type	USART_getc, %function
USART_getc:
    movs r0, #0
wait_for_data:
    ldr r1, =LPC_USART_BASE
    ldrb r2, [r1, #USART_OFFSET_LSR]
    movs r3, #UART_LSR_RDR
    tst r2, r3
    bne read_data
    b wait_for_data
read_data:
    ldr r0, =LPC_USART_BASE
    ldrb r0, [r0, #USART_OFFSET_RBR]
    bx lr
	.size	USART_getc, .-USART_getc
