// MLMaxBonusCalculater.cpp: implementation of the MLMaxBonusCalculater class.
//
//////////////////////////////////////////////////////////////////////

#include "MLMaxBonusCalculater.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

MLMaxBonusCalculater::MLMaxBonusCalculater(MLOptions* mlInfo)
{
    this->mlInfo=mlInfo;
}

MLMaxBonusCalculater::~MLMaxBonusCalculater()
{

}

double MLMaxBonusCalculater::Calculate()
{
    if(mlInfo==0||mlInfo->IsInvalidData())
	{
	    return -1;
	}

	if(mlInfo->IsAllSinglePassModes()||mlInfo->IsAllSingleTypeForField())
	{
	    //调用单一彩种计算方式
		MaxBonusCalculater mbc(mlInfo->GetPassModes(),mlInfo->GetMaxSps(),mlInfo->GetGallIndexArray(),mlInfo->GetDragIndexArray(),mlInfo->GetGallRangeArray());
		return mbc.Calculate();
	}

	Array<Bet*>* betArray=mlInfo->GetBets();
	if(betArray==0)
	{
	    return -1;
	}
	int betLen=betArray->GetLength();
	Bet** bets=betArray->GetArray();
    double* mlMaxSps=mlInfo->GetMaxSps()->GetArray();
    double sum=0;
	double temp=0;
    for(int i=0;i<betLen;i++)
	{
	    Bet* bet=bets[i];
		temp=1;
		for(int j=0;j<bet->Length;j++)
		{
		    temp*=mlMaxSps[bet->IndexArray[j]];
		}
		sum+=temp*bet->Repeat;
	}
	return sum;
}
