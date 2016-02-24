// MD5.cpp: implementation of the MD5 class.
//
//////////////////////////////////////////////////////////////////////

#include "MD5.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

MD5::MD5()
{
    Md5Init();
}

MD5::~MD5()
{

}


Int64 MD5::F(Int64 x, Int64 y, Int64 z)
{
    return (x & y) | ((~x) & z);
}

Int64 MD5::G(Int64 x, Int64 y, Int64 z)
{
    return (x & z) | (y & (~z));
}


Int64 MD5::H(Int64 x, Int64 y, Int64 z)
{
    return x ^ y ^ z;
}


Int64 MD5::I(Int64 x, Int64 y, Int64 z)
{
    return y ^ (x | (~z));
}

Int64 MD5::FF(Int64 a, Int64 b, Int64 c, Int64 d, Int64 x, Int64 s,Int64 ac)
{
    a += F(b, c, d) + x + ac;
    a = ((Uint)a << (int)s) | ((Uint)a >> (int)(32 - s));
    a += b;
    return a;
}

Int64 MD5::GG(Int64 a, Int64 b, Int64 c, Int64 d, Int64 x, Int64 s,Int64 ac)
{
    a += G(b, c, d) + x + ac;
    a = ((Uint)a << (int)s) | ((Uint)a >> (int)(32 - s));
    a += b;
    return a;
}


Int64 MD5::HH(Int64 a, Int64 b, Int64 c, Int64 d, Int64 x, Int64 s,Int64 ac)
{
    a += H(b, c, d) + x + ac;
    a = ((Uint)a << (int)s) | ((Uint)a >> (int)(32 - s));
    a += b;
    return a;
}


Int64 MD5::II(Int64 a, Int64 b, Int64 c, Int64 d, Int64 x, Int64 s,Int64 ac)
{
    a += I(b, c, d) + x + ac;
    a = ((Uint)a << (int)s) | ((Uint)a >> (int)(32 - s));
    a += b;
    return a;
}


void MD5::Md5Init()
{
    count[0] = 0;
    count[1] = 0;

    state[0] = 0x67452301;
    state[1] = 0xefcdab89;
    state[2] = 0x98badcfe;
    state[3] = 0x10325476;

    int i=0;

    for(i=0; i<64; i++)
    {
        buffer[i]=0;
    }

    for(i=0; i<16; i++)
    {
        digestedBytes[i]=0;
    }
}

void MD5::Md5Update(const Byte* inbuf, int inputLen)
{
    int i=0, index=0, partLen=0;
    Byte block[64];
    index = (int)(count[0] >> 3) & 0x3F;
    if ((count[0] += (inputLen << 3)) < (inputLen << 3))
        count[1]++;
    count[1] += (inputLen >> 29);

    partLen = 64 - index;

    if (inputLen >= partLen)
    {
        this->Md5Memcpy(buffer, inbuf, index, 0, partLen);
        this->Md5Transform(buffer);

        for (i = partLen; i + 63 < inputLen; i += 64)
        {

            this->Md5Memcpy(block, inbuf, 0, i, 64);
            this->Md5Transform(block);
        }
        index = 0;

    }
    else

        i = 0;

    this->Md5Memcpy(buffer, inbuf, index, i, inputLen - i);
}


void MD5::Md5Memcpy(Byte* output, const Byte* input, int outpos, int inpos, int len)
{
    for (int i = 0; i < len; i++)
    {
        output[outpos + i] = input[inpos + i];
    }
}

