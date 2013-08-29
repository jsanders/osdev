BASEDIR = $(PWD)
CROSSDIR = $(BASEDIR)/cross
BINUTILS_SRC = $(CROSSDIR)/binutils-2.22
BINUTILS_BUILD = $(CROSSDIR)/binutils-build
GCC_SRC = $(CROSSDIR)/gcc-4.6.4
GCC_BUILD = $(CROSSDIR)/gcc-build
CROSSBINDIR = $(CROSSDIR)/bin
TARGET = i586-elf

$(BINUTILS_SRC):
	wget ftp://ftp.gnu.org/gnu/binutils/binutils-2.22.tar.gz && \
	tar xzvf binutils-2.22.tar.gz && rm binutils-2.22.tar.gz

build-cross-binutils: $(BINUTILS_SRC)
	mkdir -p $(BINUTILS_BUILD) && cd $(BINUTILS_BUILD) && \
	$(BINUTILS_SRC)/configure --target=$(TARGET) --prefix="$(CROSSDIR)" --disable-nls && \
	make && make install

$(GCC_SRC):
	wget ftp://ftp.gnu.org/gnu/gcc/gcc-4.6.4/gcc-core-4.6.4.tar.gz && \
	tar xzvf gcc-core-4.6.4.tar.gz && rm gcc-core-4.6.4.tar.gz && \
	cd $(GCC_SRC) && contrib/download_prerequisites

build-cross-gcc: $(GCC_SRC)
	mkdir -p $(GCC_BUILD) && cd $(GCC_BUILD) && \
	$(GCC_SRC)/configure --target=$(TARGET) --prefix="$(CROSSDIR)" --disable-nls --enable-languages=c --without-headers && \
	make all-gcc && make all-target-libgcc && make install-gcc && make install-target-libgcc

build/:
	mkdir -p $@

build/boot.o: build/ src/boot.asm
	nasm -felf $< -o $@

build/kernel.o: build/ src/kernel.c
	export PATH="$(CROSSBINDIR):$(PATH)" && \
	i586-elf-gcc -c $< -o $@ -std=gnu99 -ffreestanding -O2 -Wall -Wextra

build/jdsos.bin: build/ build/boot.o build/kernel.o
	export PATH="$(CROSSBINDIR):$(PATH)" && \
	i586-elf-gcc -T linker.ld -o $@ -ffreestanding -O2 -nostdlib $? -lgcc

clean:
	rm -f build/*
