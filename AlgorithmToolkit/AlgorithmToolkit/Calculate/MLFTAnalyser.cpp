// MLFTAnalyser.cpp: implementation of the MLFTAnalyser class.
//
//////////////////////////////////////////////////////////////////////

#include "MLFTAnalyser.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

MLFTAnalyser::MLFTAnalyser(Array<Array<int>*>* optionsIndexArray,Array<Array<double>*>* optionsSpArray,double coefficient)
{
    this->optionsIndexArray=optionsIndexArray;
	this->optionsSpArray=optionsSpArray;
	this->coefficient=coefficient;
	this->init();
}

MLFTAnalyser::~MLFTAnalyser()
{
   int i=0;

   if(codeArray!=0)
   {
	   int caLen=codeArray->GetLength();
	   for(i=0;i<caLen;i++)
	   {
	       delete *(*codeArray)[i];
	   }
	   delete codeArray;
   }

   if(this->fcArray!=0)
   {
      delete this->fcArray;
   }

   if(fullOptionLenArray!=0)
   {
       delete fullOptionLenArray;
   }

   if(gameTypeOptionLenArray!=0)
   {
      delete gameTypeOptionLenArray;
   }
}

void MLFTAnalyser::init()
{
	this->gameTypeOptionLenArray=0;
    this->fcArray=0;
	codeLen=40;
    codeArray=new Array<Array<int>*>(5);
	int temp1[]={0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2};
	*(*codeArray)[0]=new Array<int>(temp1,codeLen);

	int temp2[]={0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 31, 32, 33, 31, 32, 33};
	*(*codeArray)[1]=new Array<int>(temp2,codeLen);

	int temp3[]={7, 1, 2, 3, 3, 4, 5, 4, 5, 6, 5, 6, 7, 7, 0, 2, 4, 6, 7, 1, 2, 3, 3, 4, 5, 4, 5, 6, 5, 6, 7, 8, 0, 8, 8, 0, 8, 8, 0, 8};
	*(*codeArray)[2]=new Array<int>(temp3,codeLen);

	 int temp4[]={9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 10, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 0, 1, 2, 3, 4, 5, 6, 7, 8};
	*(*codeArray)[3]=new Array<int>(temp4,codeLen);

	int temp5[]={ 1000, 1, 2, 1, 3, 2, 1, 4, 3, 2, 5, 4, 3, 0, 0, 0, 0, 0, -1000, -1, -2, -1, -3, -2, -1, -4, -3, -2, -5, -4, -3};
	this->fcArray=new Array<int>(temp5,31);

	*(*codeArray)[4]=setRQSPFIndexArray();

	//128,122,123,124,121
	char olArray[]={3,31,8,9,3};

	fullOptionLenArray=new Array<char>(olArray,5);


}


Array<int>* MLFTAnalyser::setRQSPFIndexArray()
{
	int fcLen=fcArray->GetLength();
	int* fcs=fcArray->GetArray();
    int* rqspfCodeArray=new int[codeLen];
	int i = 0;
        for (i = 0; i < fcLen; i++)
            {
                if (fcs[i] == 1000)
                {
                    if (coefficient < -0.0001)
                    {
                        rqspfCodeArray[i] = 3;
                    }
                    else
                    {
                       rqspfCodeArray[i] = 0;
                    }
                    continue;
                }
                if (fcs[i] == -1000)
                {
                    if (coefficient > 0.0001)
                    {
                        rqspfCodeArray[i] = 4;
                    }
                    else
                    {
                        rqspfCodeArray[i] = 2;
                    }
                    continue;
                }


                if (fcs[i] + coefficient > 0.0001)
                {
                    rqspfCodeArray[i] = 0;
                }
                else if (fcs[i] + coefficient <-0.0001)
                {
                    rqspfCodeArray[i] = 2;
                }
                else
                {
                    rqspfCodeArray[i] = 1;
                }
            }
            int* rqspfCodesPlus31=rqspfCodeArray+31;
            for (i = 0; i < 9; i++)
            {
                if (i % 3 == 0)
                {
                    if (coefficient < -0.0001)
                    {
                        rqspfCodesPlus31[i] = 3;
                    }
                    else
                    {
                        rqspfCodesPlus31[i] = 0;
                    }
                } if (i % 3 == 1)
                {
                    if (coefficient > 0.0001)
                    {
                       rqspfCodesPlus31[i] = 0;
                    } if (coefficient <-0.0001)
                    {
                        rqspfCodesPlus31[i] = 2;
                    }
                    else
                    {
                       rqspfCodesPlus31[i] = 1;
                    }
                }
                else
                {
                    if (coefficient > 0.0001)
                    {
                        rqspfCodesPlus31[i] = 4;
                    }
                    else
                    {
                        rqspfCodesPlus31[i] = 2;
                    }
                }
            }

			Array<int>* rqspfCodes=new Array<int>();
			rqspfCodes->Set(rqspfCodeArray,codeLen);
			return rqspfCodes;
}


