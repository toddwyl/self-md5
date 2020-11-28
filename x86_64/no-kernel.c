#include <fcntl.h>
#include <linux/if_alg.h>
#include <sys/syscall.h>
#include <unistd.h>
#define BLOCK_LEN 64 // In bytes

/****************************** MACROS ******************************/
#define ROTLEFT(a, b) ((a << b) | (a >> (32 - b)))

#define FF(x, y, z) ((x & y) | (~x & z))

#define GG(x, y, z) ((x & z) | (y & ~z))

#define HH(x, y, z) (x ^ y ^ z)

#define II(x, y, z) (y ^ (x | ~z))

static long double fsin_my(long double a)
{
    long double res;
    // prof wiht register
    asm __volatile__("fsin\n\t"
                     : "=t"(res)
                     : "0"(a)
                     : "memory");

    return (res) > 0 ? res : -res;
}
// #define ull unsigned long long
#define START 0x400000
const char ss[] = {7, 12, 17, 22, 5, 9, 14, 20, 4, 11, 16, 23, 6, 10, 15, 21};
int main(int argc, char *argv[])
{

    char *data = (char *)START;
    unsigned int hash[4] = {(unsigned int)(0x67452301), (unsigned int)(0xEFCDAB89), (unsigned int)(0x98BADCFE), (unsigned int)(0x10325476)};
    // unsigned int hash[4];
    const short len = 570;
    // const short new_len = ((((len + 8) / 64) + 1) * 64) - 8;
    const short new_len = ((((len + 8) / 64) + 1) * 64) - 8;
    data[len] = 0x80;
    *(unsigned long long *)(data + new_len) = len << 3;
    const short off = new_len - (new_len % BLOCK_LEN);

    for (short j = 0; j < new_len; j += BLOCK_LEN)
    {
        unsigned int *m = (unsigned int *)&data[j];
        unsigned int A, B, C, D;
        A = hash[0];
        B = hash[1];
        C = hash[2];
        D = hash[3];
        char g;
        unsigned int inc;
        for (char i = 0; i < 64; ++i)
        {
            switch (i / 16)
            {
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
    const char *chash = (unsigned char *)&hash;
    for (unsigned char i = 0; i < 32; i++)
    {
        char a = (chash[i >> 1] >> (4 * (1 - i % 2))) & 0xF;
        char c = a >= 10 ? a + ('a' - 10) : a + '0';
        syscall(SYS_write, 1, &c, 1);
    }
    syscall(SYS_exit, 0);
}
