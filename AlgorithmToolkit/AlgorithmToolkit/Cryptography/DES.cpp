// DES.cpp: implementation of the DES class.
//
//////////////////////////////////////////////////////////////////////

#include "DES.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

DES::DES()
{
    this->deKey=null;
    this->enKey=null;
}

DES::~DES()
{
    if(this->deKey!=null)
    {
        delete[] this->deKey;
    }

    if(this->enKey!=null)
    {
        delete[] this->enKey;
    }
}


int DES::Decrypt(Byte* src,int srcLen,Byte* decryptedArray,int daLen)
{
    int m = srcLen % 8;
    int i=0;
    if (m != 0)
    {
        //解密数组必须是8的倍数
        return -1;
    }
    int c = srcLen / 8;

    if(daLen<srcLen)
    {
        //存储长度不足
        return -1;
    }
    for(i=0; i<daLen; i++)
    {
        decryptedArray[i]=0;
    }

    for ( i = 0; i < c; i++)
    {
        DesFunc(deKey, src, i * 8, decryptedArray, i * 8);
    }
    return srcLen;
}

int DES::Encrypt(Byte* src,int srcLen,Byte* encryptedArray,int eaLen)
{
    int m = srcLen % 8;
    int c = srcLen / 8;
    int i=0;
    int bLen=(m != 0 ? c + 1 : c) * 8;
    if(eaLen<bLen)
    {
        return -1;
    }
    for(i=0; i<eaLen; i++)
    {
        encryptedArray[i]=0;
    }

    for (i = 0; i < c; i++)
    {
        DesFunc(enKey, src, i * 8, encryptedArray, i * 8);
    }

    if (m != 0)
    {
        Byte t[8];
        for(i=0; i<8; i++)
        {
            t[i]=0;
        }
        for (i = c * 8; i < srcLen; i++)
        {
            t[(i - c * 8)] = src[i];
        }
        DesFunc(enKey, t, 0, encryptedArray, c * 8);
    }

    return bLen;
}

int* DES::Genkey(bool encrypting, Byte* key,int keyLen)
{
    int* newKey = new int[32];
    int i=0,j=0;

    bool pc1m[56];
    bool pcr[56];

    for(i=0; i<56; i++)
    {
        pc1m[i]=false;
        pcr[i]=false;
    }

    for ( j = 0; j < 56; j++)
    {
        int l = DESPc1[j];

        pc1m[j] = ((key[(l >> 3)] & DESByteBit[(l & 0x7)]) != 0 ? true : false);
    }

    for ( i = 0; i < 16; i++)
    {
        int m;
        if (encrypting)
        {
            m = i << 1;
        }
        else
        {
            m = (15 - i) << 1;
        }

        int n = m + 1;
        int tmp111_110 = 0;
        newKey[n] = tmp111_110;
        newKey[m] = tmp111_110;

        for ( j = 0; j < 28; j++)
        {
            int l = j + DESTotrot[i];
            if (l < 28)
                pcr[j] = pc1m[l];
            else
            {
                pcr[j] = pc1m[(l - 28)];
            }
        }

        for ( j = 28; j < 56; j++)
        {
            int l = j + DESTotrot[i];
            if (l < 56)
                pcr[j] = pc1m[l];
            else
            {
                pcr[j] = pc1m[(l - 28)];
            }
        }

        for ( j = 0; j < 24; j++)
        {
            if (pcr[DESPc2[j]] != false)
            {
                newKey[m] |= DESBigbyte[j];
            }

            if (pcr[DESPc2[(j + 24)]] != false)
            {
                newKey[n] |= DESBigbyte[j];
            }
        }
    }

    for ( i = 0; i != 32; i += 2)
    {
        int i1 = newKey[i];
        int i2 = newKey[(i + 1)];

        newKey[i] = ((i1 & 0xFC0000) << 6 | (i1 & 0xFC0) << 10 | (i2 & 0xFC0000) >> 10 | (i2 & 0xFC0) >> 6);

        newKey[(i + 1)] = ((i1 & 0x3F000) << 12 | (i1 & 0x3F) << 16 | (i2 & 0x3F000) >> 4 | (i2 & 0x3F));
    }

    return newKey;
}


