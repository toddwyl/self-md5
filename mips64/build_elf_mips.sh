#/bin/sh
mips-linux-gnu-gcc-7.3.1 -mips64r2 -mabi=64 -Os no-kernel-mips.c -o no-kernel-mips -Wl,--gc-sections -Wl,--strip-all
../sstrip  no-kernel-mips
md5sum no-kernel-mips
rm -rf ./*.o
wc -c no-kernel-mips


