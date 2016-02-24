// Bet.cpp: implementation of the Bet class.
//
//////////////////////////////////////////////////////////////////////

#include "Bet.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

Bet::Bet()
{
    this->passMode=0;
	this->IndexArray=0;
}

Bet::~Bet()
{
	if(this->IndexArray!=0)
	{
	    delete[] IndexArray;
	}
}

Int64 Bet::GetCode()
{
    Int64 value=0;
	for(int i=0;i<this->Length;i++)
	{
	    value|=1<<IndexArray[i];
	}
	return value;
}
