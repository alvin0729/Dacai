// Base64.h: interface for the Base64 class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_BASE64_H__6BFF012A_D9E7_4F85_BDC5_8E7B9EDB6933__INCLUDED_)
#define AFX_BASE64_H__6BFF012A_D9E7_4F85_BDC5_8E7B9EDB6933__INCLUDED_

#include "TypeDefinition.h"

const  Byte Base64EncodingTable[64] = { 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83,
    84, 85, 86, 87, 88, 89, 90, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111,
    112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 43,
    47 };

const  Byte Base64DecodingTable[128] = {
255,255,255,255,255,255,255,255,255,255,
255,255,255,255,255,255,255,255,255,255,
255,255,255,255,255,255,255,255,255,255,
255,255,255,255,255,255,255,255,255,255,//40

255,255,255,62,255,255,255,63,52,53, //50

54,55,56,57,58,59,60,61,255,255,//60

255,255,255,255,255,0,1,2,3,4,//70

5,6,7,8,9,10,11,12,13,14,//80

15,16,17,18,19,20,21,22,23,24,//90

25,255,255,255,255,255,255,26,27,28, //100

29,30,31,32,33,34,35,36,37,38,//110

39,40,41,42,43,44,45,46,47,48,//120

49,50,51,255,255,255,255,255

};

class Base64
{
public:

	//编码
	//sourceBytes 为源字节数组 sourceLen=length(sourceBytes)
	//encodedBytes 为存储加密数组 需先分配空间 enlen=Length(encodedBytes); enLen可以等于(sourceLen*4/3)+1
	static int 	Encode(Byte* sourceBytes,int sourceLen,Byte* encodedBytes,int enLen);

	//解码
	//encodedBytes 加密后数组 enLen=Length(encodedBytes)
    //decodeBytes 为存储解密数组 需先分配空间 deLen=Length(decodeBytes);   deLen可以等于(enLen*3/4)+1
	static int 	Decode(Byte* encodedBytes,int enLen,Byte* decodeBytes,int deLen);

private:
	static int DiscardNonBase64Bytes(Byte* encodedBytes,int enLen,Byte* &discardResult);

	static bool IsValidBase64Byte(Byte byte);
};

#endif // !defined(AFX_BASE64_H__6BFF012A_D9E7_4F85_BDC5_8E7B9EDB6933__INCLUDED_)
