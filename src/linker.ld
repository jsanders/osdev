/* Entry point _start, defined in boot.asm */
ENTRY(_start)

SECTIONS
{
  /* Start at 1MiB, which is conventional for bootloaders looking for kernels */
  . = 1M;

  /* Start with the multiboot header, which must be very early in file,
   * then the text itself. */
  .text BLOCK(4K) : ALIGN(4K)
  {
    *(.multiboot)
    *(.text)
  }

  /* Read-only data */
  .rodata BLOCK(4K) : ALIGN(4K)
  {
    *(.rodata)
  }

  /* Initialized data */
  .data BLOCK(4K) : ALIGN(4K)
  {
    *(.data)
  }

  /* Uninitialized data and our temporary stack */
  .bss BLOCK(4K) : ALIGN(4K)
  {
    *(COMMON)
    *(.bss)
    *(.bootstrap_stack)
  }
}
