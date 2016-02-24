// BigInter.cpp: implementation of the BigInter class.
//
//////////////////////////////////////////////////////////////////////

#include "BigInteger.h"
#include <math.h>

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////


BigInteger::BigInteger(void)
{
    Init();
    dataLength = 1;
}

BigInteger::BigInteger(Uint64 value)
{
    Init();

    dataLength = 0;
    while (value != 0 && dataLength < BigIntegerMaxLength)
    {
        data[dataLength] = (Uint)(value & 0xFFFFFFFF);
        value =value>> 32;
        dataLength++;
    }

    if (dataLength == 0)
    {
        dataLength = 1;
    }
}

BigInteger::BigInteger(const BigInteger &bi)
{
    Init();

    dataLength = bi.dataLength;

    for (int i = 0; i < dataLength; i++)
    {
        data[i] = bi.data[i];
    }
}

BigInteger::BigInteger(const Uint inData[],int length)
{
    Init();

    dataLength = length;

    if (dataLength > BigIntegerMaxLength)
    {
        dataLength=BigIntegerMaxLength;
    }

    for (int i = dataLength - 1, j = 0; i >= 0; i--, j++)
    {
        data[j] = inData[i];
    }

    while (dataLength > 1 && data[dataLength - 1] == 0)
    {
        dataLength--;
    }

}

BigInteger::BigInteger(const Uint inData[],int length,bool direct)
{
    Init();

    dataLength = length;

    if (dataLength > BigIntegerMaxLength)
    {
        dataLength=BigIntegerMaxLength;
    }

    if(direct)
    {
        for(int i=0; i<dataLength; i++)
        {
            data[i] = inData[i];
        }
    }
    else
    {
        for (int i = dataLength - 1, j = 0; i >= 0; i--, j++)
        {
            data[j] = inData[i];
        }
    }
    while (dataLength > 1 && data[dataLength - 1] == 0)
    {
        dataLength--;
    }
}

BigInteger::BigInteger(const Byte inData[],int length)
{
    Init();
    dataLength = length >> 2;

    int leftOver =length & 0x3;
    if (leftOver != 0)         // length not multiples of 4
    {
        dataLength++;
    }

    if (dataLength > BigIntegerMaxLength)
    {
        dataLength=BigIntegerMaxLength;
        length=dataLength<<2;
    }

    for (int i = length - 1, j = 0; i >= 3; i -= 4, j++)
    {
        data[j] = (Uint)(((Uint)inData[i - 3] << 24) + ((Uint)inData[i - 2] << 16) +
                         ((Uint)inData[i - 1] << 8) + inData[i]);
    }

    if (leftOver == 1)
    {
        data[dataLength - 1] = (Uint)inData[0];
    }
    else if (leftOver == 2)
    {
        data[dataLength - 1] = (Uint)(((Uint)inData[0] << 8) + inData[1]);
    }
    else if (leftOver == 3)
    {
        data[dataLength - 1] = (Uint)(((Uint)inData[0] << 16) + ((Uint)inData[1] << 8) + inData[2]);
    }

    while (dataLength > 1 && data[dataLength - 1] == 0)
    {
        dataLength--;
    }
}

BigInteger::~BigInteger(void)
{
}


void BigInteger::Init()
{

    dataLength=0;
    for(int i=0; i<BigIntegerMaxLength; i++)
    {
        data[i]=0u;
    }
}



BigInteger operator +(const BigInteger &bi1,const BigInteger &bi2)
{
    BigInteger result;
    result.dataLength = (bi1.dataLength > bi2.dataLength) ? bi1.dataLength : bi2.dataLength;

    Int64 carry = 0;
    for (int i = 0; i < result.dataLength; i++)
    {
        Int64 sum = (Int64)bi1.data[i] + (Int64)bi2.data[i] + carry;
        carry = sum >> 32;
        result.data[i] = (Uint)(sum & 0xFFFFFFFF);
    }

    if (carry != 0 && result.dataLength < BigIntegerMaxLength)
    {
        result.data[result.dataLength] = (Uint)(carry);
        result.dataLength++;
    }

    while (result.dataLength > 1 && result.data[result.dataLength - 1] == 0)
        result.dataLength--;


    // overflow
    /*int lastPos = MaxLength - 1;
    if ((bi1.data[lastPos] & 0x80000000) == (bi2.data[lastPos] & 0x80000000) &&
    	(result.data[lastPos] & 0x80000000) != (bi1.data[lastPos] & 0x80000000))
    {

    }*/

    return result;
}


BigInteger operator ++(BigInteger& bi)
{

    Int64 val, carry = 1;
    int index = 0;

    while (carry != 0 && index < BigIntegerMaxLength)
    {
        val = (Int64)(bi.data[index]);
        val++;

        bi.data[index] = (Uint)(val & 0xFFFFFFFF);
        carry = val >> 32;

        index++;
    }

    if (index > bi.dataLength)
        bi.dataLength = index;
    else
    {
        while (bi.dataLength > 1 && bi.data[bi.dataLength - 1] == 0)
            bi.dataLength--;
    }

    //int lastPos = BigIntegerMaxLength - 1;

    return bi;
}

BigInteger operator -(const BigInteger& bi1,const BigInteger& bi2)
{
    BigInteger result;

    result.dataLength = (bi1.dataLength > bi2.dataLength) ? bi1.dataLength : bi2.dataLength;

    Int64 carryIn = 0;
    for (int i = 0; i < result.dataLength; i++)
    {
        Int64 diff;

        diff = (Int64)bi1.data[i] - (Int64)bi2.data[i] - carryIn;
        result.data[i] = (Uint)(diff & 0xFFFFFFFF);

        if (diff < 0)
            carryIn = 1;
        else
            carryIn = 0;
    }

    // roll over to negative
    if (carryIn != 0)
    {
        for (int i = result.dataLength; i < BigIntegerMaxLength; i++)
            result.data[i] = 0xFFFFFFFF;
        result.dataLength = BigIntegerMaxLength;
    }

    // fixed in v1.03 to give correct datalength for a - (-b)
    while (result.dataLength > 1 && result.data[result.dataLength - 1] == 0)
        result.dataLength--;


    // overflow check
    /*int lastPos = MaxLength - 1;

    if ((bi1.data[lastPos] & 0x80000000) != (bi2.data[lastPos] & 0x80000000) &&
    	(result.data[lastPos] & 0x80000000) != (bi1.data[lastPos] & 0x80000000))
    {
    	//throw (new ArithmeticException());
    }
    */

    return result;
}

BigInteger operator --(BigInteger &bi)
{
    Int64 val;
    bool carryIn = true;
    int index = 0;

    while (carryIn && index < BigIntegerMaxLength)
    {
        val = (Int64)(bi.data[index]);
        val--;

        bi.data[index] = (Uint)(val & 0xFFFFFFFF);

        if (val >= 0)
            carryIn = false;

        index++;
    }

    if (index > bi.dataLength)
        bi.dataLength = index;

    while (bi.dataLength > 1 && bi.data[bi.dataLength - 1] == 0)
        bi.dataLength--;

    //int lastPos = MaxLength - 1;

    return bi;
}

BigInteger operator -=(BigInteger &bi1,const BigInteger &bi2)
{
    bi1=bi1-bi2;
    return bi1;
}


