/*
 *   Copyright 2018-2019 Alejandro Cabrera Aldaya, Billy Bob Brumley, Sohaib ul Hassan, Cesar Pereida García and Nicola Tuveri
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */

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
