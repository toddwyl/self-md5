#/bin/bash
aarch64-linux-gnu-gcc -S  no-kernel-arm.c -fno-asynchronous-unwind-tables -Os -ffast-math -fomit-frame-pointer -fsingle-precision-constant -fno-verbose-asm  -nodefaultlibs -fno-stack-protector -ffast-math -fsingle-precision-constant 
sed -i -e "s/main/_start/g" no-kernel-arm.s
sed -i -e "s/\.size.*//g" no-kernel-arm.s
sed -i -e "s/\.ident.*//g" no-kernel-arm.s
sed -i -e "s/\.section.*//g" no-kernel-arm.s
sed -i "s/pushq.*//g" no-kernel-arm.s
sed -i "s/.size	main, .-main//g" no-kernel-arm.s
sed -i "s/.align 4//g" no-kernel-arm.s
sed -i "s/movl	\$1, %edx/mov \$1, %dl/g" no-kernel-arm.s
sed -i "s/.align 16//g" no-kernel-arm.s
sed -i "s/vmovdqa/vmovdqu/g" no-kernel-arm.s
sed -i "s/movsbq	%r11b, %r11//g" no-kernel-arm.s 
sed -i -e "s/bl	write/mov     w8, #64\n  svc     #0 /g" no-kernel-arm.s
sed -i -e "s/bl	exit/mov     x0, #0\n  mov     w8, #93\n  svc     #0 /g" no-kernel-arm.s
sed -i "s/movslq	%ecx, %rcx//g" no-kernel-arm.s
sed -i "s/movslq	%ecx, %rcx//g" no-kernel-arm.s
aarch64-linux-gnu-as  -ac -ad -an  --statistics -o no-kernel-arm.o no-kernel-arm.s
aarch64-linux-gnu-ld -N --no-demangle -x -s -Os --cref  -o no-kernel-arm no-kernel-arm.o 
# aarch64-linux-gnu-gcc -Os -fdata-sections -ffunction-sections -flto  no-kernel-arm.s -o no-kernel-arm2 -Wl,--gc-sections -Wl,--strip-all -Wl,-N -Wl,-x -Wl,-s  -nostdlib -nostdinc -fno-stack-protector
wc -c no-kernel-arm
aarch64-linux-gnu-strip -s no-kernel-arm
../sstrip  no-kernel-arm
wc -c no-kernel-arm
python -c "import os; f = os.popen('wc -c no-kernel-arm'); fsize = int(f.read().split(' ')[0]); print('new_len:',((((fsize + 8) / 64) + 1) * 64) - 8);print('fsize<<3:',fsize << 3);"
md5sum no-kernel-arm
rm -rf ./*.o
./no-kernel-arm


