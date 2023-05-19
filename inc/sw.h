#ifndef __SW_H__
#define __SW_H__

#include "chip.h"

#define SW_INTERRUPT 1

#define SW1_PORT 1
#define SW1_BIT  8

#define SW2_PORT 1
#define SW2_BIT  9

#define SW3_PORT 0
#define SW3_BIT  1

#define SW4_PORT 0
#define SW4_BIT  3

typedef enum SW_NAME {
	SW1,
	SW2,
	SW3,
	SW4,
	SW_MAX
}sw_name_t;

typedef enum SW_STATUS {
	OFF,
	ON,
} sw_status_t;

#endif // __SW_H__
