# 最小的输出自身MD5值的程序

这个是第二届腾讯极客技术挑战赛的[题目](https://geek.qq.com/1/)

我的代码在github上已经公开：

https://github.com/ManWingloeng/self-md5

## 赛题描述

本次的题目非常简单，它“**几乎**”就是一个Hello World! 没错，你只需要简单的打印自身的MD5就可以了，如果你的输出和md5sum的计算结果一致，那么就可以正确通过评测。

![img](https://cdn.jsdelivr.net/gh/ManWingloeng/pic_store/tmp/20201128223322.png)
请直接提交你的二进制程序参加比赛，最终我们将按照程序的大小进行排名，**程序越小的排名越靠前**。如果大小一致，则先提交的排前面。

## 运行环境

1.可以提交处理器体系架构为x86-64、arm64或者mips64el的程序，x86-64程序的运行环境是ubuntu，内核是Tkernel 3.10，arm64和mips64el的是debian，内核版本4.19，无网络环境。**你可选择其中一个赛道参加，也可以三个赛道均参与。**
2.内存限制：**64MB**， 运行时间限制：**1秒**。
3.fork, execve 等系统调用已经屏蔽，运行环境中也不存在其他bin程序可调用，因此不要尝试通过调用其他程序实现。
4.动态库仅有几个最基本的库（ld-linux-x86-64.so.2, libc.so.6, libdl.so.2, libgcc_s.so.1, libm.so.6, libstdc++.so.6，或者在arm64平台、mips64el平台中对应的动态链接库），如果依赖其他库函数，请静态链接。
5.请注意**程序提交后会随机命名**。

## 其他说明

1.基于公平性考虑，我们统一只允许上传**64位的ELF可执行程序**，不能是脚本，也不能是32位程序。
2.请从标准输出打印数据，并且正常退出程序（退出码必须为0）。
3.比赛的分数就是程序大小，分数越小排名越靠前，多次提交以最好成绩为准。
4.上传的程序大小不能超过10MB。
5.本次比赛过程中仅显示排名，分数保密。比赛结束后再公布大家的具体分数与程序。
6.独立完成，**请勿抄袭**，赛后将进行代码相似性比较（与DEMO代码相似除外）。
7.比赛结束前请不要讨论和分享有关解题思路的内容。
8.**运行环境中/proc不可用**，请用argv[0]来取代/proc/self/exe来获取自身路径。

9.程序会在chroot之后以一个**低权限用户**的身份执行，并且使用了系统调用白名单（seccomp）来限制程序的能力以确保安全性和公平性。**直接或意外调用白名单外的系统调用是导致“运行时错误”的常见原因之一**。**此外还限制了程序能够获取的资源（setrlimit）**，比如内存大小和输出大小，请根据需要合理使用各类资源。

## 最后排名

笔者最后的成绩

-   **MIPS64：**第**9**（**4616**字节）

![image-20201128222847674](https://cdn.jsdelivr.net/gh/ManWingloeng/pic_store/tmp/20201128223140.png)

-   **ARM64：**第**11**（**888**字节）

![image-20201128222935016](https://cdn.jsdelivr.net/gh/ManWingloeng/pic_store/tmp/20201128222935.png)

-   **x86_64：**第**22**（**570**字节）【太卷了，卷不动换赛道了...】

![image-20201128223024153](https://cdn.jsdelivr.net/gh/ManWingloeng/pic_store/tmp/20201128223024.png)

## 赛题解读

初读题目以为很简单，结果发现里面的学问很大......

打印自身的MD5，这涉及到如何把程序编译后的elf的md5值写进程序里，就像鸡生蛋还是蛋生鸡的哲学问题一样，我们怎么才能在编译之前就知道可执行文件的md5值呢？

有两种方法：

-   **魔法攻击：**直接碰撞，得出`printf("???")`的程序的md5值恰好也是**???**。

-   **平A：**程序逻辑是把生成的elf文件读进内存计算其md5值打印出来。

对于魔法攻击的思考可以先考虑下面这个问题：

**下图gif是如何做到md5值跟其显示的是一样的？**

![md5等于本身的gif](https://cdn.jsdelivr.net/gh/ManWingloeng/pic_store/tmp/20201128230839.gif)



![](https://pic2.zhimg.com/80/v2-86e7bec42549763a9936e82a7b143d1f_720w.jpg?source=1940ef5c)

知乎上有个讨论：

@[Gh0u1L5](https://www.zhihu.com/people/Gh0u1L5)的回答很好（下面分割线为引用）

------

https://www.zhihu.com/question/411191287/answer/1376615759

假设我们有$M_1,M_2$两段哈希值相等、长度是整数块的数据。既然 $\mathrm{hash}(M_1)+\mathrm{hash}(M_2)$，它们处理到最后的“状态”显然是一样的。那么如果我们把一段完全相同的数据 $P$ 追加到两者的后面，最后的“状态”也应该是一样的，也就是说 $\mathrm{hash}(M_1+P)+\mathrm{hash}(M_2+P) $ 。

换句话说，**在整数块长度的碰撞数据后面追加相同的数据，哈希值不会发生变化**。

进一步地，假设你手里还有另一对碰撞数据 $N_1,N_2$，且 $\mathrm{hash}(N_1)=\mathrm{hash}(N_2)$  。那么你把两对碰撞数据分别连接，就应该得到：

$\mathrm{hash}(M_1+N_1)+\mathrm{hash}(M_1+N_2)+\mathrm{hash}(M_2+N_1)+\mathrm{hash}(M_2+N_2)$ 

注意了，现在你已经**可以自由地选择第一个位置是** $M_1$**还是** $M_2$ **，选择第二个位置是** $N_1$**还是** $N_2$ **，却不会对算出来的哈希值造成任何的影响，不同组合的哈希值都是完全相等的**。

这个就是魔术的关键。

一个MD5值一共有32个位置，每个位置有16个字符可供选择。如果你能找出32组数据，每组数据有16个值，这16个值能够表达出16个不同的字符，且它们的 MD5 哈希相等，那么你就可以利用我们刚才发现的规律，自由地排列组合出任何一串字符，却又不改变文件的 MD5 值。

好，“找出16段 MD5 值一样的数据，还要分别表达16个不同的字符”，听起来很简单吧？

做起来其实也挺简单的，利用**选择前缀碰撞攻击（Chosen-Prefix Collision Attack）**就可以了。

给定任意两段数据 $P_1,P_2$ ，通过选择前缀碰撞攻击我们可以找出两段后缀 $S_1,S_2$ ，使得 $\mathrm{hash}(P_1+S_1)=\mathrm{hash}(P_2+S_2)$  。

而 GIF、PDF 这些文件格式，都是允许在一小块字符图片后面缀上没有用的垃圾数据的。这些垃圾数据都可以被跳过，不参与绘制。

掌握了这些基本知识后，我们就可以开始生成我们的碰撞数据了：

一、先给每个字符绘制一副图片，或者生成一段动画，得到16段画面数据 $d_1,d_2,\dots,d_{16}$。

二、把16段数据两两一组分成8组，进行选择前缀碰撞攻击，得到

-   $\mathrm{hash}(d_1+\mathrm{S}_{12})+\mathrm{hash}(d_2+\mathrm{S}_{12})$  （注：$S_{12}$ 指一段“添加后可以让 $d_1,d_2$ 有相同哈希的垃圾数据”）
-   $\mathrm{hash}(d_3+\mathrm{S}_{34})+\mathrm{hash}(d_4+\mathrm{S}_{34})$ 
-   ……

三、把8组数据两两一组分成4组，进行选择前缀碰撞攻击，得到

-   $\mathrm{hash}(d_1+\mathrm{S}_{12}+\mathrm{S}_{1234})+\mathrm{hash}(d_2+\mathrm{S}_{12}+\mathrm{S}_{1234})+\mathrm{hash}(d_3+\mathrm{S}_{34}+\mathrm{S}_{1234})+\mathrm{hash}(d_4+\mathrm{S}_{34}+\mathrm{S}_{1234})$  
-   $\mathrm{hash}(d_5+\mathrm{S}_{56}+\mathrm{S}_{5678})+\mathrm{hash}(d_6+\mathrm{S}_{56}+\mathrm{S}_{5678})+\mathrm{hash}(d_7+\mathrm{S}_{78}+\mathrm{S}_{5678})+\mathrm{hash}(d_8+\mathrm{S}_{78}+\mathrm{S}_{5678})$  
-   ……

四、以此类推，一共进行8+4+2+1=15次选择前缀碰撞攻击后，我们就能得到一组16段哈希值彼此相等的碰撞数据了。（顺便一提，这个生成过程其实可以组成一种单独的攻击手段，叫 **Nostradamus Attack / Herding Attack**）。

------

这里的关键在于**GIF、PDF 这些文件格式，都是允许在一小块字符图片后面缀上没有用的垃圾数据的。这些垃圾数据都可以被跳过，不参与绘制。** 但是对于本题来说，**printf**出来的就是裸字符，并没有多余的垃圾地方用于碰撞，但是生成的ELF可以在末尾一直拼接一些垃圾数据。而实验表明我这样生成出来的ELF比直接写逻辑还要大，说到底还是我功力不够深。

## 算法实现

下面我讲解一下我的实现过程：

主要思路就是把elf传参或者直接定位到地址空间上找到数据的位置，计算其md5值。

-   **md5值的算法实现**

MD5是输入不定长度信息，输出固定长度128-bits的算法。经过程序流程，生成四个32位数据，最后联合起来成为一个128-bits[散列](https://zh.wikipedia.org/wiki/散列)。基本方式为，求余、取余、调整长度、与链接变量进行循环运算。得出结果。

![md5计算过程(来源维基百科)](https://cdn.jsdelivr.net/gh/ManWingloeng/pic_store/tmp/20201129142317.png)

![F(X,Y,Z) = (X\wedge{Y}) \vee (\neg{X} \wedge{Z})](https://wikimedia.org/api/rest_v1/media/math/render/svg/29bfebad4e7bdd4a2fc1210694eb5664262faecc)

![G(X,Y,Z) = (X\wedge{Z}) \vee (Y \wedge \neg{Z})](https://wikimedia.org/api/rest_v1/media/math/render/svg/7068038702afd55190f991518f3a9188565f32d0)

![H(X,Y,Z) = X \oplus Y \oplus Z](https://wikimedia.org/api/rest_v1/media/math/render/svg/c121ed0510b6ad3ffde9b89cec96ff7552ae9236)

![I(X,Y,Z) = Y \oplus (X \vee \neg{Z})](https://wikimedia.org/api/rest_v1/media/math/render/svg/2f119366de7d323f5e02b8d12a741968fa9d0f99)

![\oplus, \wedge, \vee, \neg](https://wikimedia.org/api/rest_v1/media/math/render/svg/ed39414f7a4720bbf82749a9fcd3ebb15220ea72) 是 *XOR*, *AND*, *OR* , *NOT* 的符号。

其中$K_i$需要计算sin值，导致我在三个赛道实现有一些细微差别，主要用C语言实现的，没有改过太多的汇编。

### x86_64部分代码

```C
static long double fsin_my(long double a){
    long double res;
    asm __volatile__("fsin\n\t"
                     : "=t"(res)
                     : "0"(a)
                     : "memory");
    return (res) > 0 ? res : -res;
}
#define START 0x400000
const char ss[] = {7, 12, 17, 22, 5, 9, 14, 20, 4, 11, 16, 23, 6, 10, 15, 21};
int main(int argc, char *argv[]){
    char *data = (char *)START;
    unsigned int hash[4] = {(unsigned int)(0x67452301), (unsigned int)(0xEFCDAB89), (unsigned int)(0x98BADCFE), (unsigned int)(0x10325476)};
    const short len = 570;
    const short new_len = ((((len + 8) / 64) + 1) * 64) - 8;
    data[len] = 0x80;
    *(unsigned long long *)(data + new_len) = len << 3;
    for (short j = 0; j < new_len; j += BLOCK_LEN){
        unsigned int *m = (unsigned int *)&data[j];
        unsigned int A, B, C, D;
        A = hash[0];
        B = hash[1];
        C = hash[2];
        D = hash[3];
        char g;
        unsigned int inc;
        for (char i = 0; i < 64; ++i){
            switch (i / 16){
            case 0:
                inc = FF(B, C, D);
                g = i;
                break;
            case 1:
                inc = GG(B, C, D);
                g = (5 * i + 1) % 16;
                break;
            case 2:
                inc = HH(B, C, D);
                g = (3 * i + 5) % 16;
                break;
            case 3:
                inc = II(B, C, D);
                g = (7 * i) % 16;
            }
            unsigned int t = (unsigned int)((unsigned long long)4294967296 * fsin_my(i + 1));
            inc += A + m[g] + t;
            A = D;
            D = C;
            C = B;
            B += ROTLEFT(inc, ss[(i / 16) * 4 + (i % 4)]);
        }
        hash[1] += B;
        hash[2] += C;
        hash[3] += D;
        hash[0] += A;
    }
}

```

### ARM64的修改思路

因为ARM是采用精简指令集，像是x86_64的**fsin**指令是无法使用的，我比赛过程中也没有找到比较好的办法代替，最后采用了打表的形式，把sin值都存起来了。但是赛后交流的时候发现居然有人用泰勒展开等方式做到了足够的精度，果然还是我太菜了。

```C
unsigned int KK[64] = {
    0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee, 0xf57c0faf, 0x4787c62a,
    0xa8304613, 0xfd469501, 0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
    0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821, 0xf61e2562, 0xc040b340,
    0x265e5a51, 0xe9b6c7aa, 0xd62f105d, 0x2441453,  0xd8a1e681, 0xe7d3fbc8,
    0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed, 0xa9e3e905, 0xfcefa3f8,
    0x676f02d9, 0x8d2a4c8a, 0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
    0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70, 0x289b7ec6, 0xeaa127fa,
    0xd4ef3085, 0x4881d05,  0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
    0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039, 0x655b59c3, 0x8f0ccc92,
    0xffeff47d, 0x85845dd1, 0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
    0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391};
//unsigned int t = (unsigned int)((unsigned long long)4294967296 * fsin_my(i + 1));
//inc += A + m[g] + t;
inc += A + m[g] + KK[i];
```



### MIPS64的修改思路

因为时间紧，我是在最后一天改了试试在mips赛道交的，找不到虚拟地址入口以及中断指令，所以最后把char *data = (char *)START;改成了下面的形式，直接用mian传参进来读取了。

```C
char data[1024 * 15];
short len = read(open(argv[0], 0, 0), data, sizeof(data));
```





## 优化思路

可执行文件的生成过程包括：预编译，编译，汇编，链接；最终生成操作系统可直接装载执行的文件。

![elf生成过程](https://cdn.jsdelivr.net/gh/ManWingloeng/pic_store/tmp/20201129020406.png)

参照[最小HelloWorld的教程](https://www.bookstack.cn/read/open-c-book/zh-chapters-02-chapter8.markdown#toc_3928_6176_12)进行迭代，可以看到我三个赛道的字节数是不一样的，也就代表着我的优化过程，mips是我最原始的实现方法，后面arm是取消了动态链接，直接调用系统调用。

这里讲解一下系统调用，也就是把**write，read，exit**的函数改成了系统调用的形式，如果调用C语言的**write，read，exit**需要动态链接例如`ld -melf_i386 -o hello hello.o --dynamic-linker /lib/ld-linux.so.2 -L /usr/lib -lc`，这个链接进去是非常大的。

如果需要改成系统调用的形式，首先可以把read改了，不使用C语言的传参并read大小我们就需要知道程序在虚拟地址的入口，再手动写入程序的大小判断程序的结尾在何处。而64位的**x86_64**和**ARM64**的默认虚拟地址入口就在`0x400000`。其次是write和exit函数，这个一般的过程就是把系统调用号放进寄存器中，通过软中断（32位是`int $0x80`，64位则是`syscall`）实现用户空间与内核空间的交互。

<img src="https://cdn.jsdelivr.net/gh/ManWingloeng/pic_store/tmp/20201129144413.png" alt="img" style="zoom:67%;" />

<img src="https://cdn.jsdelivr.net/gh/ManWingloeng/pic_store/tmp/20201129144435.png" alt="img" style="zoom:67%;" />

而write和exit的系统调用号都是规定好的，x86_64的write是1，exit是60。

可以参考[系统调用号](https://blog.csdn.net/haodawang/article/details/79075022)。

**ARM64**则是用下面这个命令替换掉汇编代码的**write**和**exit**。

```shell
sed -i -e "s/bl	write/mov     w8, #64\n  svc     #0 /g" no-kernel-arm.s
sed -i -e "s/bl	exit/mov     x0, #0\n  mov     w8, #93\n  svc     #0 /g" no-kernel-arm.s
```

## 实验环境

-   `gcc 5.4.0`
-   `aarch64-linux-gnu-gcc 5.4.0`
-   `mips-linux-gnu-gcc 7.3.1`
-   `ubuntu 16.04`
还有一个很重要的sstrip程序：https://github.com/aunali1/super-strip  
大多数ELF可执行文件都是用程序头表和节头表构建的。但是，仅前者是必需的，以便OS加载，链接和执行程序。sstrip尝试提取ELF头，程序头表及其内容，而将其他所有内容保留在位存储桶中。它只能删除文件的最后部分，即要保存的部分。但是，这几乎总是包括节头表以及程序加载和执行中不涉及的其他一些节。

```shell
# gcc -v
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-linux-gnu/5/lto-wrapper
Target: x86_64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Ubuntu 5.4.0-6ubuntu1~16.04.12' --with-bugurl=file:///usr/share/doc/gcc-5/README.Bugs --enable-languages=c,ada,c++,java,go,d,fortran,objc,obj-c++ --prefix=/usr --program-suffix=-5 --enable-shared --enable-linker-build-id --libexecdir=/usr/lib --without-included-gettext --enable-threads=posix --libdir=/usr/lib --enable-nls --with-sysroot=/ --enable-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes --with-default-libstdcxx-abi=new --enable-gnu-unique-object --disable-vtable-verify --enable-libmpx --enable-plugin --with-system-zlib --disable-browser-plugin --enable-java-awt=gtk --enable-gtk-cairo --with-java-home=/usr/lib/jvm/java-1.5.0-gcj-5-amd64/jre --enable-java-home --with-jvm-root-dir=/usr/lib/jvm/java-1.5.0-gcj-5-amd64 --with-jvm-jar-dir=/usr/lib/jvm-exports/java-1.5.0-gcj-5-amd64 --with-arch-directory=amd64 --with-ecj-jar=/usr/share/java/eclipse-ecj.jar --enable-objc-gc --enable-multiarch --disable-werror --with-arch-32=i686 --with-abi=m64 --with-multilib-list=m32,m64,mx32 --enable-multilib --with-tune=generic --enable-checking=release --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu
Thread model: posix
gcc version 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.12) 

# aarch64-linux-gnu-gcc -v
Using built-in specs.
COLLECT_GCC=aarch64-linux-gnu-gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc-cross/aarch64-linux-gnu/5/lto-wrapper
Target: aarch64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Ubuntu/Linaro 5.4.0-6ubuntu1~16.04.9' --with-bugurl=file:///usr/share/doc/gcc-5/README.Bugs --enable-languages=c,ada,c++,java,go,d,fortran,objc,obj-c++ --prefix=/usr --program-suffix=-5 --enable-shared --enable-linker-build-id --libexecdir=/usr/lib --without-included-gettext --enable-threads=posix --libdir=/usr/lib --enable-nls --with-sysroot=/ --enable-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes --with-default-libstdcxx-abi=new --enable-gnu-unique-object --disable-libquadmath --enable-plugin --with-system-zlib --disable-browser-plugin --enable-java-awt=gtk --enable-gtk-cairo --with-java-home=/usr/lib/jvm/java-1.5.0-gcj-5-arm64-cross/jre --enable-java-home --with-jvm-root-dir=/usr/lib/jvm/java-1.5.0-gcj-5-arm64-cross --with-jvm-jar-dir=/usr/lib/jvm-exports/java-1.5.0-gcj-5-arm64-cross --with-arch-directory=aarch64 --with-ecj-jar=/usr/share/java/eclipse-ecj.jar --disable-libgcj --enable-multiarch --enable-fix-cortex-a53-843419 --disable-werror --enable-checking=release --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=aarch64-linux-gnu --program-prefix=aarch64-linux-gnu- --includedir=/usr/aarch64-linux-gnu/include
Thread model: posix
gcc version 5.4.0 20160609 (Ubuntu/Linaro 5.4.0-6ubuntu1~16.04.9) 

# mips-linux-gnu-gcc-7.3.1 -v
Using built-in specs.
COLLECT_GCC=mips-linux-gnu-gcc-7.3.1
COLLECT_LTO_WRAPPER=/usr/local/mips-loongson-gcc7.3-linux-gnu/2019.06-29/bin/../libexec/gcc/mips-linux-gnu/7.3.1/lto-wrapper
Target: mips-linux-gnu
Configured with: /home/loongson/chenglulu/loongson-7.3.1/release-14.4/src/gcc-7-2019.01/configure --build=x86_64-unkonwn-linux --host=x86_64-unkonwn-linux --target=mips-linux-gnu --enable-threads --disable-libmudflap --disable-libssp --disable-libstdcxx-pch --with-arch-32=mips32r2 --with-arch-64=mips64r2 --with-float=hard --with-mips-plt --with-fix-loongson3-llsc --enable-extra-sgxxlite-multilibs --with-gnu-as --with-gnu-ld --enable-languages=c,c++,fortran --enable-shared --enable-lto --enable-symvers=gnu --enable-__cxa_atexit --with-glibc-version=2.25 --with-pkgversion='loongson cross toolchain' --with-bugurl=http://bugs.loongnix.org/ --disable-nls --prefix=/opt/loongson --with-sysroot=/opt/loongson/mips-linux-gnu/libc --with-build-sysroot=/home/loongson/chenglulu/loongson-7.3.1/release-14.4/install/opt/mips-loongson-linux-gnu/2019.01-15/mips-linux-gnu/libc --with-gmp=/home/loongson/chenglulu/loongson-7.3.1/release-14.4/obj/pkg-2019.01-15-mips-linux-gnu/mips-2019.01-15-mips-linux-gnu.extras/host-libs-i686-pc-linux-gnu/usr --with-mpfr=/home/loongson/chenglulu/loongson-7.3.1/release-14.4/obj/pkg-2019.01-15-mips-linux-gnu/mips-2019.01-15-mips-linux-gnu.extras/host-libs-i686-pc-linux-gnu/usr --with-mpc=/home/loongson/chenglulu/loongson-7.3.1/release-14.4/obj/pkg-2019.01-15-mips-linux-gnu/mips-2019.01-15-mips-linux-gnu.extras/host-libs-i686-pc-linux-gnu/usr --with-isl=/home/loongson/chenglulu/loongson-7.3.1/release-14.4/obj/pkg-2019.01-15-mips-linux-gnu/mips-2019.01-15-mips-linux-gnu.extras/host-libs-i686-pc-linux-gnu/usr --enable-libgomp --disable-libitm --enable-libatomic --disable-libssp --disable-libcc1 --enable-poison-system-directories --with-python-dir=mips-linux-gnu/share/gdb/python --with-build-time-tools=/home/loongson/chenglulu/loongson-7.3.1/release-14.4/install/opt/mips-loongson-linux-gnu/2019.01-15/mips-linux-gnu/bin --with-build-time-tools=/home/loongson/chenglulu/loongson-7.3.1/release-14.4/install/opt/mips-loongson-linux-gnu/2019.01-15/mips-linux-gnu/bin SED=sed
Thread model: posix
gcc version 7.3.1 20180303 (loongson cross toolchain) 
```



## 还可以改进的思路

由于时间原因，我这里很多都没有做到最好的情况，有兴趣的读者可以自己尝试一下修改，可以进行修改的点有：

1.  把MIPS64赛道的mian入口改成_start进行系统调用，并把wrtie和exit也进行相应的修改。
2.  MIPS64赛道和ARM64赛道的sin值的计算可以改为泰勒展开等形式满足足够精度即可。
3.  可以预先计算hash值，程序写进只计算最后一轮的md5值。