BigInteger operator -(const BigInteger& bi1)
{
    if (bi1.dataLength == 1 && bi1.data[0] == 0)
    {
        BigInteger result;
        return result;
    }

    BigInteger result(bi1);

    // 1's complement
    for (int i = 0; i < BigIntegerMaxLength; i++)
    {
        result.data[i] = (Uint)(~(bi1.data[i]));
    }
    // add one to result of 1's complement
    Int64 val, carry = 1;
    int index = 0;

    while (carry != 0 && index < BigIntegerMaxLength)
    {
        val = (Int64)(result.data[index]);
        val++;

        result.data[index] = (Uint)(val & 0xFFFFFFFF);
        carry = val >> 32;

        index++;
    }

    //Overflow in negation
    /*if ((bi1.data[MaxLength - 1] & 0x80000000) == (result.data[MaxLength - 1] & 0x80000000))
    {

    }*/

    result.dataLength = BigIntegerMaxLength;

    while (result.dataLength > 1 && result.data[result.dataLength - 1] == 0)
    {
        result.dataLength--;
    }
    return result;
}

BigInteger operator *(BigInteger bi1,BigInteger bi2)
{
    int lastPos = BigIntegerMaxLength - 1;
    bool bi1Neg = false, bi2Neg = false;

    if ((bi1.data[lastPos] & 0x80000000) != 0)     // bi1 negative
    {
        bi1Neg = true;
        bi1 = -bi1;
    }
    if ((bi2.data[lastPos] & 0x80000000) != 0)     // bi2 negative
    {
        bi2Neg = true;
        bi2 = -bi2;
    }

    BigInteger result;

    for (int i = 0; i < bi1.dataLength; i++)
    {
        if (bi1.data[i] == 0) continue;

        Uint64 mcarry = 0;
        for (int j = 0, k = i; j < bi2.dataLength; j++, k++)
        {
            // k = i + j
            Uint64 val = ((Uint64)bi1.data[i] * (Uint64)bi2.data[j]) +
                         (Uint64)result.data[k] + mcarry;

            result.data[k] = (Uint)(val & 0xFFFFFFFF);
            mcarry = (val >> 32);
        }

        if (mcarry != 0)
        {
            result.data[i + bi2.dataLength] = (Uint)mcarry;
        }
    }

    result.dataLength = bi1.dataLength + bi2.dataLength;
    if (result.dataLength > BigIntegerMaxLength)
        result.dataLength = BigIntegerMaxLength;

    while (result.dataLength > 1 && result.data[result.dataLength - 1] == 0)
        result.dataLength--;

    // overflow check (result is -ve)
    if ((result.data[lastPos] & 0x80000000) != 0)
    {
        if (bi1Neg != bi2Neg && result.data[lastPos] == 0x80000000)    // different sign
        {
            // handle the special case where multiplication produces
            // a max negative number in 2's complement.

            if (result.dataLength == 1)
                return result;
            else
            {
                bool isMaxNeg = true;
                for (int i = 0; i < result.dataLength - 1 && isMaxNeg; i++)
                {
                    if (result.data[i] != 0)
                        isMaxNeg = false;
                }

                if (isMaxNeg)
                    return result;
            }
        }
        else
        {
            //Multiplication overflow
        }


    }

    // if input has different signs, then result is -ve
    if (bi1Neg != bi2Neg)
        return -result;

    return result;
}


BigInteger operator <<(const BigInteger &bi1, int offset)
{
    BigInteger result=BigInteger(bi1);
    if(offset==0)
    {
        return result;
    }
    result.dataLength = BigInteger::ShiftLeft(result.data,result.dataLength, offset);
    return result;
}



BigInteger operator >>(const BigInteger &bi1, int shiftVal)
{
    BigInteger result(bi1);
    if(shiftVal==0)
    {
        return result;
    }
    result.dataLength = BigInteger::ShiftRight(result.data,result.dataLength, shiftVal);

    int i=0;
    if ((bi1.data[BigIntegerMaxLength - 1] & 0x80000000) != 0) // negative
    {
        for ( i = BigIntegerMaxLength - 1; i >= result.dataLength; i--)
            result.data[i] = 0xFFFFFFFF;

        Uint mask = 0x80000000;
        for (i = 0; i < 32; i++)
        {
            if ((result.data[result.dataLength - 1] & mask) != 0)
                break;

            result.data[result.dataLength - 1] |= mask;
            mask >>= 1;
        }
        result.dataLength = BigIntegerMaxLength;
    }

    return result;
}

int BigInteger::ShiftLeft(Uint buffer[],int bufLen, int shiftVal)
{
    int shiftAmount = 32;

    int index=bufLen;

    while (index > 1 && buffer[index - 1] == 0)
    {
        index--;
    }

    for (int count = shiftVal; count > 0; )
    {
        if (count < shiftAmount)
        {
            shiftAmount = count;
        }


        Uint64 carry = 0;
        for (int i = 0; i < index; i++)
        {
            Uint64 val = ((Uint64)buffer[i]) << shiftAmount;
            val |= carry;

            buffer[i] = (Uint)(val & 0xFFFFFFFF);
            carry = val >> 32;
        }

        if (carry != 0)
        {
            if (index + 1 <=bufLen)
            {
                buffer[index] = (Uint)carry;
                index++;
            }
        }
        count -= shiftAmount;
    }
    return index;
}

int BigInteger::ShiftRight( Uint buffer[],int bufLen, int shiftVal)
{
    int shiftAmount = 32;
    int invShift = 0;


    while (bufLen > 1 && buffer[bufLen - 1] == 0)
        bufLen--;


    for (int count = shiftVal; count > 0; )
    {
        if (count < shiftAmount)
        {
            shiftAmount = count;
            invShift = 32 - shiftAmount;
        }


        Uint64 carry = 0;
        for (int i = bufLen - 1; i >= 0; i--)
        {
            Uint64 val = ((Uint64)buffer[i]) >> shiftAmount;
            val |= carry;

            carry = ((Uint64)buffer[i]) << invShift;
            buffer[i] = (Uint)(val);
        }

        count -= shiftAmount;
    }

    while (bufLen > 1 && buffer[bufLen - 1] == 0)
        bufLen--;

    return bufLen;
}


BigInteger operator ~(const BigInteger &bi)
{
    BigInteger result(bi);

    for (int i = 0; i < BigIntegerMaxLength; i++)
    {
        result.data[i] = (Uint)(~(bi.data[i]));
    }

    result.dataLength = BigIntegerMaxLength;

    while (result.dataLength > 1 && result.data[result.dataLength - 1] == 0)
    {
        result.dataLength--;
    }
    return result;
}


bool operator ==(const BigInteger &bi1,const BigInteger &bi2)
{
    if(bi1.dataLength!=bi2.dataLength)
    {
        return false;
    }
    for(int i=0; i<bi1.dataLength; i++)
    {
        if(bi1.data[i]!=bi2.data[i])
        {
            return false;
        }
    }
    return true;
}

bool operator !=(const BigInteger &bi1,const BigInteger &bi2)
{
    if(bi1.dataLength!=bi2.dataLength)
    {
        return true;
    }
    for(int i=0; i<bi1.dataLength; i++)
    {
        if(bi1.data[i]!=bi2.data[i])
        {
            return true;
        }
    }
    return false;
}

