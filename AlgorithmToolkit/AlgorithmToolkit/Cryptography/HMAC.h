// HMAC.h: interface for the HMAC class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_HMAC_H__E036FE59_F59F_4783_AC46_3D977FDCA67F__INCLUDED_)
#define AFX_HMAC_H__E036FE59_F59F_4783_AC46_3D977FDCA67F__INCLUDED_


#include "MD5.h"


class HMAC
{
public:
	HMAC();
	virtual ~HMAC();

	//摘要
	//rawkey为摘要key rkLen=Length(rawkey)
	//source 为需摘要的内容 srcLen=Length(srcLen)
	//digestedArray 存储摘要字节数组 daLen可以等于16位
	//返回摘要长度16位
	int Digest(Byte* rawkey,int rkLen, Byte* source,int srcLen,Byte *digestedArray,int daLen);
private:
	MD5 md5;
};

#endif // !defined(AFX_HMAC_H__E036FE59_F59F_4783_AC46_3D977FDCA67F__INCLUDED_)
