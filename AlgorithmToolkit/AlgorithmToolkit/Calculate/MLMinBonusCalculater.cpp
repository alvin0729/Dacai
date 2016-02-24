// MLMinBonusCalculater.cpp: implementation of the MLMinBonusCalculater class.
//
//////////////////////////////////////////////////////////////////////

#include "MLMinBonusCalculater.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

MLMinBonusCalculater::MLMinBonusCalculater(MLOptions* mlInfo)
{
    this->mlInfo=mlInfo;
}

MLMinBonusCalculater::~MLMinBonusCalculater()
{

}

double MLMinBonusCalculater::Calculate()
{
    if(this->mlInfo==0||this->mlInfo->IsInvalidData())
	{
	    return -1;
	}
	 Int64 hadAllIndexCode=mlInfo->GetHadAllIndexCode();
	if(hadAllIndexCode!=0)
	{
        return CalculateHadAll(hadAllIndexCode);
	}else
	{
	    if(mlInfo->IsAllSinglePassModes()||mlInfo->IsAllSingleTypeForField())
		{
		   //普通计算
            //MinBonusCalculater(Array<PassMode*>* passModes,Array<double>* spArray,Array<int>* gallIndexArray,Array<int>* gallRangeArray,Array<int>* hadAllIndexArray);
            MinBonusCalculater mbc(mlInfo->GetPassModes(),mlInfo->GetMinSps(),mlInfo->GetGallIndexArray(),mlInfo->GetGallRangeArray(),mlInfo->GetHadAllIndexArray());
             return mbc.Calculate();
		}

		 Array<Bet*> *betArray=mlInfo->GetBets();
         if(betArray==0)
         {
               return -1;
         }
		  Bet* bet=0;
         double min=MLMinBonusCalculaterMaxMin;
		 Bet** bets=betArray->GetArray();
		 double temp=0;
		 double* mlMinSps=mlInfo->GetMinSps()->GetArray();
	     int betLen=betArray->GetLength();
	        for(int i=0;i<betLen;i++)
			{
	            bet=bets[i];
		        temp=1;
		        for(int j=0;j<bet->Length;j++)
				{
		           temp*=mlMinSps[bet->IndexArray[j]];
				}
				temp*=bet->Repeat;

		        if(min>temp)
				{
				    min=temp;
				}
			}
			if(min==MLMinBonusCalculaterMaxMin)
			{
			    return -1;
			}
			return min;
	}
}

double MLMinBonusCalculater::CalculateHadAll(Int64 hadAllIndexCode)
{
       Array<Bet*> *betArray=mlInfo->GetBets();
	   if(betArray==0)
	   {
	      return -1;
	   }
	   bool hadPass=false;
	   Bet** bets=betArray->GetArray();
	   int betLen=betArray->GetLength();
	   Int64 code=0;
	   double sum=0,temp=0;
	   double* mlMinSps=mlInfo->GetMinSps()->GetArray();
	   Bet* bet=0;
	   for(int i=0;i<betLen;i++)
	   {
	       code=bets[i]->GetCode();
		   if((code&hadAllIndexCode)==code)
		   {
		        hadPass=true;
	        	bet=bets[i];
		        temp=1;
		        for(int j=0;j<bet->Length;j++)
				{
		           temp*=mlMinSps[bet->IndexArray[j]];
				}
		        sum+=temp*bet->Repeat;
		   }
	   }
	   if(hadPass)
	   {
		    return sum;
	   }else
	   {
		   double min=MLMinBonusCalculaterMaxMin;
	        for(int i=0;i<betLen;i++)
			{
	            bet=bets[i];
		       	temp=1;
		        for(int j=0;j<bet->Length;j++)
				{
		           temp*=mlMinSps[bet->IndexArray[j]];
				}
				temp*=bet->Repeat;
		        if(min>temp)
				{
				    min=temp;
				}
			}
			if(min==MLMinBonusCalculaterMaxMin)
			{
			    return -1;
			}
			return min;
	   }
}
