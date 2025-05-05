#include "fir.h"

int32_t x[FIR_INPUT_LEN] = {0};
int32_t y[FIR_INPUT_LEN] = {0};
int32_t h[FIR_TAP_NUM] = {
    1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1
};

void initfir(void) {
    for (int i = 0; i < FIR_INPUT_LEN; i++) {
        x[i] = i;
        y[i] = 0;
    }
}

void fir(void) {
    for (int n = 0; n < FIR_INPUT_LEN; n++) {
        int32_t acc = 0;
        for (int k = 0; k < FIR_TAP_NUM; k++) {
            if (n - k >= 0) {
                acc += h[k] * x[n - k];
            }
        }
        y[n] = acc;
    }
}
