// RSAProvider.cpp: implementation of the RSAProvider class.
//
//////////////////////////////////////////////////////////////////////

#include "RSAProvider.h"
#include "TypeDefinition.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////


RSAProvider::RSAProvider()
{
    includePrivateParams = false;
    one=BigInteger(1);
    random=Random();
    bits=0;
    p=0;
    q=0;
    dp=0;
    dq=0;
    u=0;
    n=0;
    e=0;
    d=0;
}

RSAProvider::RSAProvider(int bits)
{
    this->bits=bits;
    one=BigInteger(1);
    random=Random();
    includePrivateParams = true;

    p = BigInteger::GenPseudoPrime(bits, 1, random);

    q = BigInteger::GenPseudoPrime(bits, 1, random);

    dp = p - one;
    dq = q - one;
    u = dp * dq;
    n = p * q;

    e = u.GenCoPrime(32, random);

    d = e.ModInverse(u);
}

RSAProvider::~RSAProvider()
{

}

/*

   /// <summary>
        /// 加密 －公钥加密
        /// </summary>
        /// <param name="content">需加密内容</param>
        /// <returns>加密后内容</returns>
Byte* RSAProvider::Encrypt(Byte content[],int length)
        {
            BigInteger M = BigInteger(content,length);
            BigInteger C = M.ModPow(e, n);
            return C.GetBytesRemovedZero();
        }




        /// <summary>
        /// 解密 －私钥解密
        /// </summary>
        /// <param name="content">需解密内容</param>
        /// <returns>解密后内容</returns>
Byte* RSAProvider::Decrypt(Byte content[],int length)
        {

            BigInteger C =BigInteger(content,length);
            BigInteger M = C.ModPow(d, n);
            return M.GetBytesRemovedZero();
        }

*/

int RSAProvider::Encrypt(Byte * content,int cLen,Byte *  encrypted,int enLen)
{
    int step = bits / 4;
    int readLen = step - 1;

    if (readLen < cLen)
    {
        int count = cLen / readLen;
        if (cLen % readLen > 0)
        {
            count++;
        }
        int position = 0,enP=0;
        Byte temp[512];
        Byte result[512];
        int j=0,n=0;
        for (int i = 0; i < count; i++)
        {
            int copyedLen = readLen;
            if (position + readLen > cLen)
            {
                copyedLen = cLen - position;
            }
            for(j=position,n=0; n<copyedLen&&j<cLen; n++,j++)
            {
                temp[n]=content[j];
            }

            int len=Encrypt(temp,copyedLen,result,512);
            
            for(j=0;j<step-len;j++)
            {
                encrypted[enP++]=0;
            }
            
            for(j=0; j<len; j++)
            {
                encrypted[enP++]=result[j];
            }
            position += copyedLen;
        }
        return enP;
    }
    else
    {
        BigInteger M = BigInteger(content,cLen);
        BigInteger C = M.ModPow(e, n);
        return C.GetBytesRemovedZero(encrypted,enLen);
    }


}


int RSAProvider::Decrypt(Byte *  content,int cLen,Byte *  decrypted,int deLen)
{
    if (!includePrivateParams)
    {
        return 0;
    }

    int step = bits / 4;
    int i=0,j=0,position=0,deP=0;
    if (step == 0)
    {
        return 0;
    }
    Byte temp[512];
    Byte result[512];
    if (step < cLen)
    {
        int count = cLen / step;
        if (cLen % step > 0)
        {
            return 0;
        }

        for ( i = 0; i < count; i++)
        {
            for(j=0; j<step; j++)
            {
                temp[j]=content[position++];
            }

            int len= Decrypt(temp,step,result,512);

            for(j=0; j<len; j++)
            {
                decrypted[deP++]=result[j];
            }
        }
        return deP;
    }
    else
    {

        BigInteger C =BigInteger(content,cLen);
        BigInteger M = C.ModPow(d, n);
        return M.GetBytesRemovedZero(decrypted,deLen);
    }
}

//密钥加密
int RSAProvider::EncryptByPrivate(Byte* content,int cLen,Byte* encrypted,int enLen)
{
    if (!includePrivateParams)
    {
        return 0;
    }

    int step = bits / 4;
    int readLen = step - 1;

    if (readLen < cLen)
    {
        int count = cLen / readLen;
        if (cLen % readLen > 0)
        {
            count++;
        }
        int position = 0,enP=0;
        Byte temp[512];
        Byte result[512];
        int j=0,n=0;
        for (int i = 0; i < count; i++)
        {
            int copyedLen = readLen;
            if (position + readLen > cLen)
            {
                copyedLen = cLen - position;
            }
            for(j=position,n=0; n<copyedLen&&j<cLen; n++,j++)
            {
                temp[n]=content[j];
            }

            int len=EncryptByPrivate(temp,copyedLen,result,512);
        
            for(j=0;j<step-len;j++)
            {
                encrypted[enP++]=0;
            }
            
            for(j=0; j<len; j++)
            {
                encrypted[enP++]=result[j];
            }
            position += copyedLen;
        }
        return enP;
    }
    else
    {
        BigInteger M = BigInteger(content,cLen);
        BigInteger C = M.ModPow(d, n);
        return C.GetBytesRemovedZero(encrypted,enLen);
    }


}