void DES::DesFunc(int* wKey, Byte* ins, int inOff, Byte* outArray, int outOff)
{
    Uint left = ((Uint)ins[(inOff + 0)] & 0xFF) << 24;
    left |= ((Uint)ins[(inOff + 1)] & 0xFF) << 16;
    left |= ((Uint)ins[(inOff + 2)] & 0xFF) << 8;
    left |= (Uint)ins[(inOff + 3)] & 0xFF;

    Uint right = ((Uint)ins[(inOff + 4)] & 0xFF) << 24;
    right |= ((Uint)ins[(inOff + 5)] & 0xFF) << 16;
    right |= ((Uint)ins[(inOff + 6)] & 0xFF) << 8;
    right |= (Uint)ins[(inOff + 7)] & 0xFF;

    Uint work = (left >> 4 ^ right) & 0xF0F0F0F;
    right ^= work;
    left ^= work << 4;
    work = (left >> 16 ^ right) & 0xFFFF;
    right ^= work;
    left ^= work << 16;
    work = (right >> 2 ^ left) & 0x33333333;
    left ^= work;
    right ^= work << 2;
    work = (right >> 8 ^ left) & 0xFF00FF;
    left ^= work;
    right ^= work << 8;
    right = (((right << 1) | ((right >> 31) & 0x1)) & 0xFFFFFFFF);
    work = ((left ^ right) & 0xAAAAAAAA);
    left ^= work;
    right ^= work;
    left = (((left << 1) | ((left >> 31) & 0x1)) & 0xFFFFFFFF);


    for (int round = 0; round < 8; round++)
    {
        work = right << 28 | right >> 4;
        work ^= (Uint)wKey[(round * 4 + 0)];
        int fval = DESSP7[(work & 0x3F)];
        fval |= DESSP5[(work >> 8 & 0x3F)];
        fval |= DESSP3[(work >> 16 & 0x3F)];
        fval |= DESSP1[(work >> 24 & 0x3F)];
        work = right ^ (Uint)wKey[(round * 4 + 1)];
        fval |= DESSP8[(work & 0x3F)];
        fval |= DESSP6[(work >> 8 & 0x3F)];
        fval |= DESSP4[(work >> 16 & 0x3F)];
        fval |= DESSP2[(work >> 24 & 0x3F)];
        left ^= (Uint)fval;
        work = left << 28 | left >> 4;
        work ^= (Uint)wKey[(round * 4 + 2)];
        fval = DESSP7[(work & 0x3F)];
        fval |= DESSP5[(work >> 8 & 0x3F)];
        fval |= DESSP3[(work >> 16 & 0x3F)];
        fval |= DESSP1[(work >> 24 & 0x3F)];
        work = left ^ (Uint)wKey[(round * 4 + 3)];
        fval |= DESSP8[(work & 0x3F)];
        fval |= DESSP6[(work >> 8 & 0x3F)];
        fval |= DESSP4[(work >> 16 & 0x3F)];
        fval |= DESSP2[(work >> 24 & 0x3F)];
        right ^= (Uint)fval;
    }

    right = right << 31 | right >> 1;
    work = ((left ^ right) & 0xAAAAAAAA);
    left ^= work;
    right ^= work;
    left = left << 31 | left >> 1;
    work = (left >> 8 ^ right) & 0xFF00FF;
    right ^= work;
    left ^= work << 8;
    work = (left >> 2 ^ right) & 0x33333333;
    right ^= work;
    left ^= work << 2;
    work = (right >> 16 ^ left) & 0xFFFF;
    left ^= work;
    right ^= work << 16;
    work = (right >> 4 ^ left) & 0xF0F0F0F;
    left ^= work;
    right ^= work << 4;

    outArray[(outOff + 0)] = ((Byte)(right >> 24 & 0xFF));
    outArray[(outOff + 1)] = ((Byte)(right >> 16 & 0xFF));
    outArray[(outOff + 2)] = ((Byte)(right >> 8 & 0xFF));
    outArray[(outOff + 3)] = ((Byte)(right & 0xFF));
    outArray[(outOff + 4)] = ((Byte)(left >> 24 & 0xFF));
    outArray[(outOff + 5)] = ((Byte)(left >> 16 & 0xFF));
    outArray[(outOff + 6)] = ((Byte)(left >> 8 & 0xFF));
    outArray[(outOff + 7)] = ((Byte)(left & 0xFF));
}


void DES::SetKey(Byte* key,int keyLen)
{
    if(this->deKey!=null)
    {
        delete this->deKey;
    }

    if(this->enKey!=null)
    {
        delete this->enKey;
    }

    if (keyLen< 8)
    {
        int i=0;
        Byte b[8];
        for( i=0; i<keyLen; i++)
        {
            b[i]=key[i];
        }
        for(; i<8; i++)
        {
            b[i]=0;
        }
        this->enKey = Genkey(true, b,8);
        this->deKey = Genkey(false, b,8);
    }
    else
    {
        this->enKey = Genkey(true, key,keyLen);
        this->deKey = Genkey(false, key,keyLen);
    }

}
