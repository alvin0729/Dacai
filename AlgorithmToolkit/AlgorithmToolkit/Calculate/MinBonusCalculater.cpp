// MinBonusCalculater.cpp: implementation of the MinBonusCalculater class.
//
//////////////////////////////////////////////////////////////////////

#include "MinBonusCalculater.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

MinBonusCalculater::MinBonusCalculater(Array<PassMode*>* passModes,Array<double>* spArray,Array<int>* gallIndexArray,Array<int>* gallRangeArray,Array<int>* hadAllIndexArray)
{
    this->passModes=passModes;
    this->spArray=spArray;
    this->gallIndexArray=gallIndexArray;
    this->gallRangeArray=gallRangeArray;
    this->hadAllIndexArray=hadAllIndexArray;
    Init();

}

MinBonusCalculater::~MinBonusCalculater()
{
    if(this->dragIndexArray!=0)
    {
        delete dragIndexArray;
    }
}


double MinBonusCalculater::Calculate()
{
    int haLen=0;
	int i=0;
    if(this->hadAllIndexArray!=0)
    {
        haLen=this->hadAllIndexArray->GetLength();
    }
    Array<int> ta(1);
    *ta[0]=1;
    int allLen=this->spArray->GetLength();
    Array<Array<int>*> tempArray(allLen);
    for(i=0; i<allLen; i++)
    {
        *tempArray[i]=&ta;
    }
    double tm=1;
    double minValue=0;
    double* sps=this->spArray->GetArray();
    Bet** betArray=0;
    Bet* bet=0;
    int len=0;

    if(haLen>0)
    {

        MLOptions mlInfos(&tempArray,hadAllIndexArray,gallIndexArray,gallRangeArray,passModes,0,0);

        Array<Bet*>* bets=mlInfos.GetBets();
        if(bets==0)
        {
            return  -1;
        }
        len=bets->GetLength();
        Int64 code=mlInfos.GetHadAllIndexCode();
        betArray=bets->GetArray();
        Int64 betCode=0;
        bool hadBet=false;

        for(i=0; i<len; i++)
        {
            betCode=betArray[i]->GetCode();
            bet=betArray[i];
            if((code&betCode)==betCode)
            {
                hadBet=true;
                tm=1;
                for(int j=0; j<bet->Length; j++)
                {
                    tm*=sps[bet->IndexArray[j]];
                }
                minValue+=tm*bet->Repeat;
            }
        }
        if(hadBet)
        {
            return minValue;
        }
        else
        {
            minValue=100000000;
            for(i=0; i<len; i++)
            {
                bet=betArray[i];
                tm=1;
                for(int j=0; j<bet->Length; j++)
                {
                    tm*=sps[bet->IndexArray[j]];
                }
                tm=tm*bet->Repeat;
                if(minValue>tm)
                {
                    minValue=tm;
                }
            }
            if(minValue==100000000)
            {
                return -1;
            }
            else
            {
                return minValue;
            }
        }

    }
    else
    {
        len=this->passModes->GetLength();
        Array<PassMode*> minPassModeArray(len);
        PassMode** pms=passModes->GetArray();
        for(i=0; i<len; i++)
        {
            *minPassModeArray[i]=pms[i]->GetMinPassMode();
        }

        MLOptions mlInfos(&tempArray,hadAllIndexArray,gallIndexArray,gallRangeArray,&minPassModeArray,0,0);

        Array<Bet*>* bets=mlInfos.GetBets();
        if(bets==0)
        {
            return -1;
        }
        len=bets->GetLength();
        betArray=bets->GetArray();

        minValue=100000000;
        for(i=0; i<len; i++)
        {
            bet=betArray[i];
            tm=1;
            for(int j=0; j<bet->Length; j++)
            {
                tm*=sps[bet->IndexArray[j]];
            }
            tm=tm*bet->Repeat;
            if(minValue>tm)
            {
                minValue=tm;
            }
        }
        if(minValue==100000000)
        {
            return -1;
        }
        else
        {
            return minValue;
        }
    }
}

void MinBonusCalculater::Init()
{
    this->dragIndexArray=0;
    if(this->spArray==0||this->gallIndexArray==0)
    {
        return;
    }
    int allLen=this->spArray->GetLength();
    int len=this->gallIndexArray->GetLength();
    int dragLen=allLen-len;
    if(dragLen>0)
    {
        int* da=new int[dragLen];
        int p=0;
        for(int i=0; i<allLen; i++)
        {
            if(this->gallIndexArray->IndexOf(i)==-1)
            {
                da[p++]=i;
            }
        }
        this->dragIndexArray=new Array<int>();
        this->dragIndexArray->Set(da,dragLen);
    }

}
