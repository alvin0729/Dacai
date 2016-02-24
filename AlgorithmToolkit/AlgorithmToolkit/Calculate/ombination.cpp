// ombination.cpp: implementation of the Combination class.
//
//////////////////////////////////////////////////////////////////////

#include "ombination.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

Combination::Combination()
{

}

Combination::~Combination()
{

}

int Combination::GetInt32(int n,int m)
{
     if (n < 1 || m < 1)
            {
               return -1;
            }
            if (n < m)
            {
                return -1;
            }

            if (n == m)
            {
                return 1;
            }

            if (n - m < m)
            {
                m = n - m;
            }

            int result = 1;
            for (int multiIndex = n, divideIndex = 1; multiIndex > n - m && divideIndex <= m; multiIndex--, divideIndex++)
            {
                result *= multiIndex;
                result /= divideIndex;

                if (result < 0)
                {
                    return -2;
                }
            }

            return result;
}

Int64 Combination::GetInt64(int n,int m)
{
 if (n < 1 || m < 1)
            {
                return -1;
            }
            if (n < m)
            {
              return -1;
            }

            if (n == m)
            {
                return 1;
            }

            if (n - m < m)
            {
                m = n - m;
            }

            Int64 result = 1;
            for (int multiIndex = n, divideIndex = 1; multiIndex > n - m && divideIndex <= m; multiIndex--, divideIndex++)
            {
                result *= multiIndex;
                result /= divideIndex;

                if (result < 0)
                {
                 return -2;
                }
            }
            return result;
}


int Combination::GetInt32(unsigned char n,unsigned char m)
{
	return Combination::GetInt32((int)n,(int)m);
}

Int64 Combination::GetInt64(unsigned char n,unsigned char m)
{
	return Combination::GetInt64((int)n,(int)m);
}

Array<Array<unsigned char>*>* Combination::GetIndexes(unsigned char n,unsigned char m)
{
if (n < 0 || n < m || m < 0)
            {
                return new Array<Array<unsigned char>*>(0,0);
            }

            if (n == 0 || m == 0)
            {
               return new Array<Array<unsigned char>*>(0,0);
            }

			int i=0;
            unsigned char* temp1 = new  unsigned char[m];
            unsigned char* temp2 = new  unsigned char[m];
            for ( i = m - 1; i > -1; i--)
            {
                temp1[i] = i;
                temp2[i] = i + (n - m);
            }

            int p = 0;
            Array<unsigned char>** reArray = new Array<unsigned char>*[GetInt32(n, m)];
            int maxIndex = m - 1;
            int index = maxIndex;
            unsigned char* cache=new unsigned char[m];
            while (index > -1)
            {
                if (index == maxIndex)
                {
                    for (int j = 0; j < m; j++)
                    {
                        cache[j] = temp1[j];
                    }
                    reArray[p]=new Array<unsigned char>(cache,m);
                    p++;
                }
                if (temp2[index] > temp1[index])
                {
                    temp1[index]++;
                    while (index < maxIndex)
                    {
                        temp1[index + 1] = (unsigned int)(temp1[index] + 1);
                        index++;
                    }
                }
                else if (temp2[index] == temp1[index])
                {
                    index--;
                    continue;
                }
            }
			delete[] temp1;
			delete[] temp2;
			delete[] cache;
			Array<Array<unsigned char>*>* reValue=new Array<Array<unsigned char>*>();
	    	reValue->Set(reArray,p);
            return reValue;
}

Array<Array<int>*>* Combination::GetIndexes(int n,int m)
{
       if (n < 0 || n < m || m < 0)
            {
                return new Array<Array<int>*>(0,0);
            }

            if (n == 0 || m == 0)
            {
               return new Array<Array<int>*>(0,0);
            }

			int i=0;
            int* temp1 = new  int[m];
            int* temp2 = new  int[m];
            for ( i = m - 1; i > -1; i--)
            {
                temp1[i] = i;
                temp2[i] = i + (n - m);
            }

            int p = 0;
            Array<int>** reArray = new Array<int>*[GetInt32(n, m)];
            int maxIndex = m - 1;
            int index = maxIndex;
            int* cache=new int[m];
            while (index > -1)
            {
                if (index == maxIndex)
                {
                    for (int j = 0; j < m; j++)
                    {
                        cache[j] = temp1[j];
                    }
                    reArray[p]=new Array<int>(cache,m);
                    p++;
                }
                if (temp2[index] > temp1[index])
                {
                    temp1[index]++;
                    while (index < maxIndex)
                    {
                        temp1[index + 1] = temp1[index] + 1;
                        index++;
                    }
                }
                else if (temp2[index] == temp1[index])
                {
                    index--;
                    continue;
                }
            }
            delete[] temp1;
			delete[] temp2;
			delete[] cache;
			Array<Array<int>*>* reValue=new Array<Array<int>*>();
			reValue->Set(reArray,p);
            return reValue;
}


Array<Array<unsigned char>*>* Combination::GetMultiCombineIndexes(int* countArray,int caLen)
{
            int all = 1;
			int i = 0;
            for ( ;i <caLen; i++)
            {
                all *= countArray[i];
            }

            Array<Array<unsigned char>*>* result = new Array<Array<unsigned char>*>(all);
            for ( i = 0; i < all; i++)
            {
                *(*result)[i] = new Array<unsigned char>(caLen);
            }
            int r = 1;
            int p = 0;
            int c = 0;
            int n = 0;
            for ( i = 0; i < caLen; i++)
            {
                p = 0;
                c = 0;
                n = 0;
                while (p < all)
                {
                    c = 0;

                    while (c < r)
                    {
                        *(*(*(*result)[p]))[i] = n;
                        c++;
                        p++;
                    }
                    n++;
                    if (n >= countArray[i])
                    {
                        n = 0;
                    }
                }
                r *= countArray[i];
            }
            return result;
}
