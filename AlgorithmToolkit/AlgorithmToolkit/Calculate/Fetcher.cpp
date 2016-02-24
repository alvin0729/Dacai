// Fetcher.cpp: implementation of the Fetcher class.
//
//////////////////////////////////////////////////////////////////////

#include "Fetcher.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////


Fetcher::Fetcher(unsigned char* fieldsLenCountArray ,int arrayLen, int numbers)
{
   this->fieldsLenCountArray=fieldsLenCountArray;
   this->arrayLen=arrayLen;
   this->numbers=numbers;
}

Fetcher::~Fetcher()
{

}


List<unsigned char*>  Fetcher::Calculate()
{
            List<unsigned char*> reList;
            if (numbers == 0 ||fieldsLenCountArray==0|| arrayLen < 1)
            {
                return reList;
            }
            int i=0;
            unsigned char* temp = new unsigned char[arrayLen];
			for(;i<arrayLen;i++)
			{
			   temp[i]=0;
			}

            int maxIndex = arrayLen- 1;
            int index = maxIndex;
            int c = 0;
            while (index > -1 && index <= maxIndex)
            {
                c += temp[index];
                if (c == numbers)
                {
				    unsigned char* t = new unsigned char[arrayLen];
                    for(i=0;i<=index;i++)
					{
					  t[i]=temp[i];
					}
					for(;i<arrayLen;i++)
					{
					  t[i]=0;
					}
                    reList.Add(t);
                    c -= temp[index];
                    temp[index] = 0;
                    if (index == 0)
                    {
                        break;
                    }
                    for (index = index - 1; index > -1; index--)
                    {
                        c -= temp[index];
                        if (temp[index] < fieldsLenCountArray[index])
                        {
                            temp[index]++;
                            index--;
                            break;
                        }
                        else
                        {
                            if (index == 0)
                            {
                                index = -2;
                            }
                            else
                            {
                                temp[index] = 0;
                            }
                        }
                    }

                }
                index++;
                if (index > maxIndex)
                {
                    for (index = maxIndex; index > -1; index--)
                    {
                        c -= temp[index];
                        if (temp[index] < fieldsLenCountArray[index])
                        {
                            temp[index]++;
                            break;
                        }
                        else
                        {
                            if (index == 0)
                            {
                                index = -2;
                            }
                            else
                            {
                                temp[index] = 0;
                            }
                        }
                    }
                }
            }

			delete [] temp;
            return reList;
}
