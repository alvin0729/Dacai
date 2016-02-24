// MLBKAnalyser.cpp: implementation of the MLBKAnalyser class.
//
//////////////////////////////////////////////////////////////////////

#include "MLBKAnalyser.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////


MLBKAnalyser::MLBKAnalyser(Array<Array<int>*>* optionsIndexArray,Array<Array<double>*>* optionsSpArray,double coefficient)
{
    this->optionsIndexArray=optionsIndexArray;
    this->optionsSpArray=optionsSpArray;
    this->coefficient=coefficient;
    this->init();
}

MLBKAnalyser::~MLBKAnalyser()
{
    int i=0;

    if(codeArray!=0)
    {
        int caLen=codeArray->GetLength();
        for(i=0; i<caLen; i++)
        {
            delete *(*codeArray)[i];
        }
        delete codeArray;
    }

    if(fullOptionLenArray!=0)
    {
        delete fullOptionLenArray;
    }

    if(this->fcArray!=0)
    {
        delete this->fcArray;
    }

    if(gameTypeOptionLenArray!=0)
    {
        delete gameTypeOptionLenArray;
    }
}

void MLBKAnalyser::init()
{
    this->gameTypeOptionLenArray=0;

    codeLen=56;
    codeArray=new Array<Array<int>*>(4);
    int temp1[56]= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2};
    *(*codeArray)[0]=new Array<int>(temp1,codeLen);

    int temp2[56]= {5,5,4,4,4,4,4,3,3,3,3,3,2,2,2,2,2,1,1,1,1,1,0,0,0,0,0,6,6,6,6,6,7,7,7,7,7,8,8,8,8,8,9,9,9,9,9,10,10,10,10,10,11,11,12,12};
    *(*codeArray)[1]=new Array<int>(temp2,codeLen);

    int temp4[56]= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2};
    *(*codeArray)[2]=new Array<int>(temp4,codeLen);


    int temp3[54]= {-1000,-26,-25,-24,-23,-22,-21,-20,-19,-18,-17,-16,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,1000};

    this->fcArray=new Array<int>(temp3,54);

    *(*codeArray)[3]=setRFSFIndexArray();

    //131,133,134,132
    char olArray[]= {2,12,2,2};

    fullOptionLenArray=new Array<char>(olArray,4);


}


Array<int>* MLBKAnalyser::setRFSFIndexArray()
{
    int fcLen=fcArray->GetLength();
    int* fcs=fcArray->GetArray();
    int* rfsfCodeArray=new int[codeLen];
    int i = 0;
    for (i = 0; i < fcLen; i++)
    {
        if (fcs[i]+coefficient>0)
        {
            rfsfCodeArray[i]=1;
        }
        else
        {
            rfsfCodeArray[i]=0;
        }

    }
	rfsfCodeArray[codeLen-1]=2;
    rfsfCodeArray[codeLen-2]=2;

    Array<int>* rfsfCodes=new Array<int>();
    rfsfCodes->Set(rfsfCodeArray,codeLen);
    return rfsfCodes;
}


Array<Array<double>*>* MLBKAnalyser::initMaxMinData(bool isMax)
{
    Array<double>** valuesArray= new Array<double>*[4];

    int valuesLenArray[] =  { 3, 13,3, 3 };

    Array<int>* oiArray=0;
    int* intArray=0;
    int oiLen=0;
    Array<double>* spArray=0;
    int spLen=0;
    double* sps=0;
    int n = 0;
    int ivLen=0;
    for (int i = 0; i < 4; i++)
    {
		valuesArray[i]=0;
        ivLen=valuesLenArray[i];
        double* ivArray=new double[ivLen];
        for(n=0; n<ivLen; n++)
        {
            ivArray[n]=0;
        }
        Array<double>* innerValueArray=new Array<double>();
        innerValueArray->Set(ivArray,ivLen);
        valuesArray[i]=innerValueArray;

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
	    double min=100000000;
        switch(i)
        {
        case 0:
        case 1:
        case 3:

            for(n=0; n<oiLen; n++)
            {
                ivArray[intArray[n]]=sps[n];
				if(min>sps[n])
				{
				   min=sps[n];
				}
            }
			if(!isMax)
			{
			    if(ivLen==(spLen+1))
				{
				    ivArray[ivLen-1]=min;
				}
			}
            break;
        case 2:
            if(isMax)
            {

                if(oiLen==1||sps[0]>sps[1])
                {
                    ivArray[0]=sps[0];
                }
                else
                {
                    ivArray[0]=sps[1];
                }

            }
            else
            {
                if(oiLen==1)
                {
                    ivArray[0]=0;
                }
                else
                {
                    ivArray[0]=sps[0]>sps[1]?sps[1]:sps[0];
                }
                for(n=0; n<oiLen; n++)
                {
                    ivArray[intArray[n]+1]=sps[n];
                }
            }
            break;
        }

    }
    Array<Array<double>*>* reArray=new Array<Array<double>*>();
    reArray->Set(valuesArray,4);
    return reArray;
}


bool MLBKAnalyser::IsHadAllOption()
{
    int flaLen=this->fullOptionLenArray->GetLength();
    char* folArray=this->fullOptionLenArray->GetArray();
    for(int i=0; i<flaLen; i++)
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


int MLBKAnalyser::GetGameTypeLen()
{
    if(this->optionsIndexArray==0)
    {
        return 0;
    }
    int oiaLen=optionsIndexArray->GetLength();
    int reLen=0;
    for(int i=0; i<oiaLen; i++)
    {
        Array<int>* innerOptionsIndexArray=*(*optionsIndexArray)[i];
        if(innerOptionsIndexArray!=0&&innerOptionsIndexArray->GetLength()>0)
        {
            reLen++;
        }
    }
    return reLen;
}

double MLBKAnalyser::GetMaxComSp()
{
    Array<Array<double>*>* valuesArray=this->initMaxMinData(true);
    double max = 0;
    int j = 0;
    int* codes=0;
    double* vaArray=0;
    Array<double>* dArray=0;
    for (int i = 1; i < 53; i++)
    {
        double temp = 0;

        for (j = 0; j < 4; j++)
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
    for(j=0; j<len; j++)
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

double MLBKAnalyser::GetMinComSp()
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
        for (j = 0; j < 4; j++)
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
    for(j=0; j<len; j++)
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


Array<int>* MLBKAnalyser::GetGameTypeOptionLenArray()
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
    for(int i=0; i<oiaLen; i++)
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
