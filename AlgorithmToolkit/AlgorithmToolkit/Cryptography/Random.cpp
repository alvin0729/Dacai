// Random.cpp: implementation of the Random class.
//
//////////////////////////////////////////////////////////////////////

#include "Random.h"
#include <time.h>
#include <stdlib.h>
#include "TypeDefinition.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

Random::Random(void)
{
    srand(time(0));
}


Random::~Random(void)
{
}

double Random::NextDouble()
{
    return ((rand()<<15)+rand()+1)/RandomDoubleMax;
}

int Random::NextValue(int max)
{
    return NextValue(1,max);
}

int Random::NextShort()
{
    return rand();
}


int Random::NextValue()
{
    return (int)((Int64)(rand()&0x1)<<30)+ (rand()<<15)+rand();
}

int Random::NextValue(int min,int max)
{
    if(min==max)
    {
        return min;
    }

    if(min>max)
    {
        int temp=min;
        min=max;
        max=temp;
    }

    int dv=max-min;

    if(dv<=RandomRandMax)
    {
        return min+rand()%dv;
    }
    else
    {
        return min+(NextValue()%dv);
    }
}

unsigned int Random::NextUint()
{
    return  ((unsigned int)(rand()&3)<<30)+ (unsigned int)(rand()<<15)+(unsigned int)rand();
}
