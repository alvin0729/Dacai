// RSAKey.cpp: implementation of the RSAKey class.
//
//////////////////////////////////////////////////////////////////////

#include "XmlRSAKey.h"
#include "StringBuilder.h"


//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

XmlRSAKey::XmlRSAKey()
{
    Modulus="";
    Exponent="";
    P="";
    Q="";
    DP="";
    DQ="";
    InverseQ="";
    D="";

}

XmlRSAKey::~XmlRSAKey()
{
}



void XmlRSAKey::SetXml(string key)
{
    if(key.length()<1)
    {
        return;
    }


    this->Modulus=GetValue(key,"<Modulus>");
    this->D=GetValue(key,"<D>");
    this->DP=GetValue(key,"<DP>");
    this->DQ=GetValue(key,"<DQ>");
    this->Exponent=GetValue(key,"<Exponent>");
    this->InverseQ=GetValue(key,"<InverseQ>");
    this->P=GetValue(key,"<P>");
    this->Q=GetValue(key,"<Q>");

}

bool XmlRSAKey::IsIncludePrivateKey()
{
    return (this->D.length()>0);
}

bool XmlRSAKey::SetModulus(const string modulus)
{
    this->Modulus=modulus;
    return true;
}

bool XmlRSAKey::SetExponent(const string exponent)
{
    this->Exponent=exponent;
    return true;
}

bool XmlRSAKey::SetP(const string p)
{
    this->P=p;
    return true;
}

bool XmlRSAKey::SetQ(const string q)
{
    this->Q=q;
    return true;
}

bool XmlRSAKey::SetDP(const string dp)
{
    this->DP=dp;
    return true;
}

bool XmlRSAKey::SetDQ(const string dq)
{
    this->DQ=dq;
    return true;
}

bool XmlRSAKey::SetInverseQ(const string inverseQ)
{
    this->InverseQ=inverseQ;
    return true;
}

bool XmlRSAKey::SetD(const string d)
{
    this->D=d;
    return true;
}

string XmlRSAKey::GetXml()
{
    StringBuilder builder;
    builder.Append("<RSAKeyValue>");
    builder.Append("<Modulus>");
    builder.Append(Modulus);
    builder.Append("</Modulus>");
    builder.Append("<Exponent>");
    builder.Append(Exponent);
    builder.Append("</Exponent>");
    if (IsIncludePrivateKey())
    {

        builder.Append("<P>");
        builder.Append(P);
        builder.Append("</P>");

        builder.Append("<Q>");
        builder.Append(Q);
        builder.Append("</Q>");

        builder.Append("<DP>");
        builder.Append(DP);
        builder.Append("</DP>");

        builder.Append("<DQ>");
        builder.Append(DQ);
        builder.Append("</DQ>");

        builder.Append("<InverseQ>");
        builder.Append(InverseQ);
        builder.Append("</InverseQ>");

        builder.Append("<D>");
        builder.Append(D);
        builder.Append("</D>");
    }
    builder.Append("</RSAKeyValue>");
    return builder.ToString();
}


string XmlRSAKey::GetValue(const string content,const string key)
{
    int contentLen=content.length();
    int keyLen=key.length();
    if(contentLen<1||keyLen<1)
    {
        return "";
    }


    int l=0;
    int i=0;
    for(i=0; i<contentLen; i++)
    {
        if(content[i]==key[l])
        {
            l++;
        }
        else
        {
            l=0;
        }

        if(l==keyLen)
        {
            break;
        }
    }
    int start=i;
    int end=0;
    for(; i<contentLen; i++)
    {

        if(content[i]=='<')
        {
            end=i;
            break;
        }
    }
    if(end<=start)
    {
        return "";
    }
    int dataLen=end-start;
    char* data=new char[dataLen+1];
    for(i=0; i<dataLen; i++)
    {
        data[i]=content[start+i];
    }
    data[dataLen]=0;

    string reData=data;
    delete []data;
    return reData;
}


int XmlRSAKey::GetModulus(char * modules,int strLen)
{


    int len= Modulus.length();

    if(strLen-1<len)
    {
        return -1;
    }

    int i=0;

    for(i=0; i<len; i++)
    {
        modules[i]=Modulus[i];
    }

    for(; i<strLen; i++)
    {
        modules[i]=0;
    }
    return len;
}

int XmlRSAKey::GetExponent(char* exponent,int strLen)
{

    int len= Exponent.length();

    if(strLen-1<len)
    {
        return -1;
    }

    int i=0;

    for(i=0; i<len; i++)
    {
        exponent[i]=Exponent[i];
    }
    for(; i<strLen; i++)
    {
        exponent[i]=0;
    }
    return len;
}

int XmlRSAKey::GetP(char* p,int strLen)
{
    int len= P.length();

    if(strLen-1<len)
    {
        return -1;
    }

    int i=0;

    for(i=0; i<len; i++)
    {
        p[i]=P[i];
    }
    for(; i<strLen; i++)
    {
        p[i]=0;
    }
    return len;
}

int XmlRSAKey::GetQ(char * q,int strLen)
{


    int len= Q.length();

    if(strLen-1<len)
    {
        return -1;
    }

    int i=0;

    for(i=0; i<len; i++)
    {
        q[i]=Q[i];
    }
    for(; i<strLen; i++)
    {
        q[i]=0;
    }
    return len;
}

int XmlRSAKey::GetDP(char* dp,int strLen)
{

    int len= DP.length();

    if(strLen-1<len)
    {
        return -1;
    }

    int i=0;

    for(i=0; i<len; i++)
    {
        dp[i]=DP[i];
    }
    for(; i<strLen; i++)
    {
        dp[i]=0;
    }
    return len;
}

int XmlRSAKey::GetDQ(char* dq,int strLen)
{


    int len= DQ.length();

    if(strLen-1<len)
    {
        return -1;
    }

    int i=0;

    for(i=0; i<len; i++)
    {
        dq[i]=DQ[i];
    }
    for(; i<strLen; i++)
    {
        dq[i]=0;
    }
    return len;
}

int XmlRSAKey::GetInverseQ(String inverseQ,int strLen)
{

    int len=  InverseQ.length();

    if(strLen-1<len)
    {
        return -1;
    }

    int i=0;

    for(i=0; i<len; i++)
    {
        inverseQ[i]=InverseQ[i];
    }
    for(; i<strLen; i++)
    {
        inverseQ[i]=0;
    }
    return len;
}

int XmlRSAKey::GetD(String d,int strLen)
{


    int len= D.length();

    if(strLen-1<len)
    {
        return -1;
    }

    int i=0;

    for(i=0; i<len; i++)
    {
        d[i]=D[i];
    }
    for(; i<strLen; i++)
    {
        d[i]=0;
    }
    return len;
}
