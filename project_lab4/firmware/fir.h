#ifndef FIR_H
#define FIR_H

#include <stdint.h>

#define FIR_TAP_NUM 16
#define FIR_INPUT_LEN 64

extern int32_t x[FIR_INPUT_LEN];
extern int32_t y[FIR_INPUT_LEN];
extern int32_t h[FIR_TAP_NUM];

void initfir(void);
void fir(void);

#endif // FIR_H
