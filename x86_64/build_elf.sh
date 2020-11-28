#/bin/bash
gcc -S  no-kernel.c -fno-asynchronous-unwind-tables -Os -mavx -msse -mavx2 -ffast-math -fno-stack-protector -fomit-frame-pointer -fsingle-precision-constant -nodefaultlibs -fno-verbose-asm -fno-unroll-loops
sed -i -e "s/main/_start/g" no-kernel.s
sed -i -e "s/\.size.*//g" no-kernel.s
sed -i -e "s/\.ident.*//g" no-kernel.s
sed -i -e "s/\.section.*//g" no-kernel.s
sed -i "s/pushq.*//g" no-kernel.s
sed -i "s/.align 4//g" no-kernel.s
sed -i "s/.align 16//g" no-kernel.s
sed -i "s/.size	main, .-main//g" no-kernel.s
sed -i "s/movl	\$1, %edx/mov \$1, %dl/g" no-kernel.s
sed -i "s/vmovdqa/vmovdqu/g" no-kernel.s
sed -i "s/movsbq	%r11b, %r11//g" no-kernel.s
sed -i "s/movslq	%ecx, %rcx//g" no-kernel.s
as --64 -ac -ad -an  --statistics -o no-kernel.o no-kernel.s syscall.s 
ld -N --no-demangle -x -s -Os --cref  -o no-kernel no-kernel.o 
# gcc -O3 -fdata-sections -ffunction-sections -flto  no-kernel.s syscall.s -o no-kernel2 -Wl,--gc-sections -Wl,--strip-all -Wl,-N -Wl,-x -Wl,-s  -nostdlib -nostdinc 
wc -c no-kernel
strip no-kernel
wc -c no-kernel
../sstrip  no-kernel
wc -c no-kernel
python -c "import os; f = os.popen('wc -c no-kernel'); fsize = int(f.read().split(' ')[0]); print('new_len:',((((fsize + 8) / 64) + 1) * 64) - 8);print('fsize<<3:',fsize << 3);"
md5sum no-kernel
rm -rf ./*.o
./no-kernel