//公钥解密
int RSAProvider::DecryptByPublic(Byte* content,int cLen,Byte* decrypted,int deLen)
{
    int step = bits / 4;
    int i=0,j=0,position=0,deP=0;
    if (step == 0)
    {
        return 0;
    }
    Byte temp[512];
    Byte result[512];
    if (step < cLen)
    {
        int count = cLen / step;
        if (cLen % step > 0)
        {
            return 0;
        }

        for ( i = 0; i < count; i++)
        {
            for(j=0; j<step; j++)
            {
                temp[j]=content[position++];
            }

            int len= DecryptByPublic(temp,step,result,512);

            for(j=0; j<len; j++)
            {
                decrypted[deP++]=result[j];
            }
        }
        return deP;
    }
    else
    {

        BigInteger C =BigInteger(content,cLen);
        BigInteger M = C.ModPow(e, n);
        return M.GetBytesRemovedZero(decrypted,deLen);
    }
}





bool RSAProvider::IsSamePQ()
{
    return (p==q);
}

string RSAProvider::ToXmlString(bool includePrivateParams)
{
    Byte temp1[1024];
    Byte temp2[2048];
    XmlRSAKey xmlRSAKey;

    int len1=n.GetBytesRemovedZero(temp1,1024);
    Base64::Encode(temp1,len1,temp2,2048);
    xmlRSAKey.SetModulus((String)temp2);

    len1=e.GetBytesRemovedZero(temp1,1024);
    Base64::Encode(temp1,len1,temp2,2048);
    xmlRSAKey.SetExponent((String)temp2);

    if(this->includePrivateParams&&includePrivateParams)
    {
        len1=p.GetBytesRemovedZero(temp1,1024);
        Base64::Encode(temp1,len1,temp2,2048);
        xmlRSAKey.SetP((String)temp2);

        len1=q.GetBytesRemovedZero(temp1,1024);
        Base64::Encode(temp1,len1,temp2,2048);
        xmlRSAKey.SetQ((String)temp2);

        len1=dp.GetBytesRemovedZero(temp1,1024);
        Base64::Encode(temp1,len1,temp2,2048);
        xmlRSAKey.SetDP((String)temp2);

        len1=dq.GetBytesRemovedZero(temp1,1024);
        Base64::Encode(temp1,len1,temp2,2048);
        xmlRSAKey.SetDQ((String)temp2);

        len1=d.GetBytesRemovedZero(temp1,1024);
        Base64::Encode(temp1,len1,temp2,2048);
        xmlRSAKey.SetD((String)temp2);

        len1=u.GetBytesRemovedZero(temp1,1024);
        Base64::Encode(temp1,len1,temp2,2048);
        xmlRSAKey.SetInverseQ((String)temp2);
    }

    return xmlRSAKey.GetXml();
}

void RSAProvider::FromXmlString(string xmlString)
{
    Byte temp1[1024];
    Byte temp2[2048];
    XmlRSAKey xmlRSAKey;
    xmlRSAKey.SetXml(xmlString);
    int len1=xmlRSAKey.GetModulus((String)temp2,2048);
    int len2=Base64::Decode(temp2,len1,temp1,1024);

    n=BigInteger(temp1,len2);

    len1=xmlRSAKey.GetExponent((String)temp2,2048);
    len2=Base64::Decode(temp2,len1,temp1,1024);

    e=BigInteger(temp1,len2);

    if(xmlRSAKey.IsIncludePrivateKey())
    {
        this->includePrivateParams=true;

        len1=xmlRSAKey.GetP((String)temp2,2048);
        len2=Base64::Decode(temp2,len1,temp1,1024);

        p=BigInteger(temp1,len2);

        len1=xmlRSAKey.GetQ((String)temp2,2048);
        len2=Base64::Decode(temp2,len1,temp1,1024);

        q=BigInteger(temp1,len2);

        len1=xmlRSAKey.GetDP((String)temp2,2048);
        len2=Base64::Decode(temp2,len1,temp1,1024);

        dp=BigInteger(temp1,len2);

        len1=xmlRSAKey.GetDQ((String)temp2,2048);
        len2=Base64::Decode(temp2,len1,temp1,1024);

        dq=BigInteger(temp1,len2);

        len1=xmlRSAKey.GetInverseQ((String)temp2,2048);
        len2=Base64::Decode(temp2,len1,temp1,1024);

        u=BigInteger(temp1,len2);

        len1=xmlRSAKey.GetD((String)temp2,2048);
        len2=Base64::Decode(temp2,len1,temp1,1024);

        d=BigInteger(temp1,len2);
    }
    else
    {
        this->includePrivateParams=false;
    }
}