void MD5::Md5Transform(Byte* block)
{
    Int64 a = state[0], b = state[1], c = state[2], d = state[3];

    Int64 x[16];

    Decode(x, block, 64);

    /* Round 1 */
    a = FF(a, b, c, d, x[0], MD5S11, 0xd76aa478L); /* 1 */
    d = FF(d, a, b, c, x[1], MD5S12, 0xe8c7b756L); /* 2 */
    c = FF(c, d, a, b, x[2], MD5S13, 0x242070dbL); /* 3 */
    b = FF(b, c, d, a, x[3], MD5S14, 0xc1bdceeeL); /* 4 */
    a = FF(a, b, c, d, x[4], MD5S11, 0xf57c0fafL); /* 5 */
    d = FF(d, a, b, c, x[5], MD5S12, 0x4787c62aL); /* 6 */
    c = FF(c, d, a, b, x[6], MD5S13, 0xa8304613L); /* 7 */
    b = FF(b, c, d, a, x[7], MD5S14, 0xfd469501L); /* 8 */
    a = FF(a, b, c, d, x[8], MD5S11, 0x698098d8L); /* 9 */
    d = FF(d, a, b, c, x[9], MD5S12, 0x8b44f7afL); /* 10 */
    c = FF(c, d, a, b, x[10], MD5S13, 0xffff5bb1L); /* 11 */
    b = FF(b, c, d, a, x[11], MD5S14, 0x895cd7beL); /* 12 */
    a = FF(a, b, c, d, x[12], MD5S11, 0x6b901122L); /* 13 */
    d = FF(d, a, b, c, x[13], MD5S12, 0xfd987193L); /* 14 */
    c = FF(c, d, a, b, x[14], MD5S13, 0xa679438eL); /* 15 */
    b = FF(b, c, d, a, x[15], MD5S14, 0x49b40821L); /* 16 */

    /* Round 2 */
    a = GG(a, b, c, d, x[1], MD5S21, 0xf61e2562L); /* 17 */
    d = GG(d, a, b, c, x[6], MD5S22, 0xc040b340L); /* 18 */
    c = GG(c, d, a, b, x[11], MD5S23, 0x265e5a51L); /* 19 */
    b = GG(b, c, d, a, x[0], MD5S24, 0xe9b6c7aaL); /* 20 */
    a = GG(a, b, c, d, x[5], MD5S21, 0xd62f105dL); /* 21 */
    d = GG(d, a, b, c, x[10], MD5S22, 0x2441453L); /* 22 */
    c = GG(c, d, a, b, x[15], MD5S23, 0xd8a1e681L); /* 23 */
    b = GG(b, c, d, a, x[4], MD5S24, 0xe7d3fbc8L); /* 24 */
    a = GG(a, b, c, d, x[9], MD5S21, 0x21e1cde6L); /* 25 */
    d = GG(d, a, b, c, x[14], MD5S22, 0xc33707d6L); /* 26 */
    c = GG(c, d, a, b, x[3], MD5S23, 0xf4d50d87L); /* 27 */
    b = GG(b, c, d, a, x[8], MD5S24, 0x455a14edL); /* 28 */
    a = GG(a, b, c, d, x[13], MD5S21, 0xa9e3e905L); /* 29 */
    d = GG(d, a, b, c, x[2], MD5S22, 0xfcefa3f8L); /* 30 */
    c = GG(c, d, a, b, x[7], MD5S23, 0x676f02d9L); /* 31 */
    b = GG(b, c, d, a, x[12], MD5S24, 0x8d2a4c8aL); /* 32 */

    /* Round 3 */
    a = HH(a, b, c, d, x[5], MD5S31, 0xfffa3942L); /* 33 */
    d = HH(d, a, b, c, x[8], MD5S32, 0x8771f681L); /* 34 */
    c = HH(c, d, a, b, x[11], MD5S33, 0x6d9d6122L); /* 35 */
    b = HH(b, c, d, a, x[14], MD5S34, 0xfde5380cL); /* 36 */
    a = HH(a, b, c, d, x[1], MD5S31, 0xa4beea44L); /* 37 */
    d = HH(d, a, b, c, x[4], MD5S32, 0x4bdecfa9L); /* 38 */
    c = HH(c, d, a, b, x[7], MD5S33, 0xf6bb4b60L); /* 39 */
    b = HH(b, c, d, a, x[10], MD5S34, 0xbebfbc70L); /* 40 */
    a = HH(a, b, c, d, x[13], MD5S31, 0x289b7ec6L); /* 41 */
    d = HH(d, a, b, c, x[0], MD5S32, 0xeaa127faL); /* 42 */
    c = HH(c, d, a, b, x[3], MD5S33, 0xd4ef3085L); /* 43 */
    b = HH(b, c, d, a, x[6], MD5S34, 0x4881d05L); /* 44 */
    a = HH(a, b, c, d, x[9], MD5S31, 0xd9d4d039L); /* 45 */
    d = HH(d, a, b, c, x[12], MD5S32, 0xe6db99e5L); /* 46 */
    c = HH(c, d, a, b, x[15], MD5S33, 0x1fa27cf8L); /* 47 */
    b = HH(b, c, d, a, x[2], MD5S34, 0xc4ac5665L); /* 48 */

    /* Round 4 */
    a = II(a, b, c, d, x[0], MD5S41, 0xf4292244L); /* 49 */
    d = II(d, a, b, c, x[7], MD5S42, 0x432aff97L); /* 50 */
    c = II(c, d, a, b, x[14], MD5S43, 0xab9423a7L); /* 51 */
    b = II(b, c, d, a, x[5], MD5S44, 0xfc93a039L); /* 52 */
    a = II(a, b, c, d, x[12], MD5S41, 0x655b59c3L); /* 53 */
    d = II(d, a, b, c, x[3], MD5S42, 0x8f0ccc92L); /* 54 */
    c = II(c, d, a, b, x[10], MD5S43, 0xffeff47dL); /* 55 */
    b = II(b, c, d, a, x[1], MD5S44, 0x85845dd1L); /* 56 */
    a = II(a, b, c, d, x[8], MD5S41, 0x6fa87e4fL); /* 57 */
    d = II(d, a, b, c, x[15], MD5S42, 0xfe2ce6e0L); /* 58 */
    c = II(c, d, a, b, x[6], MD5S43, 0xa3014314L); /* 59 */
    b = II(b, c, d, a, x[13], MD5S44, 0x4e0811a1L); /* 60 */
    a = II(a, b, c, d, x[4], MD5S41, 0xf7537e82L); /* 61 */
    d = II(d, a, b, c, x[11], MD5S42, 0xbd3af235L); /* 62 */
    c = II(c, d, a, b, x[2], MD5S43, 0x2ad7d2bbL); /* 63 */
    b = II(b, c, d, a, x[9], MD5S44, 0xeb86d391L); /* 64 */

    state[0] += a;
    state[1] += b;
    state[2] += c;
    state[3] += d;
}


