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

#include "spy.h"

# args   : rdi (buf) rsi rdx rcx r8 r9
# scratch: rax r10 r11

.text

.global x64_portsmash_spy
.p2align 4
x64_portsmash_spy:
# just some non-degenerate values
add %rdi, %r8
add %rdi, %r9
add %rdi, %r10
add %rdi, %r11

mov $SPY_NUM_TIMINGS, %rcx

1:
lfence
rdtsc # rdx:rax
lfence
mov %rax, %rsi

#ifdef PORTSMASH_P0156
.rept 64
add %r8, %r8
add %r9, %r9
add %r10, %r10
add %r11, %r11
.endr
#elif defined(PORTSMASH_P015)
.rept 64
paddb %xmm0, %xmm0
paddb %xmm1, %xmm1
paddb %xmm2, %xmm2
.endr
#elif defined(PORTSMASH_P06)
.rept 256
ror $2, %rdx
ror $2, %rax
.endr
#elif defined(PORTSMASH_P15)
.rept 64
andn %r8, %r9, %r8
andn %r10, %r11, %r10
.endr
#elif defined(PORTSMASH_P1)
.rept 48
crc32 %r8, %r8
crc32 %r9, %r9
crc32 %r10, %r10
.endr
#elif defined(PORTSMASH_P5)
.rept 48
vpermd %ymm0, %ymm1, %ymm0
vpermd %ymm2, %ymm3, %ymm2
vpermd %ymm4, %ymm5, %ymm4
.endr
#else
#error Not smashing any ports
#endif

lfence
rdtsc
shl $32, %rax
or %rsi, %rax
mov %rax, (%rdi)
add $8, %rdi
dec %rcx
jnz 1b

ret