Array<Array<double>*>* MLFTAnalyser::initMaxMinData(bool isMax)
{
            Array<double>** valuesArray= new Array<double>*[5];

            int valuesLenArray[] =  { 3, 34, 9, 12,5 };

			Array<int>* oiArray=0;
			int* intArray=0;
			int oiLen=0;
		    Array<double>* spArray=0;
			int spLen=0;
			double* sps=0;
			int n = 0;
				int ivLen=0;
				 int oIndex=0;
            for (int i = 0; i < 5; i++)
            {
				valuesArray[i]=0;
				ivLen=valuesLenArray[i];
                double* ivArray=new double[ivLen];
				for(n=0;n<ivLen;n++)
				{
				    ivArray[n]=0;
				}
				Array<double>* temp=new Array<double>();
				temp->Set(ivArray,ivLen);
				valuesArray[i]=temp;

                oiArray=*(*optionsIndexArray)[i];
				spArray=*(*optionsSpArray)[i];
				if(oiArray==0||spArray==0)
				{
				   continue;
				}

                oiLen=oiArray->GetLength();
				spLen=spArray->GetLength();

                if (oiLen < 0||spLen<0||spLen!=oiLen||oiLen>ivLen)
                {
                    continue;
                }
				intArray=oiArray->GetArray();
				sps=spArray->GetArray();
                for ( n = 0; n < oiLen; n++)
                {
                   ivArray[intArray[n]] = sps[n];
                }

                if (isMax)
                {
                    switch (i)
                    {
                        case 4:
                           ivArray[3] = ivArray[0] > ivArray[1] ? ivArray[0] : ivArray[1];
                           ivArray[4] = ivArray[1] > ivArray[2] ? ivArray[1] :ivArray[2];
                            break;
                        case 3:
                            for ( n = 0; n < 9; n++)
                            {
                                 oIndex = n % 3;
                                if (ivArray[oIndex + 9] < ivArray[n])
                                {
                                    ivArray[oIndex + 9] = ivArray[n];
                                }
                            }
                            break;
                    }
                }
                else
                {
                    if (i != 0)
                    {
                        for ( n = 0; n < ivLen; n++)
                        {
                            if (ivArray[n] < 1)
                            {
                                ivArray[n] = MLAnalyserMaxMinValue;
                            }
                        }
                    }
                    switch (i)
                    {
                        case 4:
                            ivArray[3] = ivArray[0] < ivArray[1] ? ivArray[0] : ivArray[1];
                            ivArray[4] = ivArray[1] < ivArray[2] ? ivArray[1] : ivArray[2];
                            break;
                        case 1:
                            for ( n = 0; n < 31; n++)
                            {
                                if (n < 13)
                                {
                                    if (ivArray[31] > ivArray[n])
                                    {
                                        ivArray[31] = ivArray[n];
                                    }
                                }
                                else if (n > 17)
                                {
                                    if (ivArray[33] > ivArray[n])
                                    {
                                        ivArray[33] = ivArray[n];
                                    }
                                }
                                else
                                {
                                    if (ivArray[32] > ivArray[n])
                                    {
                                        ivArray[32] = ivArray[n];
                                    }
                                }
                            }
                            break;
                        case 2:
                            for (n = 1; n < 8; n++)
                            {
                                if (ivArray[8] > ivArray[n])
                                {
                                    ivArray[8] = ivArray[n];
                                }
                            }
                            break;
                        case 3:
                            for ( n = 0; n < 9; n++)
                            {
                                 oIndex = n % 3;
                                if (ivArray[oIndex + 9] > ivArray[n])
                                {
                                    ivArray[oIndex + 9] = ivArray[n];
                                }
                            }
                            break;
                    }

                    for ( n = 0; n < ivLen; n++)
                    {
                        if (ivArray[n] >= MLAnalyserMaxMinValue)
                        {
                            ivArray[n] = 0;
                        }
                    }


                }

            }
			Array<Array<double>*>* reValue=new Array<Array<double>*>();
			reValue->Set(valuesArray,5);
			return reValue;
}


