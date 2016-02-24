// Base64.cpp: implementation of the Base64 class.
//
//////////////////////////////////////////////////////////////////////

#include "Base64.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

int Base64::Encode(Byte* sourceBytes,int sourceLen,Byte* encodedBytes,int enLen)
{
    int i = 0;

    for(i=0; i<enLen; i++)
    {
        encodedBytes[i]=0;
    }

    i=0;

    int modulus = sourceLen % 3;
    int reLen=0;
    int a1=0,a2=0,a3=0;
    if (modulus == 0)
    {
        reLen=4 * sourceLen / 3;
    }
    else
    {
        reLen=4 * (sourceLen/ 3 + 1);
    }
    int dataLength =sourceLen - modulus;


    for (int j = 0; i < dataLength; j += 4)
    {
        a1 = sourceBytes[i] & 0xFF;
        a2 = sourceBytes[(i + 1)] & 0xFF;
        a3 = sourceBytes[(i + 2)] & 0xFF;
        encodedBytes[j] = Base64EncodingTable[(a1 >> 2 & 0x3F)];
        encodedBytes[(j + 1)] = Base64EncodingTable[((a1 << 4 | a2 >> 4) & 0x3F)];
        encodedBytes[(j + 2)] = Base64EncodingTable[((a2 << 2 | a3 >> 6) & 0x3F)];
        encodedBytes[(j + 3)] = Base64EncodingTable[(a3 & 0x3F)];

        i += 3;
    }
    int d1;
    int d2;
    int b1;
    int b2;
    int b3;

    switch (modulus)
    {
    case 0:
        break;
    case 1:
        d1 = sourceBytes[(sourceLen - 1)] & 0xFF;
        b1 = d1 >> 2 & 0x3F;
        b2 = d1 << 4 & 0x3F;
        encodedBytes[(reLen - 4)] = Base64EncodingTable[b1];
        encodedBytes[(reLen - 3)] = Base64EncodingTable[b2];
        encodedBytes[(reLen - 2)] = 61;
        encodedBytes[(reLen - 1)] = 61;
        break;
    case 2:
        d1 = sourceBytes[(sourceLen- 2)] & 0xFF;
        d2 = sourceBytes[(sourceLen - 1)] & 0xFF;
        b1 = d1 >> 2 & 0x3F;
        b2 = (d1 << 4 | d2 >> 4) & 0x3F;
        b3 = d2 << 2 & 0x3F;
        encodedBytes[(reLen- 4)] = Base64EncodingTable[b1];
        encodedBytes[(reLen - 3)] = Base64EncodingTable[b2];
        encodedBytes[(reLen - 2)] = Base64EncodingTable[b3];
        encodedBytes[(reLen - 1)] = 61;
        break;
    }

    return reLen;
}

int Base64::Decode(Byte* encodedBytes,int enLen,Byte* decodeBytes,int deLen)
{

    int i = 0;
    for(i=0; i<deLen; i++)
    {
        decodeBytes[i]=0;
    }

    i=0;
    Byte * discardResult=null;

    int drLen=DiscardNonBase64Bytes(encodedBytes,enLen,discardResult);

    int reLen=0;
    if (discardResult[(drLen - 2)] == 61)
    {
        reLen=(drLen / 4 - 1) * 3 + 1;
    }
    else
    {
        if (discardResult[(drLen - 1)] == 61)
            reLen=(drLen / 4 - 1) * 3 + 2;
        else
            reLen=drLen / 4 * 3;
    }

    for (int j = 0; i < drLen - 4; j += 3)
    {
        Byte b1 = Base64DecodingTable[discardResult[i]];
        Byte b2 = Base64DecodingTable[discardResult[(i + 1)]];
        Byte b3 = Base64DecodingTable[discardResult[(i + 2)]];
        Byte b4 = Base64DecodingTable[discardResult[(i + 3)]];
        decodeBytes[j] = ((Byte)(b1 << 2 | b2 >> 4));
        decodeBytes[(j + 1)] = ((Byte)(b2 << 4 | b3 >> 2));
        decodeBytes[(j + 2)] = ((Byte)(b3 << 6 | b4));

        i += 4;
    }

    if (discardResult[(drLen - 2)] == 61)
    {
        Byte b1 = Base64DecodingTable[discardResult[(drLen - 4)]];
        Byte b2 = Base64DecodingTable[discardResult[(drLen - 3)]];
        decodeBytes[(reLen - 1)] = ((Byte)(b1 << 2 | b2 >> 4));
    }
    else if (discardResult[(drLen - 1)] == 61)
    {
        Byte b1 = Base64DecodingTable[discardResult[(drLen - 4)]];
        Byte b2 = Base64DecodingTable[discardResult[(drLen- 3)]];
        Byte b3 = Base64DecodingTable[discardResult[(drLen - 2)]];
        decodeBytes[(reLen - 2)] = ((Byte)(b1 << 2 | b2 >> 4));
        decodeBytes[(reLen- 1)] = ((Byte)(b2 << 4 | b3 >> 2));
    }
    else
    {
        Byte b1 = Base64DecodingTable[discardResult[(drLen - 4)]];
        Byte b2 = Base64DecodingTable[discardResult[(drLen - 3)]];
        Byte b3 = Base64DecodingTable[discardResult[(drLen - 2)]];
        Byte b4 = Base64DecodingTable[discardResult[(drLen - 1)]];
        decodeBytes[(reLen - 3)] = ((Byte)(b1 << 2 | b2 >> 4));
        decodeBytes[(reLen - 2)] = ((Byte)(b2 << 4 | b3 >> 2));
        decodeBytes[(reLen - 1)] = ((Byte)(b3 << 6 | b4));
    }

    if(discardResult!=0)
    {
        delete[] discardResult;
    }
    return reLen;
}

int Base64::DiscardNonBase64Bytes(Byte* encodedBytes,int enLen,Byte* &discardResult)
{

    discardResult = new Byte[enLen];
    int bytesCopied = 0;
    for (int i = 0; i < enLen; i++)
    {
        if (IsValidBase64Byte(encodedBytes[i]))
        {
            discardResult[bytesCopied++] = encodedBytes[i];
        }
    }

    return bytesCopied;
}

bool Base64::IsValidBase64Byte(Byte b)
{
    if (b == 61)
        return true;

    if ((b < 0) || (b >= 128))
        return false;

    if (Base64DecodingTable[b] == 255)
    {
        return false;
    }

    return true;
}
