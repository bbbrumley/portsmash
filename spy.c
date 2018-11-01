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