bool MLFTAnalyser::IsHadAllOption()
{
    int flaLen=this->fullOptionLenArray->GetLength();
	char* folArray=this->fullOptionLenArray->GetArray();
	for(int i=0;i<flaLen;i++)
	{
	    Array<int>* innerOptionsIndexArray=*(*optionsIndexArray)[i];
        if(innerOptionsIndexArray==0)
		{
		   continue;
		}
		if(innerOptionsIndexArray->GetLength()==folArray[i])
		{
		   return true;
		}
	}
	return false;
}


int MLFTAnalyser::GetGameTypeLen()
{
	if(this->optionsIndexArray==0)
	{
	   return 0;
	}
	int oiaLen=optionsIndexArray->GetLength();
   int reLen=0;
    for(int i=0;i<oiaLen;i++)
	{
	     Array<int>* innerOptionsIndexArray=*(*optionsIndexArray)[i];
        if(innerOptionsIndexArray!=0&&innerOptionsIndexArray->GetLength()>0)
		{
		   reLen++;
		}
	}
	return reLen;
}

double MLFTAnalyser::GetMaxComSp()
{
	 Array<Array<double>*>* valuesArray=this->initMaxMinData(true);
     double max = 0;
     int codeLen =31;
	 int j = 0;
	 int* codes=0;
	 double* vaArray=0;
	 Array<double>* dArray=0;
     for (int i = 0; i < codeLen; i++)
     {
                double temp = 0;

                for (j = 0; j < 5; j++)
                {
					codes=(*(*codeArray)[j])->GetArray();
					dArray=*(*valuesArray)[j];
					if(dArray==0)
					{
					   continue;
					}
					vaArray=dArray->GetArray();
                    temp += vaArray[codes[i]];
                }
                if (max < temp)
                {
                    max = temp;
                }
      }

	  int len=valuesArray->GetLength();
			for(j=0;j<len;j++)
			{
			    	dArray=*(*valuesArray)[j];
					if(dArray!=0)
					{
					   delete dArray;
					}
			}
			delete valuesArray;
      return max;
}

double MLFTAnalyser::GetMinComSp()
{
   Array<Array<double>*>*  valuesArray=this->initMaxMinData(false);
   double min = MLAnalyserMaxMinValue;
    int j = 0;
	int* codes=0;
	double* vaArray=0;
	 Array<double>* dArray=0;
            for (int i = 0; i < codeLen; i++)
            {
                double temp = 0;
                for (j = 0; j < 5; j++)
                {
					codes=(*(*codeArray)[j])->GetArray();
					dArray=*(*valuesArray)[j];
					if(dArray==0)
					{
					   continue;
					}
					vaArray=dArray->GetArray();
                    temp += vaArray[codes[i]];
                }
                if (temp > 1 && min > temp)
                {
                    min = temp;
                }
            }
            if (min >= MLAnalyserMaxMinValue)
            {
                min = -1;
            }
			int len=valuesArray->GetLength();
			for(j=0;j<len;j++)
			{
			    	dArray=*(*valuesArray)[j];
					if(dArray!=0)
					{
					   delete dArray;
					}
			}
			delete valuesArray;
            return min;
}


Array<int>* MLFTAnalyser::GetGameTypeOptionLenArray()
{
	if(this->gameTypeOptionLenArray!=0)
	{
	   return this->gameTypeOptionLenArray;
	}
    if(this->optionsIndexArray==0)
	{
	   return 0;
	}
	int oiaLen=optionsIndexArray->GetLength();
	  List<int> list;
    for(int i=0;i<oiaLen;i++)
	{
	     Array<int>* innerOptionsIndexArray=*(*optionsIndexArray)[i];
        if(innerOptionsIndexArray!=0&&innerOptionsIndexArray->GetLength()>0)
		{
		   list.Add(innerOptionsIndexArray->GetLength());
		}
	}
	gameTypeOptionLenArray= list.ToArray();
	return gameTypeOptionLenArray;
}
