; Multiboot header constants
MBALIGN		equ 1<<0		; Align on page boundaries
MEMINFO		equ 1<<1		; Provide memory map
FLAGS		equ MBALIGN | MEMINFO	; Multiboot flag field
MAGIC		equ 0x1BADB002		; Multiboot magic number
CHECKSUM	equ -(MAGIC + FLAGS)	; Checksum - MAGIC + FLAGS + CHECKSUM = 0

; Multiboot Standard header. Use special section, so that
; we can direct the linker to put it at the start.
section .multiboot
align 4
	dd MAGIC
	dd FLAGS
	dd CHECKSUM

; At this point the stack pointer is still nonsense, so we
; need to provide our own small temporary stack.
section .bootstrap_stack
align 4
stack_bottom:
times 16384 db 0
stack_top:

; Our linker script specifies _start as the entry point, so the
; bootloader will jump to this position once the kernel is loaded.
section .text
global _start
_start:
	; Prepare to call into C by setting up the stack pointer
	mov esp, stack_top

	; Call into the kernel_main function
	extern kernel_main
	call kernel_main

	; If the kernel returns, we want to just loop indefinitely.
	; First, clear interrupts, then halt, then halt again and again.
	cli
.hang:
	hlt
	jmp .hang
