// PassMode.cpp: implementation of the PassMode class.
//
//////////////////////////////////////////////////////////////////////

#include "PassMode.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////


PassMode::PassMode()
{
    init();
}

PassMode::PassMode(int pass,int mode)
{
    init();
	this->pass=pass;
	this->mode=mode;
	subPassesCount=GetActPass(pass,mode,subPasses,PassModeMaxPass);

}


/*
PassMode::PassMode(const PassMode& passMode)
{
    this->pass=passMode.pass;
	this->mode=passMode.mode;

	for(int i=0;i<PassModeMaxPass;i++)
	{
	    subPasses[i]=passMode.subPasses[i];
	}
this->parent=passMode.parent;
    this->subPassesCount=passMode.subPassesCount;
}*/

PassMode::~PassMode()
{
   if(indexes!=0)
   {
       int len=indexes->GetLength();
	   for(int i=0;i<len;i++)
	   {
	      delete *(*indexes)[i];
	   }
       delete indexes;
   }

   if(minPM!=0)
   {
       delete minPM;
   }

}

void PassMode::init()
{
	pass=0;
	minPM=0;
	mode=0;
	subPassesCount=0;
	indexes=0;
	for(int i=0;i<PassModeMaxPass;i++)
	{
	    subPasses[i]=0;
	}
}

int PassMode::GetActPass(const int pass,const int mode,char* actPass,const int alen)
{
	if(pass<1||mode<1||pass>PassModeMaxPass)
	{
	   return -1;
	}
	if(mode==1)
	{
	   actPass[0]=pass;
	   return 1;
	}

	if(mode==pass)
	{
	   actPass[0]=pass-1;
	   return 1;
	}

	if(mode==(pass+1))
	{
	   actPass[0]=pass;
	   actPass[1]=pass-1;
	   return 2;
	}
	int passPow2=(1<<pass);
	int i=0,j=0;
	if(mode==(passPow2-1))
	{
	   for( i=0;i<pass;i++)
	   {
	      actPass[i]=i+1;
	   }
	   return pass;
	}

	if(mode==(passPow2-2))
	{
	    for( i=0;i<(pass-1);i++)
	   {
	      actPass[i]=i+1;
	   }
	   return pass-1;
	}

	if(mode==(passPow2-pass-1))
	{
	   for( i=1,j=0;i<pass;i++,j++)
	   {
	      actPass[j]=i+1;
	   }
	   return pass-1;
	}

	if(mode==(passPow2-pass-2))
	{
	   for(i=0;i<(pass-2);i++)
	   {
	      actPass[i]=i+1;
	   }
	   return pass-2;
	}


    switch(pass)
	{
	case 4:
		switch(mode)
		{
		case 6:
			actPass[0]=2;
			return 1;
		}
	case 5:
	 	switch(mode)
		{
		case 10:
		   actPass[0]=2;
		   return 1;
		case 15:
			actPass[0]=2;
			actPass[1]=1;
			return 2;
		case 16:
	        actPass[0]=5;
			actPass[1]=4;
			actPass[2]=3;
			return 3;
		case 20:
            actPass[0]=2;
			actPass[1]=3;
			return 2;
		}
	case 6:
		switch(mode)
		{
		case 15:
			actPass[0]=2;
			return 1;
		case 20:
			actPass[0]=3;
			return 1;
		case 21:
			actPass[0]=2;
			actPass[1]=1;
			return 2;
		case 22:
			actPass[0]=6;
			actPass[1]=5;
			actPass[2]=4;
			return 3;
		case 35:
			actPass[0]=2;
			actPass[1]=3;
			return 2;
		case 41:
			actPass[0]=1;
			actPass[1]=2;
			actPass[2]=3;
			return 3;
		case 42:
	        actPass[0]=6;
			actPass[1]=5;
			actPass[2]=4;
			actPass[3]=3;
			return 4;
		case 50:
	        actPass[0]=2;
			actPass[1]=3;
			actPass[2]=4;
			return 3;
		}
	case 7:
		switch(mode)
		{
		case 21:
			actPass[0]=5;
			return 1;
		case 35:
			actPass[0]=4;
			return 1;
		}

	case 8:
		switch(mode)
		{
		case 28:
			actPass[0]=6;
			return 1;
		case 56:
			actPass[0]=5;
			return 1;
		case 70:
			actPass[0]=4;
			return 1;
		}
	}
	return -1;
}


int PassMode::GetSubPassModes(PassMode* subPassModes,int pmLen)
{
	if(pass==0||mode==0||mode==1)
	{
	   return 0;
	}

	if(subPassesCount<1)
	{
	   return subPassesCount;
	}

	if(pmLen<subPassesCount)
	{
	   return -1;
	}

	for(int i=0;i<subPassesCount;i++)
	{
	    subPassModes[i]=PassMode(subPasses[i],1);
	}
    return subPassesCount;
}


int PassMode::GetSubPassModesCout()
{

	   return subPassesCount;
}

PassMode* PassMode::GetMinPassMode()
{
      if(mode==1)
      {
          return this;
      }
      if(minPM!=0)
	  {
	     return minPM;
	  }
      int min=200;
      for (int i = 0; i < subPassesCount; i++)
      {
           if (min>subPasses[i])
           {
               min = subPasses[i];
           }
      }

	  minPM=new PassMode();
	  minPM->pass=pass;
	  int newMode=Combination::GetInt32(pass,min);
	  minPM->mode=newMode;
      minPM->subPassesCount=1;
	  minPM->subPasses[0]=min;
     return minPM;
}

PassMode PassMode::GetSubPassMode(int* subPasses,int len)
{
	PassMode passMode;
	for(int j=0;j<this->subPassesCount;j++)
	{
        for(int i=0;i<len;i++)
		{
	        if(this->subPasses[j]== subPasses[i])
			{
			   passMode.mode+=Combination::GetInt32(pass,subPasses[i]);
		       break;
			}

		}
	}
    return passMode;
}

Array<Array<unsigned char>*>* PassMode::GetIndexes()
{
	if(indexes!=0)
    {
	    return indexes;
	}

	Array<unsigned char>** array=new Array<unsigned char>*[mode];
    int p=0;
	for(int i=0;i<this->subPassesCount;i++)
	{
		Array<Array<unsigned char>*>* indexes=Combination::GetIndexes((unsigned char)pass,(unsigned char)subPasses[i]);
        int indexesLen=indexes->GetLength();
		for(int j=0;j<indexesLen;j++)
		{
		    array[p++]=*(*indexes)[j];
		}
		delete indexes;
	}
    Array<Array<unsigned char>*>* reArray=new Array<Array<unsigned char>*>();
	reArray->Set(array,mode);
	indexes=reArray;
	return reArray;
}


int PassMode::GetPass()
{
    return pass;
}


int PassMode::GetMode()
{
   return mode;
}
