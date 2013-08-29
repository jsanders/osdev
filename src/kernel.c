#include <stddef.h>
#include <stdint.h>

uint16_t vga_entry(char c, uint8_t color) {
  return ((uint16_t) c) | (((uint16_t) color) << 8);
}

static const size_t VGA_HEIGHT = 24;
static const size_t VGA_WIDTH = 80;

size_t term_row = 0;
size_t term_col = 0;
uint8_t term_color = 7; // Gray on black
uint16_t* term_buf = (uint16_t*) 0xB8000; // Location of VGA text mode buffer

void term_init() {
  for(size_t y = 0; y < VGA_HEIGHT; y++) {
    for(size_t x = 0; x < VGA_HEIGHT; x++) {
      const size_t index = y * VGA_WIDTH + x;
      term_buf[index] = vga_entry('x', term_color);
    }
  }
}

void kernel_main() {
  term_init();
}
