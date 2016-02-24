// RSAKey.h: interface for the RSAKey class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_RSAKEY_H__E015A97B_5BA4_4429_8600_BE608B3D8442__INCLUDED_)
#define AFX_RSAKEY_H__E015A97B_5BA4_4429_8600_BE608B3D8442__INCLUDED_


#include "TypeDefinition.h"
#include <string>
using namespace std;

class XmlRSAKey
{
public:
	XmlRSAKey();

	virtual ~XmlRSAKey();

	void SetXml(const string key);

	bool IsIncludePrivateKey();

	bool SetModulus(const string modules);

	bool SetExponent(const string exponent);

	bool SetP(const string p);

    bool SetQ(const string q);

	bool SetDP(const string dp);

	bool SetDQ(const string dq);

	bool SetInverseQ(const string inverseQ);

	bool SetD(const string d);


	int GetModulus(char* modules,int strLen);

	int GetExponent(char* exponent,int strLen);

	int GetP(char* p,int strLen);

    int GetQ(char* q,int strLen);

	int GetDP(char* dp,int strLen);

	int GetDQ(char* dq,int strLen);

	int GetInverseQ(char* inverseQ,int strLen);

	int GetD(char* d,int strLen);

	string GetXml();

private:
    string Modulus;
    string Exponent;
    string P;
    string Q;
    string DP;
    string DQ;
    string InverseQ;
    string D;

   string GetValue(const string content,const string key);

};

#endif // !defined(AFX_RSAKEY_H__E015A97B_5BA4_4429_8600_BE608B3D8442__INCLUDED_)
