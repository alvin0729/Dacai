// HMAC.cpp: implementation of the HMAC class.
//
//////////////////////////////////////////////////////////////////////

#include "HMAC.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

HMAC::HMAC()
{
   md5=MD5();
}

HMAC::~HMAC()
{

}

int HMAC::Digest(Byte* rawkey,int rkLen, Byte* source,int srcLen,Byte *digestedArray,int daLen)
{
    Byte mackey[64];
	int mkLen=64;
    int i=0,j=0;
	for(i=0;i<64;i++)
	{
	   mackey[i]=0;
	}

	for(i=0;i<daLen;i++)
	{
	   digestedArray[i]=0;
	}

            if (rkLen > mkLen)
			{
               mkLen= md5.Digest(rawkey,rkLen,mackey,mkLen);
			}
            else
            {
				for(i=0;i<rkLen;i++)
				{
				   mackey[i]=rawkey[i];
				}
            }

			int ikLen=mkLen + srcLen;

			Byte* innerkey = new Byte[ikLen];

            for (i= 0; i < mkLen; i++)
            {
                innerkey[i] = ((Byte)(mackey[i] ^ 0x36));
            }


			for(i=mkLen,j=0;i<ikLen;i++,j++)
			{
			    innerkey[i]=source[j];
			}

			int ihLen=32;

            Byte innerhash[32];

			ihLen= md5.Digest(innerkey,ikLen,innerhash,32);

			int okLen=mkLen + ihLen;

            Byte* outerkey = new Byte[okLen];

            for (i = 0; i < mkLen; i++)
            {
                outerkey[i] = ((Byte)(mackey[i] ^ 0x5C));
            }

			for(i=mkLen,j=0;i<okLen;i++,j++)
			{
			   outerkey[i]=innerhash[j];
			}



            int reLen= md5.Digest(outerkey,okLen,digestedArray,daLen);

			if(innerkey!=null)
			{
			   delete innerkey;
			}

			if(outerkey!=null)
			{
			   delete outerkey;
			}

			return reLen;

}