void MD5::Encode(Byte* output, Int64* input, int len)
{

    for (int i = 0, j = 0; j < len; i++, j += 4)
    {
        output[j] = (Byte)(input[i] & 0xffL);
        output[j + 1] = (Byte)((input[i] >> 8) & 0xffL);
        output[j + 2] = (Byte)((input[i] >> 16) & 0xffL);
        output[j + 3] = (Byte)((input[i] >> 24) & 0xffL);
    }
}

void MD5::Decode(Int64* output, Byte* input, int len)
{

    for (int i = 0, j = 0; j < len; i++, j += 4)
    {
        output[i] = ((Int64)input[j])|
                    (((Int64)input[j + 1]) << 8) |
                    (((Int64)input[j + 2]) << 16) |
                    (((Int64)input[j + 3]) << 24);

    }
}


void MD5::ByteHEX(Byte byte,char* src,int srcLen,int index)
{

    if(srcLen<(index+2))
    {
        return;
    }

    src[index] = MD5Digit[(byte >> 4) & 0X0F];
    src[index+1] = MD5Digit[byte & 0X0F];

}

int MD5::Digest(Byte *src,int srcLen,char* digested,int dLen)
{

    int i=0;
    for(i=0; i<dLen; i++)
    {
        digested[i]=0;
    }

    Md5Init();
    Md5Update(src, srcLen);
    Md5Final();

    for ( i = 0; i < 16; i++)
    {
        ByteHEX(this->digestedBytes[i],digested,dLen,i*2);
    }
    return 32;
}

int MD5::Digest(Byte *src,int srcLen,Byte* digested,int dLen)
{
    int i=0;
    for(i=0; i<dLen; i++)
    {
        digested[i]=0;
    }

    Md5Init();
    Md5Update(src, srcLen);
    Md5Final();

    for(i=0; i<16; i++)
    {
        digested[i]=this->digestedBytes[i];
    }
    return 16;
}


void MD5::Md5Final()
{
    Byte bits[8];

    int index=0, padLen=0;

    Encode(bits, count, 8);

    index = (int)(count[0] >> 3) & 0x3f;

    padLen = (index < 56) ? (56 - index) : (120 - index);

    Md5Update(MD5PADDING, padLen);

    Md5Update(bits, 8);

    Encode(this->digestedBytes, state, 16);
}