//导出公钥或密钥
int RSAProvider::ToBytes(bool includePrivateParams,Byte* rsaBytes,int rbInLen)
{
    if(rbInLen<(16+(bits/4)))
    {
        return 0;
    }

    Byte temp[512];
    int position=16;
    int len=n.GetBytesRemovedZero(temp,512);
    rsaBytes[0]=len&0xff;
    rsaBytes[1]=len>>8;

    int i=0;
    for(i=0; i<len; i++)
    {
        rsaBytes[position++]=temp[i];
    }


    len=e.GetBytesRemovedZero(temp,512);
    rsaBytes[2]=len&0xff;
    rsaBytes[3]=len>>8;
    for(i=0; i<len; i++)
    {
        rsaBytes[position++]=temp[i];
    }
    for( i=4; i<16; i++)
    {
        rsaBytes[i]=0;//设置密钥为空
    }
    if (includePrivateParams)
    {


        len=p.GetBytesRemovedZero(temp,512);
        rsaBytes[4]=len&0xff;
        rsaBytes[5]=len>>8;
        for(i=0; i<len; i++)
        {
            rsaBytes[position++]=temp[i];
        }


        len=q.GetBytesRemovedZero(temp,512);
        rsaBytes[6]=len&0xff;
        rsaBytes[7]=len>>8;
        for(i=0; i<len; i++)
        {
            rsaBytes[position++]=temp[i];
        }


        len=dp.GetBytesRemovedZero(temp,512);
        rsaBytes[8]=len&0xff;
        rsaBytes[9]=len>>8;
        for(i=0; i<len; i++)
        {
            rsaBytes[position++]=temp[i];
        }

        len=dq.GetBytesRemovedZero(temp,512);
        rsaBytes[10]=len&0xff;
        rsaBytes[11]=len>>8;
        for(i=0; i<len; i++)
        {
            rsaBytes[position++]=temp[i];
        }

        len=u.GetBytesRemovedZero(temp,512);
        rsaBytes[12]=len&0xff;
        rsaBytes[13]=len>>8;
        for(i=0; i<len; i++)
        {
            rsaBytes[position++]=temp[i];
        }

        len=d.GetBytesRemovedZero(temp,512);
        rsaBytes[14]=len&0xff;
        rsaBytes[15]=len>>8;
        for(i=0; i<len; i++)
        {
            rsaBytes[position++]=temp[i];
        }
    }

    return position;
}

//导入公钥或密钥
void RSAProvider::FromBytes(Byte* rsaBytes,int rbLen)
{
    if (rsaBytes == 0 || rbLen < 16)
    {
        //不合法 退出
        return;
    }
    Byte temp[512];

    int position=16;
    int i=0;

    int len=rsaBytes[1]<<8|rsaBytes[0];
    this->bits=len*4;


    if(len>0)
    {
        for(i=0; i<len; i++)
        {
            temp[i]=rsaBytes[position++];
        }
        n=BigInteger(temp,len);
    }

    len=rsaBytes[3]<<8|rsaBytes[2];


    if(len>0)
    {
        for(i=0; i<len; i++)
        {
            temp[i]=rsaBytes[position++];
        }
        e=BigInteger(temp,len);
    }

    len=rsaBytes[5]<<8|rsaBytes[4];


    if(len>0)
    {
        for(i=0; i<len; i++)
        {
            temp[i]=rsaBytes[position++];
        }
        p=BigInteger(temp,len);
    }

    len=rsaBytes[7]<<8|rsaBytes[6];

    if(len>0)
    {
        for(i=0; i<len; i++)
        {
            temp[i]=rsaBytes[position++];
        }
        q=BigInteger(temp,len);
    }


    len=rsaBytes[9]<<8|rsaBytes[8];


    if(len>0)
    {
        for(i=0; i<len; i++)
        {
            temp[i]=rsaBytes[position++];
        }
        dp=BigInteger(temp,len);
    }

    len=rsaBytes[11]<<8|rsaBytes[10];


    if(len>0)
    {
        for(i=0; i<len; i++)
        {
            temp[i]=rsaBytes[position++];
        }
        dq=BigInteger(temp,len);
    }

    len=rsaBytes[13]<<8|rsaBytes[12];


    if(len>0)
    {
        for(i=0; i<len; i++)
        {
            temp[i]=rsaBytes[position++];
        }
        u=BigInteger(temp,len);
    }

    len=rsaBytes[15]<<8|rsaBytes[14];


    if(len>0)
    {
        for(i=0; i<len; i++)
        {
            temp[i]=rsaBytes[position++];
        }

        d=BigInteger(temp,len);
    }
}
