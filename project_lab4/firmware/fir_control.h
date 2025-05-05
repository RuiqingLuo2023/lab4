#ifndef FIR_CONTROL_H
#define FIR_CONTROL_H

#include <stdint.h>

// Base address of FIR module (defined in wb_fir_wrapper.v)
#define REG_FIR_BASE      0x30000000

// Control register: [0] ap_start, [1] ap_done, [2] ap_idle
#define REG_FIR_CTRL      (*(volatile uint32_t*)(REG_FIR_BASE + 0x00))

// FIR configuration: data length
#define REG_FIR_LEN       (*(volatile uint32_t*)(REG_FIR_BASE + 0x10))

// Tap parameters: REG_FIR_TAP(0) ~ REG_FIR_TAP(15)
#define REG_FIR_TAP(n)    (*(volatile uint32_t*)(REG_FIR_BASE + 0x40 + 4 * (n)))

// Input data X[n]
#define REG_FIR_X         (*(volatile uint32_t*)(REG_FIR_BASE + 0x80))

// Output data Y[n]
#define REG_FIR_Y         (*(volatile uint32_t*)(REG_FIR_BASE + 0x84))

// I/O (used to signal testbench via mprj_io)
#define REG_MPRJ_DATAL    (*(volatile uint32_t*)0x2600000C)

// Function declarations
void write_fir_data(void);
void wait_until_done(void);
void read_fir_result(void);

#endif // FIR_CONTROL_H
