#ifndef SPY_H
#define SPY_H

//#define PORTSMASH_P0156
//#define PORTSMASH_P1
#define PORTSMASH_P5
//#define PORTSMASH_P015
//#define PORTSMASH_P06
//#define PORTSMASH_P15

#define SPY_NUM_TIMINGS (1<<16)
#define ZERO_COUNT (1<<10)
#define SPY_PIPE "pipe.fifo"

#ifndef __ASSEMBLER__
#include <stdint.h>
extern void x64_portsmash_spy(uint64_t *buffer);
#endif

#endif /* SPY_H */
