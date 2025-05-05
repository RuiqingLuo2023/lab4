#include <stdint.h>
#include "fir_control.h"

#define reg_mprj_datal (*(volatile uint32_t*)0x2600000C)

void write_fir_data(void) {
    // 配置数据长度（可选）
    REG_FIR_LEN = 64;

    // 写入 TAP 系数（16个，全设为1）
    for (int i = 0; i < 16; i++) {
        REG_FIR_TAP(i) = 1;
    }

    // 写入输入数据 X[n] = 0~63
    for (int i = 0; i < 64; i++) {
        REG_FIR_X = i;
    }

    // 启动 FIR 计算
    REG_FIR_CTRL = 0x1; // ap_start = 1
}

void wait_until_done(void) {
    while (!(REG_FIR_CTRL & 0x2)); // 等待 ap_done 拉高
}

void read_fir_result(void) {
    for (int i = 0; i < 64; i++) {
        volatile uint32_t y = REG_FIR_Y;
        (void)y;  // 防止优化
    }
}

void main() {
    // 启动 checkbit
    reg_mprj_datal = 0xA5A50000;

    // FIR 流程
    write_fir_data();
    wait_until_done();
    read_fir_result();

    // 完成 checkbit
    reg_mprj_datal = 0x5A5A0000;

    // 停机
    while (1);
}
