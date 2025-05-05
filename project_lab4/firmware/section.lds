MEMORY
{
  MPRJ_RAM (rwx) : ORIGIN = 0x38000000, LENGTH = 4M
}

SECTIONS
{
  .text : { *(.text) } > MPRJ_RAM
  .data : { *(.data) } > MPRJ_RAM
  .bss  : { *(.bss) *(COMMON) } > MPRJ_RAM
}
