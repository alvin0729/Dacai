// StringBuilder.cpp: implementation of the StringBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "StringBuilder.h"
#include "string.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

StringBuilder::StringBuilder()
{
    this->len=1024;
    Init();
}

StringBuilder::StringBuilder(int len)
{
    this->len=len;
    Init();
}



StringBuilder::~StringBuilder()
{
    if(data!=null)
    {
        delete[] data;
    }

}


void StringBuilder::Init()
{
    data=new char[len];
    for(int i=0; i<len; i++)
    {
        data[i]=0;
    }
    position=0;
}

int StringBuilder::Append(string str)
{
    int strLen=str.length();

    if(strLen>0)
    {

        if((position+strLen+1)>len)
        {
            expand();
        }

        for(int i=0; i<strLen; i++,position++)
        {
            data[position]=str[i];
        }
    }
    return position;
}

/*
int StringBuilder::Append(char * str)
{
    if(str!=null)
    {
       int strLen=strlen(str);
       if(strLen>0)
       {
            if((position+strLen+1)>len)
	        {
	            expand();
	        }

	        for(int i=0;i<strLen;i++,position++)
	       {
	          data[position]=str[i];
	       }
       }
    }
    return position;
}

*/

void StringBuilder::expand()
{
    int newLen=len+StringBuilderExpandLen;
    String newData=new char[newLen];
    int i=0;
    for( i=0; i<newLen; i++)
    {
        newData[i]=0;
    }

    for(i=0; i<len; i++)
    {
        newData[i]=data[i];
    }

    delete data;

    len=newLen;
    data=newData;
}


string StringBuilder::ToString()
{
    /*int reLen=position;

    string reString="";

     for(int i=0;i<position;i++)
     {
        reString[i]=data[i];
     }
     reString[reLen]=0;

     return reString;*/

    string reString=data;
    return reString;

}

int StringBuilder::ToString(char* str,int strLen)
{
    int i=0;
    for(i=0; i<strLen; i++)
    {
        str[i]=0;
    }

    int reLen=0;
    for(i=0; i<position&&i<(strLen-1); i++)
    {
        str[i]=data[i];
        reLen++;
    }

    return reLen;

}

int StringBuilder::GetLength()
{
    return position;
}

