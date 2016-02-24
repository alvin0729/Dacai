// MaxBonusCalculater.cpp: implementation of the MaxBonusCalculater class.
//
//////////////////////////////////////////////////////////////////////

#include "MaxBonusCalculater.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

MaxBonusCalculater::MaxBonusCalculater(Array<PassMode*>* passModes,Array<double>* spArray,Array<int>* gallIndexArray,Array<int>* dragIndexArray,Array<int>* gallRangeArray)
{
    this->passModes=passModes;
	this->spArray=spArray;
	this->gallIndexArray=gallIndexArray;
	this->dragIndexArray=dragIndexArray;
	this->gallRangeArray=gallRangeArray;
}

MaxBonusCalculater::~MaxBonusCalculater()
{

}


double MaxBonusCalculater::Calculate()
{
	if(passModes==0)
	{
	   return 0;
	}

    double sum = 0;

	     int pmLen=passModes->GetLength();
		 PassMode** passModeArray=passModes->GetArray();

	    int pass=0;
		int giaLen=0;
		if(gallIndexArray!=0)
		{
		    giaLen=gallIndexArray->GetLength();
		}
		int diaLen=0;
		if(dragIndexArray!=0)
		{
			diaLen=dragIndexArray->GetLength();
		}
        int allFields=giaLen+diaLen;
		int graLen=0;
		int gallCount=0;
		if(gallRangeArray!=0)
		{
		     graLen=gallRangeArray->GetLength();
        }
		for(int pmIndex=0;pmIndex<pmLen;pmIndex++)
		{
			 PassMode* passMode=passModeArray[pmIndex];
            pass=passMode->GetPass();
            if (pass>allFields)
            {
                  continue;
			}
            if(graLen>0)
			{
                for(int graIndex=0;graIndex<graLen;graIndex++)
                {
					gallCount=*(*gallRangeArray)[graIndex];
					if(gallCount>pass)
					{
					    continue;
					}
					if(pass>gallCount+diaLen)
					{
					    continue;
					}
					sum+=CalculateByGall(passMode,gallCount,gallIndexArray->GetArray(),giaLen,dragIndexArray->GetArray(),diaLen);
                }
            }else
			{
				if(pass>diaLen)
				{
				   continue;
				}
			     sum+=CalculateByGall(passMode,0,0,0,dragIndexArray->GetArray(),diaLen);
			}
		 }
      return sum;
}


double MaxBonusCalculater::CalculateByGall(PassMode* passMode,int gallCount,int* giaArray,int giaLen,int* diaArray,int diaLen)
{
    int pass=passMode->GetPass();
	int mode=passMode->GetMode();
	int i=0;
	int n = 0;
    int fetchDrag=0;
	Array<Array<int>*>* gallIndexesArray = 0;

	if (gallCount > 0)
	{
		gallIndexesArray = Combination::GetIndexes(giaLen, gallCount);

	}
    if (pass>diaLen+gallCount)
	{
		return 0;
	}
	fetchDrag=pass-gallCount;

	double sum=0;

	Array<Array<int>*>* dragIndexesArray = 0;
	if(fetchDrag>0)
	{
		dragIndexesArray = Combination::GetIndexes(diaLen, fetchDrag);
	}
	Array<int>* gis=0;
    Array<Array<int>*>* onlyIndexesArray=0;
	int* intIndexArray=0;
	if(gallCount==0||fetchDrag==0)
	{
	    if(fetchDrag!=0)
		{
		    onlyIndexesArray=dragIndexesArray;
			intIndexArray=dragIndexArray->GetArray();
		}
		if(gallCount!=0)
		{
		    onlyIndexesArray=gallIndexesArray;
		    intIndexArray=gallIndexArray->GetArray();
		}
	}
   int* indexArray = new int[pass];
   Array<int>* intArray=0;
   int iaLen=0;
    Array<Array<unsigned char>*>* indexes = passMode->GetIndexes();
	unsigned char* pmiaArray=0;
    int pmIXLen=indexes->GetLength();
    int pmiaLen=0;
	double* sps=spArray->GetArray();
    if(onlyIndexesArray!=0)
	{
		int oiaLen=onlyIndexesArray->GetLength();
	    for (i = 0; i <oiaLen ; i++)
        {
			intArray=*(*onlyIndexesArray)[i];
			iaLen=intArray->GetLength();
			for (n = 0; n < iaLen; n++)
			{
				indexArray[n] = intIndexArray[*(*intArray)[n]];
			}
            delete intArray;
			for (n = 0; n < pmIXLen; n++)
			{
				double temp = 1;
				pmiaArray=(*(*indexes)[n])->GetArray();
                pmiaLen=(*(*indexes)[n])->GetLength();
				for (int m = 0; m < pmiaLen; m++)
				{
					temp *= sps[indexArray[pmiaArray[m]]];
				}
				sum += temp;
			}
		}
		delete onlyIndexesArray;
	}else
	{
		int gisaLen=gallIndexesArray->GetLength();
		int disaLen=dragIndexesArray->GetLength();
		int disaInLen=0;
		for(int k=0;k<gisaLen;k++)
		{
			intArray=*(*gallIndexesArray)[k];
			intIndexArray=gallIndexArray->GetArray();
		    for(i=0;i<gallCount;i++)
			{
			    indexArray[i]=intIndexArray[*(*intArray)[i]];
			}
			delete intArray;

			intIndexArray=dragIndexArray->GetArray();
            for(i=0;i<disaLen;i++)
			{
			    intArray=*(*dragIndexesArray)[i];
				disaInLen=intArray->GetLength();
                n=0;
				for(int j=gallCount;n<fetchDrag;n++,j++)
				{
				   indexArray[j]=intIndexArray[*(*intArray)[n]];
				}

				for ( n = 0; n < pmIXLen; n++)
				{
				    double temp = 1;
				    pmiaArray=(*(*indexes)[n])->GetArray();
                    pmiaLen=(*(*indexes)[n])->GetLength();
				    for (int m = 0; m < pmiaLen; m++)
					{
				    	temp *= sps[indexArray[pmiaArray[m]]];
					}
			    	sum += temp;
				}
			}
		}

		for(i=0;i<disaLen;i++)
		{
		    delete *(*dragIndexesArray)[i];
		}
		delete dragIndexesArray;
		delete gallIndexesArray;
	}
	 delete indexArray;
	 return sum;
}