bool operator >(const BigInteger &bi1,const BigInteger &bi2)
{
    int pos = BigIntegerMaxLength - 1;

    // bi1 is negative, bi2 is positive
    if ((bi1.data[pos] & 0x80000000) != 0 && (bi2.data[pos] & 0x80000000) == 0)
        return false;

    // bi1 is positive, bi2 is negative
    else if ((bi1.data[pos] & 0x80000000) == 0 && (bi2.data[pos] & 0x80000000) != 0)
        return true;

    // same sign
    int len = (bi1.dataLength > bi2.dataLength) ? bi1.dataLength : bi2.dataLength;

    for (pos = len - 1; pos >= 0 && bi1.data[pos] == bi2.data[pos]; pos--) ;

    if (pos >= 0)
    {
        if (bi1.data[pos] > bi2.data[pos])
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    return false;
}


bool operator <(const BigInteger &bi1, const BigInteger &bi2)
{
    int pos = BigIntegerMaxLength - 1;

    // bi1 is negative, bi2 is positive
    if ((bi1.data[pos] & 0x80000000) != 0 && (bi2.data[pos] & 0x80000000) == 0)
        return true;

    // bi1 is positive, bi2 is negative
    else if ((bi1.data[pos] & 0x80000000) == 0 && (bi2.data[pos] & 0x80000000) != 0)
        return false;

    // same sign
    int len = (bi1.dataLength > bi2.dataLength) ? bi1.dataLength : bi2.dataLength;

    for (pos = len - 1; pos >= 0 && bi1.data[pos] == bi2.data[pos]; pos--) ;

    if (pos >= 0)
    {
        if (bi1.data[pos] < bi2.data[pos])
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    return false;
}

bool operator >=(const BigInteger &bi1,const BigInteger &bi2)
{
    return (bi1 == bi2 || bi1 > bi2);
}

bool operator <=(const BigInteger &bi1, const BigInteger &bi2)
{
    return (bi1 == bi2 || bi1 < bi2);
}

void BigInteger::MultiByteDivide(BigInteger bi1, BigInteger bi2,
                                 BigInteger &outQuotient, BigInteger& outRemainder)
{
    int i=0;
    Uint result[BigIntegerMaxLength];

    for( i=0; i<BigIntegerMaxLength; i++)
    {
        result[i]=0;
    }

    int remainderLen = bi1.dataLength + 1;

    Uint* remainder=new Uint[remainderLen];

    for( i=0; i<remainderLen; i++)
    {
        remainder[i]=0;
    }

    Uint mask = 0x80000000;
    Uint val = bi2.data[bi2.dataLength - 1];

    int shift = 0, resultPos = 0;

    while (mask != 0 && (val & mask) == 0)
    {
        shift++;
        mask >>= 1;
    }

    for ( i = 0; i < bi1.dataLength; i++)
    {
        remainder[i] = bi1.data[i];
    }

    BigInteger::ShiftLeft(remainder,remainderLen, shift);

    bi2 = bi2 << shift;


    int j = remainderLen - bi2.dataLength;
    int pos = remainderLen - 1;

    Uint64 firstDivisorByte = bi2.data[bi2.dataLength - 1];
    Uint64 secondDivisorByte = bi2.data[bi2.dataLength - 2];

    int divisorLen = bi2.dataLength + 1;
    Uint* dividendPart=new Uint[divisorLen];

    for(i=0; i<divisorLen; i++)
    {
        dividendPart[i]=0;
    }

    while (j > 0)
    {
        Uint64 dividend = ((Uint64)remainder[pos] << 32) + (Uint64)remainder[pos - 1];

        Uint64 q_hat = dividend / firstDivisorByte;
        Uint64 r_hat = dividend % firstDivisorByte;

        bool done = false;
        while (!done)
        {
            done = true;

            if (q_hat == 0x100000000 ||
                    (q_hat * secondDivisorByte) > ((r_hat << 32) + remainder[pos - 2]))
            {
                q_hat--;
                r_hat += firstDivisorByte;

                if (r_hat < 0x100000000)
                    done = false;
            }
        }

        int h =0;
        for ( h = 0; h < divisorLen; h++)
            dividendPart[h] = remainder[pos - h];

        BigInteger kk(dividendPart,divisorLen);
        BigInteger ss = bi2 * (Int64)q_hat;

        while (ss > kk)
        {
            q_hat--;
            ss -= bi2;
        }
        BigInteger yy = kk - ss;

        for ( h = 0; h < divisorLen; h++)
            remainder[pos - h] = yy.data[bi2.dataLength - h];


        result[resultPos++] = (Uint)q_hat;

        pos--;
        j--;
    }

    outQuotient.dataLength = resultPos;
    int y = 0;
    for (int x = outQuotient.dataLength - 1; x >= 0; x--, y++)
        outQuotient.data[y] = result[x];
    for (; y < BigIntegerMaxLength; y++)
        outQuotient.data[y] = 0;

    while (outQuotient.dataLength > 1 && outQuotient.data[outQuotient.dataLength - 1] == 0)
        outQuotient.dataLength--;

    if (outQuotient.dataLength == 0)
        outQuotient.dataLength = 1;

    outRemainder.dataLength = BigInteger::ShiftRight(remainder,remainderLen, shift);

    for (y = 0; y < outRemainder.dataLength; y++)
        outRemainder.data[y] = remainder[y];
    for (; y < BigIntegerMaxLength; y++)
        outRemainder.data[y] = 0;
    if(remainder!=0)
    {
        delete[] remainder;
    }
    if(dividendPart!=0)
    {
        delete[] dividendPart;
    }
}


void BigInteger::SingleByteDivide(BigInteger bi1, BigInteger bi2,
                                  BigInteger& outQuotient, BigInteger& outRemainder)
{
    Uint result[BigIntegerMaxLength];
    int resultPos = 0;
    int i = 0;
    int j = 0;

    // copy dividend to reminder
    for ( i = 0; i < BigIntegerMaxLength; i++)
        outRemainder.data[i] = bi1.data[i];
    outRemainder.dataLength = bi1.dataLength;

    while (outRemainder.dataLength > 1 && outRemainder.data[outRemainder.dataLength - 1] == 0)
        outRemainder.dataLength--;

    Uint64 divisor = (Uint64)bi2.data[0];
    int pos = outRemainder.dataLength - 1;
    Uint64 dividend = (Uint64)outRemainder.data[pos];


    if (dividend >= divisor)
    {
        Uint64 quotient = dividend / divisor;
        result[resultPos++] = (Uint)quotient;

        outRemainder.data[pos] = (Uint)(dividend % divisor);
    }
    pos--;

    while (pos >= 0)
    {

        dividend = ((Uint64)outRemainder.data[pos + 1] << 32) + (Uint64)outRemainder.data[pos];
        Uint64 quotient = dividend / divisor;
        result[resultPos++] = (Uint)quotient;

        outRemainder.data[pos + 1] = 0;
        outRemainder.data[pos--] = (Uint)(dividend % divisor);
    }

    outQuotient.dataLength = resultPos;

    for ( i = outQuotient.dataLength - 1; i >= 0; i--, j++)
        outQuotient.data[j] = result[i];
    for (; j < BigIntegerMaxLength; j++)
        outQuotient.data[j] = 0;

    while (outQuotient.dataLength > 1 && outQuotient.data[outQuotient.dataLength - 1] == 0)
        outQuotient.dataLength--;

    if (outQuotient.dataLength == 0)
        outQuotient.dataLength = 1;

    while (outRemainder.dataLength > 1 && outRemainder.data[outRemainder.dataLength - 1] == 0)
        outRemainder.dataLength--;

}


BigInteger operator /(BigInteger bi1,BigInteger bi2)
{
    BigInteger quotient;
    BigInteger remainder;

    int lastPos = BigIntegerMaxLength - 1;
    bool divisorNeg = false, dividendNeg = false;

    if ((bi1.data[lastPos] & 0x80000000) != 0)     // bi1 negative
    {
        bi1 = -bi1;
        dividendNeg = true;
    }
    if ((bi2.data[lastPos] & 0x80000000) != 0)     // bi2 negative
    {
        bi2 = -bi2;
        divisorNeg = true;
    }

    if (bi1 < bi2)
    {
        return quotient;
    }

    else
    {
        if (bi2.dataLength == 1)
            BigInteger::SingleByteDivide(bi1, bi2, quotient, remainder);
        else
            BigInteger::MultiByteDivide(bi1, bi2, quotient, remainder);

        if (dividendNeg != divisorNeg)
            return -quotient;

        return quotient;
    }
}

BigInteger operator %(BigInteger bi1, BigInteger bi2)
{
    BigInteger quotient;
    BigInteger remainder(bi1);

    int lastPos = BigIntegerMaxLength - 1;
    bool dividendNeg = false;

    if ((bi1.data[lastPos] & 0x80000000) != 0)     // bi1 negative
    {
        bi1 = -bi1;
        dividendNeg = true;
    }
    if ((bi2.data[lastPos] & 0x80000000) != 0)     // bi2 negative
        bi2 = -bi2;

    if (bi1 < bi2)
    {
        return remainder;
    }

    else
    {
        if (bi2.dataLength == 1)
            BigInteger::SingleByteDivide(bi1, bi2, quotient, remainder);
        else
            BigInteger::MultiByteDivide(bi1, bi2, quotient, remainder);

        if (dividendNeg)
            return -remainder;

        return remainder;
    }
}

BigInteger operator &(const BigInteger &bi1,const BigInteger &bi2)
{
    BigInteger result;

    int len = (bi1.dataLength > bi2.dataLength) ? bi1.dataLength : bi2.dataLength;

    for (int i = 0; i < len; i++)
    {
        Uint sum = (Uint)(bi1.data[i] & bi2.data[i]);
        result.data[i] = sum;
    }

    result.dataLength = BigIntegerMaxLength;

    while (result.dataLength > 1 && result.data[result.dataLength - 1] == 0)
        result.dataLength--;

    return result;
}


BigInteger operator |(const BigInteger& bi1,const  BigInteger& bi2)
{
    BigInteger result;

    int len = (bi1.dataLength > bi2.dataLength) ? bi1.dataLength : bi2.dataLength;

    for (int i = 0; i < len; i++)
    {
        Uint sum = (Uint)(bi1.data[i] | bi2.data[i]);
        result.data[i] = sum;
    }

    result.dataLength = BigIntegerMaxLength;

    while (result.dataLength > 1 && result.data[result.dataLength - 1] == 0)
        result.dataLength--;

    return result;
}

BigInteger operator ^(const BigInteger& bi1,const BigInteger& bi2)
{
    BigInteger result;

    int len = (bi1.dataLength > bi2.dataLength) ? bi1.dataLength : bi2.dataLength;

    for (int i = 0; i < len; i++)
    {
        Uint sum = (Uint)(bi1.data[i] ^ bi2.data[i]);
        result.data[i] = sum;
    }

    result.dataLength = BigIntegerMaxLength;

    while (result.dataLength > 1 && result.data[result.dataLength - 1] == 0)
        result.dataLength--;

    return result;
}

int BigInteger::Jacobi(BigInteger a, BigInteger b)
{
    if ((b.data[0] & 0x1) == 0)
    {
        //Exception::Jacobi defined only for odd integers
    }

    if (a >= b) a=a % b;
    if (a.dataLength == 1 && a.data[0] == 0) return 0;  // a == 0
    if (a.dataLength == 1 && a.data[0] == 1) return 1;  // a == 1

    if (a < BigInteger())
    {
        if ((((b - 1).data[0]) & 0x2) == 0)       //if( (((b-1) >> 1).data[0] & 0x1) == 0)
            return Jacobi(-a, b);
        else
            return -Jacobi(-a, b);
    }

    int e = 0;
    for (int index = 0; index < a.dataLength; index++)
    {
        Uint mask = 0x01;

        for (int i = 0; i < 32; i++)
        {
            if ((a.data[index] & mask) != 0)
            {
                index = a.dataLength;      // to break the outer loop
                break;
            }
            mask <<= 1;
            e++;
        }
    }

    BigInteger a1 = a >> e;

    int s = 1;
    if ((e & 0x1) != 0 && ((b.data[0] & 0x7) == 3 || (b.data[0] & 0x7) == 5))
        s = -1;

    if ((b.data[0] & 0x3) == 3 && (a1.data[0] & 0x3) == 3)
        s = -s;

    if (a1.dataLength == 1 && a1.data[0] == 1)
        return s;
    else
        return (s * Jacobi(b % a1, a1));
}

BigInteger BigInteger::GenPseudoPrime(int bits, int confidence,Random &random)
{
    BigInteger result;
    bool done = false;

    while (!done)
    {
        result.GenRandomBits(bits,random);

        result.data[0] |= 0x01;		// make it odd

        // prime test
        done = result.IsProbablePrime(confidence,random);
    }
    return result;
}


BigInteger* BigInteger::LucasSequence(BigInteger P, BigInteger Q,
                                      BigInteger k, BigInteger n)
{
    if (k.dataLength == 1 && k.data[0] == 0)
    {
        BigInteger* result = new BigInteger[3];

        result[0] =BigInteger();
        result[1] = BigInteger(2) % n;
        result[2] = BigInteger(1) % n;
        return result;
    }

    // calculate constant = b^(2k) / m
    // for Barrett Reduction
    BigInteger constant;

    int nLen = n.dataLength << 1;
    constant.data[nLen] = 0x00000001;
    constant.dataLength = nLen + 1;

    constant = constant / n;

    // calculate values of s and t
    int s = 0;

    for (int index = 0; index < k.dataLength; index++)
    {
        Uint mask = 0x01;

        for (int i = 0; i < 32; i++)
        {
            if ((k.data[index] & mask) != 0)
            {
                index = k.dataLength;      // to break the outer loop
                break;
            }
            mask <<= 1;
            s++;
        }
    }

    BigInteger t = k >> s;

    return LucasSequenceHelper(P, Q, t, n, constant, s);
}


BigInteger* BigInteger::LucasSequenceHelper(BigInteger P, BigInteger Q,
        BigInteger k, BigInteger n,
        BigInteger constant, int s)
{
    int i=0;

    BigInteger* result = new BigInteger[3];

    for(i=0; i<3; i++)
    {
        result[i]=0;
    }

    if ((k.data[0] & 0x00000001) == 0)
    {
        //Exception::"Argument k must be odd."
    }
    int numbits = k.BitCount();

    Uint mask = (Uint)0x1 << ((numbits & 0x1F) - 1);

    // v = v0, v1 = v1, u1 = u1, Q_k = Q^0

    BigInteger v = 2 % n, Q_k = 1 % n,
               v1 = P % n, u1 = Q_k;
    bool flag = true;

    for ( i = k.dataLength - 1; i >= 0; i--)     // iterate on the binary expansion of k
    {
        while (mask != 0)
        {
            if (i == 0 && mask == 0x00000001)        // last bit
                break;

            if ((k.data[i] & mask) != 0)             // bit is set
            {
                // index doubling with addition

                u1 = (u1 * v1) % n;

                v = ((v * v1) - (P * Q_k)) % n;
                v1 = n.BarrettReduction(v1 * v1, n, constant);
                v1 = (v1 - ((Q_k * Q) << 1)) % n;

                if (flag)
                    flag = false;
                else
                    Q_k = n.BarrettReduction(Q_k * Q_k, n, constant);

                Q_k = (Q_k * Q) % n;
            }
            else
            {
                // index doubling
                u1 = ((u1 * v) - Q_k) % n;

                v1 = ((v * v1) - (P * Q_k)) % n;
                v = n.BarrettReduction(v * v, n, constant);
                v = (v - (Q_k << 1)) % n;

                if (flag)
                {
                    Q_k = Q % n;
                    flag = false;
                }
                else
                    Q_k = n.BarrettReduction(Q_k * Q_k, n, constant);
            }

            mask >>= 1;
        }
        mask = 0x80000000;
    }

    // at this point u1 = u(n+1) and v = v(n)
    // since the last bit always 1, we need to transform u1 to u(2n+1) and v to v(2n+1)

    u1 = ((u1 * v) - Q_k) % n;
    v = ((v * v1) - (P * Q_k)) % n;
    if (flag)
        flag = false;
    else
        Q_k = n.BarrettReduction(Q_k * Q_k, n, constant);

    Q_k = (Q_k * Q) % n;


    for ( i = 0; i < s; i++)
    {
        // index doubling
        u1 = (u1 * v) % n;
        v = ((v * v) - (Q_k << 1)) % n;

        if (flag)
        {
            Q_k = Q % n;
            flag = false;
        }
        else
            Q_k = n.BarrettReduction(Q_k * Q_k, n, constant);
    }

    result[0] = u1;
    result[1] = v;
    result[2] = Q_k;

    return result;
}


bool BigInteger::LucasStrongTestHelper(BigInteger thisVal)
{
    Int64 D = 5, sign = -1, dCount = 0;
    bool done = false;

    while (!done)
    {
        int Jresult = BigInteger::Jacobi(D, thisVal);

        if (Jresult == -1)
            done = true;    // J(D, this) = 1
        else
        {
            if ((Jresult == 0) && (BigInteger::Abs(D) < thisVal))       // divisor found
                return false;

            if (dCount == 20)
            {
                // check for square
                BigInteger root = thisVal.Sqrt();
                if (root * root == thisVal)
                    return false;
            }

            D = (BigInteger::Abs(D) + 2) * sign;
            sign = -sign;
        }
        dCount++;
    }

    Int64 Q = (1 - D) >> 2;

    BigInteger p_add1 = thisVal + 1;
    int s = 0;

    for (int index = 0; index < p_add1.dataLength; index++)
    {
        Uint mask = 0x01;

        for (int i = 0; i < 32; i++)
        {
            if ((p_add1.data[index] & mask) != 0)
            {
                index = p_add1.dataLength;      // to break the outer loop
                break;
            }
            mask <<= 1;
            s++;
        }
    }

    BigInteger t = p_add1 >> s;

    // calculate constant = b^(2k) / m
    // for Barrett Reduction
    BigInteger constant;

    int nLen = thisVal.dataLength << 1;
    constant.data[nLen] = 0x00000001;
    constant.dataLength = nLen + 1;

    constant = constant / thisVal;

    BigInteger* lucas = LucasSequenceHelper(1, Q, t, thisVal, constant, 0);
    bool isPrime = false;

    if ((lucas[0].dataLength == 1 && lucas[0].data[0] == 0) ||
            (lucas[1].dataLength == 1 && lucas[1].data[0] == 0))
    {
        // u(t) = 0 or V(t) = 0
        isPrime = true;
    }

    for (int i = 1; i < s; i++)
    {
        if (!isPrime)
        {
            // doubling of index
            lucas[1] = thisVal.BarrettReduction(lucas[1] * lucas[1], thisVal, constant);
            lucas[1] = (lucas[1] - (lucas[2] << 1)) % thisVal;

            //lucas[1] = ((lucas[1] * lucas[1]) - (lucas[2] << 1)) % thisVal;

            if ((lucas[1].dataLength == 1 && lucas[1].data[0] == 0))
                isPrime = true;
        }

        lucas[2] = thisVal.BarrettReduction(lucas[2] * lucas[2], thisVal, constant);     //Q^k
    }


    if (isPrime)     // additional checks for composite numbers
    {
        // If n is prime and gcd(n, Q) == 1, then
        // Q^((n+1)/2) = Q * Q^((n-1)/2) is congruent to (Q * J(Q, n)) mod n

        BigInteger g = thisVal.Gcd(Q);
        if (g.dataLength == 1 && g.data[0] == 1)         // gcd(this, Q) == 1
        {
            if ((lucas[2].data[BigIntegerMaxLength - 1] & 0x80000000) != 0)
                lucas[2] =lucas[2] + thisVal;

            BigInteger temp = (Q * BigInteger::Jacobi(Q, thisVal)) % thisVal;
            if ((temp.data[BigIntegerMaxLength - 1] & 0x80000000) != 0)
                temp = temp+thisVal;

            if (lucas[2] != temp)
                isPrime = false;
        }
    }

    if(lucas!=0)
    {
        delete []lucas;
    }

    return isPrime;

}

BigInteger BigInteger::Max(const BigInteger &bi)
{
    if (*this > bi)
        return BigInteger(*this);
    else
        return  BigInteger(bi);
}


BigInteger BigInteger::Min(const BigInteger &bi)
{
    if (*this < bi)
        return BigInteger(*this);
    else
        return  BigInteger(bi);
}

BigInteger BigInteger::Abs()
{
    if ((this->data[BigIntegerMaxLength - 1] & 0x80000000) != 0)
        return -(*this);
    else
        return  BigInteger(*this);
}



BigInteger BigInteger::ModPow(BigInteger exp, BigInteger n)
{
    if ((exp.data[BigIntegerMaxLength - 1] & 0x80000000) != 0)
    {
        //Exception::"Positive exponents only."
    }

    BigInteger resultNum = 1;
    BigInteger tempNum;
    bool thisNegative = false;

    if ((this->data[BigIntegerMaxLength - 1] & 0x80000000) != 0)   // negative this
    {
        tempNum = (-(*this)) % n;
        thisNegative = true;
    }
    else
        tempNum = (*this) % n;  // ensures (tempNum * tempNum) < b^(2k)

    if ((n.data[BigIntegerMaxLength - 1] & 0x80000000) != 0)   // negative n
        n = -n;

    // calculate constant = b^(2k) / m
    BigInteger constant;

    int i = n.dataLength << 1;
    constant.data[i] = 0x00000001;
    constant.dataLength = i + 1;

    constant = constant / n;
    int totalBits = exp.BitCount();
    int count = 0;

    // perform squaring and multiply exponentiation
    for (int pos = 0; pos < exp.dataLength; pos++)
    {
        Uint mask = 0x01;

        for (int index = 0; index < 32; index++)
        {
            if ((exp.data[pos] & mask) != 0)
                resultNum = BarrettReduction(resultNum * tempNum, n, constant);

            mask <<= 1;

            tempNum = BarrettReduction(tempNum * tempNum, n, constant);


            if (tempNum.dataLength == 1 && tempNum.data[0] == 1)
            {
                if (thisNegative && (exp.data[0] & 0x1) != 0)    //odd exp
                    return -resultNum;
                return resultNum;
            }
            count++;
            if (count == totalBits)
                break;
        }
    }

    if (thisNegative && (exp.data[0] & 0x1) != 0)    //odd exp
        return -resultNum;

    return resultNum;
}


BigInteger BigInteger::BarrettReduction(BigInteger x, BigInteger n, BigInteger constant)
{
    int k = n.dataLength,
        kPlusOne = k + 1,
        kMinusOne = k - 1;
    int i =0,j=0;
    BigInteger q1;

    // q1 = x / b^(k-1)
    for ( i = kMinusOne, j = 0; i < x.dataLength; i++, j++)
        q1.data[j] = x.data[i];
    q1.dataLength = x.dataLength - kMinusOne;
    if (q1.dataLength <= 0)
        q1.dataLength = 1;


    BigInteger q2 = q1 * constant;
    BigInteger q3;

    // q3 = q2 / b^(k+1)
    for (i = kPlusOne, j = 0; i < q2.dataLength; i++, j++)
        q3.data[j] = q2.data[i];
    q3.dataLength = q2.dataLength - kPlusOne;
    if (q3.dataLength <= 0)
        q3.dataLength = 1;


    // r1 = x mod b^(k+1)
    // i.e. keep the lowest (k+1) words
    BigInteger r1 ;
    int lengthToCopy = (x.dataLength > kPlusOne) ? kPlusOne : x.dataLength;
    for ( i = 0; i < lengthToCopy; i++)
        r1.data[i] = x.data[i];
    r1.dataLength = lengthToCopy;


    // r2 = (q3 * n) mod b^(k+1)
    // partial multiplication of q3 and n

    BigInteger r2;
    for ( i = 0; i < q3.dataLength; i++)
    {
        if (q3.data[i] == 0) continue;

        Uint64 mcarry = 0;
        int t = i;
        for (int j = 0; j < n.dataLength && t < kPlusOne; j++, t++)
        {
            // t = i + j
            Uint64 val = ((Uint64)q3.data[i] * (Uint64)n.data[j]) +
                         (Uint64)r2.data[t] + mcarry;

            r2.data[t] = (Uint)(val & 0xFFFFFFFF);
            mcarry = (val >> 32);
        }

        if (t < kPlusOne)
            r2.data[t] = (Uint)mcarry;
    }
    r2.dataLength = kPlusOne;
    while (r2.dataLength > 1 && r2.data[r2.dataLength - 1] == 0)
        r2.dataLength--;

    r1 -= r2;
    if ((r1.data[BigIntegerMaxLength - 1] & 0x80000000) != 0)        // negative
    {
        BigInteger val;
        val.data[kPlusOne] = 0x00000001;
        val.dataLength = kPlusOne + 1;
        r1 =r1+ val;
    }

    while (r1 >= n)
        r1 -= n;

    return r1;
}

BigInteger BigInteger::Gcd(const BigInteger &bi)
{
    BigInteger x;
    BigInteger y;

    if ((data[BigIntegerMaxLength - 1] & 0x80000000) != 0)     // negative
        x = -(*this);
    else
        x = *this;

    if ((bi.data[BigIntegerMaxLength - 1] & 0x80000000) != 0)     // negative
        y = -bi;
    else
        y = bi;

    BigInteger g = y;

    while (x.dataLength > 1 || (x.dataLength == 1 && x.data[0] != 0))
    {
        g = x;
        x = y % x;
        y = g;
    }

    return g;
}



void BigInteger::GenRandomBits(int bits,Random &random)
{
    int dwords = bits >> 5;
    int remBits = bits & 0x1F;
    int i = 0;
    if (remBits != 0)
        dwords++;

    if (dwords > BigIntegerMaxLength)
    {
        //Exception::"Number of required bits > maxLength."
    }

    for (i = 0; i < dwords; i++)
    {
        data[i]=random.NextUint();
    }

    for (i = dwords; i < BigIntegerMaxLength; i++)
        data[i] = 0;

    if (remBits != 0)
    {
        Uint mask = (Uint)(0x01 << (remBits - 1));
        data[dwords - 1] |= mask;

        mask = (Uint)(0xFFFFFFFF >> (32 - remBits));
        data[dwords - 1] &= mask;
    }
    else
        data[dwords - 1] |= 0x80000000;

    dataLength = dwords;

    if (dataLength == 0)
        dataLength = 1;
}


int BigInteger::BitCount()
{
    while (dataLength > 1 && data[dataLength - 1] == 0)
    {
        dataLength--;
    }

    Uint value = data[dataLength - 1];

    Uint mask = 0x80000000;

    int bits = 32;

    while (bits > 0 && (value & mask) == 0)
    {
        bits--;
        mask >>= 1;
    }

    bits += ((dataLength - 1) << 5);

    return bits;
}


bool BigInteger::FermatLittleTest(int confidence,Random &random)
{
    BigInteger thisVal;
    if ((this->data[BigIntegerMaxLength - 1] & 0x80000000) != 0)        // negative
        thisVal = -(*this);
    else
        thisVal = *this;

    if (thisVal.dataLength == 1)
    {
        // test small numbers
        if (thisVal.data[0] == 0 || thisVal.data[0] == 1)
            return false;
        else if (thisVal.data[0] == 2 || thisVal.data[0] == 3)
            return true;
    }

    if ((thisVal.data[0] & 0x1) == 0)     // even numbers
        return false;

    int bits = thisVal.BitCount();
    BigInteger a;
    BigInteger p_sub1 = thisVal - BigInteger(1);


    for (int round = 0; round < confidence; round++)
    {
        bool done = false;

        while (!done)		// generate a < n
        {
            int testBits = 0;

            // make sure "a" has at least 2 bits
            testBits=random.NextValue(2,bits-1);


            a.GenRandomBits(testBits,random);

            int byteLen = a.dataLength;

            // make sure "a" is not 0
            if (byteLen > 1 || (byteLen == 1 && a.data[0] != 1))
                done = true;
        }

        // check whether a factor exists (fix for version 1.03)
        BigInteger gcdTest = a.Gcd(thisVal);
        if (gcdTest.dataLength == 1 && gcdTest.data[0] != 1)
            return false;

        // calculate a^(p-1) mod p
        BigInteger expResult = a.ModPow(p_sub1, thisVal);

        int resultLen = expResult.dataLength;

        // is NOT prime is a^(p-1) mod p != 1

        if (resultLen > 1 || (resultLen == 1 && expResult.data[0] != 1))
        {
            return false;
        }
    }

    return true;
}




bool BigInteger::RabinMillerTest(int confidence,Random &random)
{
    BigInteger thisVal;
    if ((this->data[BigIntegerMaxLength - 1] & 0x80000000) != 0)        // negative
        thisVal = -(*this);
    else
        thisVal = *this;

    if (thisVal.dataLength == 1)
    {
        // test small numbers
        if (thisVal.data[0] == 0 || thisVal.data[0] == 1)
            return false;
        else if (thisVal.data[0] == 2 || thisVal.data[0] == 3)
            return true;
    }

    if ((thisVal.data[0] & 0x1) == 0)     // even numbers
        return false;


    // calculate values of s and t
    BigInteger p_sub1 = thisVal -  BigInteger(1);
    int s = 0;

    for (int index = 0; index < p_sub1.dataLength; index++)
    {
        Uint mask = 0x01;

        for (int i = 0; i < 32; i++)
        {
            if ((p_sub1.data[index] & mask) != 0)
            {
                index = p_sub1.dataLength;      // to break the outer loop
                break;
            }
            mask <<= 1;
            s++;
        }
    }

    BigInteger t = p_sub1 >> s;

    int bits = thisVal.BitCount();
    BigInteger a;

    for (int round = 0; round < confidence; round++)
    {
        bool done = false;

        while (!done)		// generate a < n
        {
            int testBits = 0;

            //make sure "a" has at least 2 bits

            testBits =  random.NextValue(2,bits-1);


            a.GenRandomBits(testBits,random);

            int byteLen = a.dataLength;

            // make sure "a" is not 0
            if (byteLen > 1 || (byteLen == 1 && a.data[0] != 1))
                done = true;
        }

        // check whether a factor exists (fix for version 1.03)
        BigInteger gcdTest = a.Gcd(thisVal);
        if (gcdTest.dataLength == 1 && gcdTest.data[0] != 1)
            return false;

        BigInteger b = a.ModPow(t, thisVal);

        bool result = false;

        if (b.dataLength == 1 && b.data[0] == 1)         // a^t mod p = 1
            result = true;

        for (int j = 0; result == false && j < s; j++)
        {
            if (b == p_sub1)         // a^((2^j)*t) mod p = p-1 for some 0 <= j <= s-1
            {
                result = true;
                break;
            }

            b = (b * b) % thisVal;
        }

        if (result == false)
            return false;
    }
    return true;
}


bool BigInteger::SolovayStrassenTest(int confidence,Random &random)
{
    BigInteger thisVal;
    if ((this->data[BigIntegerMaxLength - 1] & 0x80000000) != 0)        // negative
        thisVal = -(*this);
    else
        thisVal = (*this);

    if (thisVal.dataLength == 1)
    {
        // test small numbers
        if (thisVal.data[0] == 0 || thisVal.data[0] == 1)
            return false;
        else if (thisVal.data[0] == 2 || thisVal.data[0] == 3)
            return true;
    }

    if ((thisVal.data[0] & 0x1) == 0)     // even numbers
        return false;


    int bits = thisVal.BitCount();
    BigInteger a ;
    BigInteger p_sub1 = thisVal - 1;
    BigInteger p_sub1_shift = p_sub1 >> 1;

    //Random rand;

    for (int round = 0; round < confidence; round++)
    {
        bool done = false;

        while (!done)		// generate a < n
        {
            int testBits = 0;

            // make sure "a" has at least 2 bits

            testBits=random.NextValue(2,bits-1);


            a.GenRandomBits(testBits,random);

            int byteLen = a.dataLength;

            // make sure "a" is not 0
            if (byteLen > 1 || (byteLen == 1 && a.data[0] != 1))
                done = true;
        }

        // check whether a factor exists (fix for version 1.03)
        BigInteger gcdTest = a.Gcd(thisVal);
        if (gcdTest.dataLength == 1 && gcdTest.data[0] != 1)
            return false;

        // calculate a^((p-1)/2) mod p

        BigInteger expResult = a.ModPow(p_sub1_shift, thisVal);
        if (expResult == p_sub1)
            expResult = -1;

        // calculate Jacobi symbol
        BigInteger jacob = Jacobi(a, thisVal);

        // if they are different then it is not prime
        if (expResult != jacob)
            return false;
    }

    return true;
}


bool BigInteger::LucasStrongTest()
{
    BigInteger thisVal;
    if ((this->data[BigIntegerMaxLength - 1] & 0x80000000) != 0)        // negative
        thisVal = -(*this);
    else
        thisVal = *this;

    if (thisVal.dataLength == 1)
    {
        // test small numbers
        if (thisVal.data[0] == 0 || thisVal.data[0] == 1)
            return false;
        else if (thisVal.data[0] == 2 || thisVal.data[0] == 3)
            return true;
    }

    if ((thisVal.data[0] & 0x1) == 0)     // even numbers
        return false;

    return LucasStrongTestHelper(thisVal);
}

bool BigInteger::IsProbablePrime(int confidence,Random &random)
{
    BigInteger thisVal;
    if ((this->data[BigIntegerMaxLength - 1] & 0x80000000) != 0)        // negative
        thisVal = -(*this);
    else
        thisVal = *this;


    // test for divisibility by primes
    for (int p = 0; p < BigIntegerNumberPrimes; p++)
    {
        BigInteger divisor = Primes[p];

        if (divisor >= thisVal)
            break;

        BigInteger resultNum = thisVal % divisor;
        if (resultNum.IntValue() == 0)
        {
            return false;
        }
    }

    if (thisVal.RabinMillerTest(confidence,random))
    {
        return true;
    }
    else
    {
        return false;
    }
}


bool BigInteger::IsProbablePrime()
{
    BigInteger thisVal;
    if ((this->data[BigIntegerMaxLength - 1] & 0x80000000) != 0)        // negative
        thisVal = -(*this);
    else
        thisVal = (*this);

    if (thisVal.dataLength == 1)
    {
        // test small numbers
        if (thisVal.data[0] == 0 || thisVal.data[0] == 1)
            return false;
        else if (thisVal.data[0] == 2 || thisVal.data[0] == 3)
            return true;
    }

    if ((thisVal.data[0] & 0x1) == 0)     // even numbers
        return false;


    // test for divisibility by primes < 2000
    for (int p = 0; p <BigIntegerNumberPrimes; p++)
    {
        BigInteger divisor = Primes[p];

        if (divisor >= thisVal)
            break;

        BigInteger resultNum = thisVal % divisor;
        if (resultNum.IntValue() == 0)
        {
            return false;
        }
    }

    // Perform BASE 2 Rabin-Miller Test

    // calculate values of s and t
    BigInteger p_sub1 = thisVal - BigInteger(1);
    int s = 0;

    for (int index = 0; index < p_sub1.dataLength; index++)
    {
        Uint mask = 0x01;

        for (int i = 0; i < 32; i++)
        {
            if ((p_sub1.data[index] & mask) != 0)
            {
                index = p_sub1.dataLength;      // to break the outer loop
                break;
            }
            mask <<= 1;
            s++;
        }
    }

    BigInteger t = p_sub1 >> s;

    //int bits = thisVal.BitCount();
    BigInteger a = 2;

    // b = a^t mod p
    BigInteger b = a.ModPow(t, thisVal);
    bool result = false;

    if (b.dataLength == 1 && b.data[0] == 1)         // a^t mod p = 1
        result = true;

    for (int j = 0; result == false && j < s; j++)
    {
        if (b == p_sub1)         // a^((2^j)*t) mod p = p-1 for some 0 <= j <= s-1
        {
            result = true;
            break;
        }

        b = (b * b) % thisVal;
    }

    // if number is strong pseudoprime to base 2, then do a strong lucas test
    if (result)
        result = LucasStrongTestHelper(thisVal);

    return result;
}


int BigInteger::IntValue()
{
    return (int)data[0];
}


Uint64 BigInteger::LongValue()
{
    Uint64 val = 0;

    val = (Uint64)data[0];

    val |= (Uint64)data[1] << 32;


    return val;
}


BigInteger BigInteger::GenCoPrime(int bits, Random &rand)
{
    bool done = false;
    BigInteger result;

    while (!done)
    {
        result.GenRandomBits(bits, rand);

        // gcd test
        BigInteger g = result.Gcd(*this);
        if (g.dataLength == 1 && g.data[0] == 1)
            done = true;
    }

    return result;
}


BigInteger BigInteger::ModInverse(BigInteger modulus)
{
    BigInteger p[2] = { BigInteger(), BigInteger(1) };
    BigInteger q[2]= {0,0};   // quotients
    BigInteger r[2] = {BigInteger(),BigInteger() };             // remainders

    int step = 0;

    BigInteger a = modulus;
    BigInteger b = *this;

    while (b.dataLength > 1 || (b.dataLength == 1 && b.data[0] != 0))
    {
        BigInteger quotient;
        BigInteger remainder;

        if (step > 1)
        {
            BigInteger pval = (p[0] - (p[1] * q[0])) % modulus;
            p[0] = p[1];
            p[1] = pval;
        }

        if (b.dataLength == 1)
            SingleByteDivide(a, b, quotient, remainder);
        else
            MultiByteDivide(a, b, quotient, remainder);

        q[0] = q[1];
        r[0] = r[1];
        q[1] = quotient;
        r[1] = remainder;

        a = b;
        b = remainder;

        step++;
    }

    if (r[0].dataLength > 1 || (r[0].dataLength == 1 && r[0].data[0] != 1))
    {
        //Exception::"No inverse!"
    }

    BigInteger result = ((p[0] - (p[1] * q[0])) % modulus);

    if ((result.data[BigIntegerMaxLength - 1] & 0x80000000) != 0)
        result =result+ modulus;  // get the least positive modulus

    return result;
}


/*Byte* BigInteger::GetBytes()
{
	int numBytes = dataLength << 2;
    int i=0;

	Byte* result = new Byte[numBytes];
    for(i=0;i<numBytes;i++)
	{
	    result[i]=0;
	}

	int pos = 0;
	Uint val = 0;

	for ( i = dataLength -1; i >= 0; i--, pos += 4)
	{
		val = data[i];
		result[pos + 3] = (Byte)(val & 0xFF);
		val >>= 8;
		result[pos + 2] = (Byte)(val & 0xFF);
		val >>= 8;
		result[pos + 1] = (Byte)(val & 0xFF);
		val >>= 8;
		result[pos] = (Byte)(val & 0xFF);
	}

	return result;
}
*/

int BigInteger::GetBytes(Byte result[],int orgLength)
{
    int numBytes = dataLength << 2;
    int i=0;

    if(orgLength<numBytes)
    {
        return -1;
    }

    for(i=0; i<orgLength; i++)
    {
        result[i]=0;
    }

    int pos = 0;
    Uint val = 0;

    for ( i = dataLength -1; i >= 0; i--, pos += 4)
    {
        val = data[i];
        result[pos + 3] = (Byte)(val & 0xFF);
        val >>= 8;
        result[pos + 2] = (Byte)(val & 0xFF);
        val >>= 8;
        result[pos + 1] = (Byte)(val & 0xFF);
        val >>= 8;
        result[pos] = (Byte)(val & 0xFF);
    }

    return numBytes;
}


/*
Byte* BigInteger::GetBytesRemovedZero()
{
	int numBits = BitCount();
    int i=0;
    int numBytes = numBits >> 3;

	if ((numBits & 0x7) != 0)
        numBytes++;

	Byte* result = new Byte[numBytes];

for(i=0;i<numBytes;i++)
{
   result[i]=0;
}

    int pos = 0;

	Uint val = data[dataLength - 1];
    bool isHaveData = false;

    Uint tempVal = (val >> 24 & 0xFF);
            if (tempVal != 0)
            {
                result[pos++] = (Byte)tempVal;
                isHaveData = true;
            }
            tempVal = (val >> 16 & 0xFF);
            if (isHaveData || tempVal != 0)
            {
                result[pos++] = (Byte)tempVal;
                isHaveData = true;
            }
            tempVal = (val >> 8 & 0xFF);
            if (isHaveData || tempVal != 0)
            {
                result[pos++] = (Byte)tempVal;
                isHaveData = true;
            }
            tempVal = (val & 0xFF);
            if (isHaveData || tempVal != 0)
            {
                result[pos++] = (Byte)tempVal;
            }

            for ( i = dataLength - 2; i >= 0; i--, pos += 4)
            {
                val = data[i];
                result[pos + 3] = (Byte)(val & 0xFF);
                val >>= 8;
                result[pos + 2] = (Byte)(val & 0xFF);
                val >>= 8;
                result[pos + 1] = (Byte)(val & 0xFF);
                val >>= 8;
                result[pos] = (Byte)(val & 0xFF);
            }

            return result;
}
*/

int BigInteger::GetBytesRemovedZero(Byte result[],int orgLength)
{
    int numBits = BitCount();
    int i=0;
    int numBytes = numBits >> 3;

    if ((numBits & 0x7) != 0)
        numBytes++;

    if(orgLength<numBytes)
    {
        return -1;
    }

    for(i=0; i<orgLength; i++)
    {
        result[i]=0;
    }

    int pos = 0;

    Uint val = data[dataLength - 1];
    bool isHaveData = false;

    Uint tempVal = (val >> 24 & 0xFF);
    if (tempVal != 0)
    {
        result[pos++] = (Byte)tempVal;
        isHaveData = true;
    }
    tempVal = (val >> 16 & 0xFF);
    if (isHaveData || tempVal != 0)
    {
        result[pos++] = (Byte)tempVal;
        isHaveData = true;
    }
    tempVal = (val >> 8 & 0xFF);
    if (isHaveData || tempVal != 0)
    {
        result[pos++] = (Byte)tempVal;
        isHaveData = true;
    }
    tempVal = (val & 0xFF);
    if (isHaveData || tempVal != 0)
    {
        result[pos++] = (Byte)tempVal;
    }

    for ( i = dataLength - 2; i >= 0; i--, pos += 4)
    {
        val = data[i];
        result[pos + 3] = (Byte)(val & 0xFF);
        val >>= 8;
        result[pos + 2] = (Byte)(val & 0xFF);
        val >>= 8;
        result[pos + 1] = (Byte)(val & 0xFF);
        val >>= 8;
        result[pos] = (Byte)(val & 0xFF);
    }

    return numBytes;
}

void BigInteger::SetBit(Uint bitNum)
{
    Uint bytePos = bitNum >> 5;             // divide by 32
    char bitPos = (char)(bitNum & 0x1F);    // get the lowest 5 bits

    Uint mask = (Uint)1 << bitPos;
    this->data[bytePos] |= mask;

    if (bytePos >= (Uint)this->dataLength)
    {
        this->dataLength = (int)bytePos + 1;
    }
}

void BigInteger::UnsetBit(Uint bitNum)
{
    Uint bytePos = bitNum >> 5;

    if (bytePos < (Uint)this->dataLength)
    {
        char bitPos = (char)(bitNum & 0x1F);

        Uint mask = (  Uint)1 << bitPos;
        Uint mask2 = 0xFFFFFFFF ^ mask;

        this->data[bytePos] &= mask2;

        if (this->dataLength > 1 && this->data[this->dataLength - 1] == 0)
            this->dataLength--;
    }
}


BigInteger BigInteger::Sqrt()
{
    Uint numBits = (Uint)BitCount();

    if ((numBits & 0x1) != 0)        // odd number of bits
        numBits = (numBits >> 1) + 1;
    else
        numBits = (numBits >> 1);

    Uint bytePos = numBits >> 5;
    char bitPos = (char)(numBits & 0x1F);

    Uint mask;

    BigInteger result;
    if (bitPos == 0)
        mask = 0x80000000;
    else
    {
        mask = (Uint)1 << bitPos;
        bytePos++;
    }
    result.dataLength = (int)bytePos;

    for (int i = (int)bytePos - 1; i >= 0; i--)
    {
        while (mask != 0)
        {
            // guess
            result.data[i] ^= mask;

            // undo the guess if its square is larger than this
            if ((result * result) > *this)
                result.data[i] ^= mask;

            mask >>= 1;
        }
        mask = 0x80000000;
    }
    return result;
}

Int64 BigInteger::Abs(Int64 value)
{
    if(value<0)
    {
        return -value;
    }
    else
    {
        return value;
    }
}

