﻿// DES.h: interface for the DES class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_DES_H__D824D167_DBD3_4684_8230_C971D098B81D__INCLUDED_)
#define AFX_DES_H__D824D167_DBD3_4684_8230_C971D098B81D__INCLUDED_



#include "TypeDefinition.h"

   const int DESByteBit[] = { 512, 256, 64, 32, 16, 4, 2, 1 };

   const int DESBigbyte[] = { 8388608, 4194304, 2097152, 1048576, 524288, 262144, 131072, 65536, 32768, 16384, 8192, 4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1 };

   const Byte DESTotrot[] = { 1, 2, 4, 6, 8, 10, 12, 14, 15, 17, 19, 21, 23, 25, 27, 28 };

   const Byte DESPc1[] = { 56, 48, 40, 32, 24, 16, 8, 0, 57, 49, 41, 33, 25, 17, 9, 1, 58, 50, 42, 34, 26, 18, 10, 2, 59, 51, 43, 35, 62, 54, 46, 38, 30, 22, 14, 6, 61, 53, 45, 37, 29, 21, 13, 5, 60, 52, 44, 36, 28, 20, 12, 4, 27, 19, 11, 3 };

   const Byte DESPc2[] = { 13, 16, 10, 23, 0, 4, 2, 27, 14, 5, 20, 9, 22, 18, 11, 3, 25, 7, 15, 6, 26, 19, 12, 1, 40, 51, 30, 36, 46, 54, 29, 39, 50, 44, 32, 47, 43, 48, 38, 55, 33, 52, 45, 41, 49, 35, 28, 31 };

   const int DESSP1[] = { 16843776, 0, 65536, 16843780, 16842756, 66564, 4, 65536, 1024, 16843776, 16843780, 1024, 16778244, 16842756, 16777216, 4, 1028, 16778240, 16778240, 66560,
    66560, 16842752, 16842752, 16778244, 65540, 16777220, 16777220, 65540, 0, 1028, 66564, 16777216, 65536, 16843780, 4, 16842752, 16843776, 16777216, 16777216, 1024, 16842756, 65536,
    66560, 16777220, 1024, 4, 16778244, 66564, 16843780, 65540, 16842752, 16778244, 16777220, 1028, 66564, 16843776, 1028, 16778240, 16778240, 0, 65540, 66560, 0, 16842756 };

/*
   const int DESSP2[] = {
	   -2146402272, -2147450880, 32768, 1081376, 1048576, 32, -2146435040, -2147450848,
	    -2147483616, -2146402272, -2146402304, 0x80000000, -2147450880, 1048576, 32, -2146435040,
	     1081344, 1048608, -2147450848, 0, 0x80000000, 32768, 1081376, -2146435072,
	     1048608, -2147483616, 0, 1081344, 32800, -2146402304, -2146435072, 32800,
	      0, 1081376, -2146435040, 1048576, -2147450848, -2146435072, -2146402304, 32768,
	       -2146435072, -2147450880, 32, -2146402272, 1081376, 32, 32768, 0x80000000,
	       32800, -2146402304, 1048576, -2147483616, 1048608, -2147450848, -2147483616, 1048608,
	       1081344, 0, -2147450880, 32800, 0x80000000, -2146435040, -2146402272, 1081344 };

*/

    const Uint DESSP2[]={
    2148565024u,2147516416u,32768u,1081376u,1048576u,32u,2148532256u,2147516448u,
    2147483680u,2148565024u,2148564992u,2147483648u,2147516416u,1048576u,32u,2148532256u,
    1081344u,1048608u,2147516448u,0u,2147483648u,32768u,1081376u,2148532224u,
    1048608u,2147483680u,0u,1081344u,32800u,2148564992u,2148532224u,32800u,
    0,1081376u,2148532256u,1048576u,2147516448u,2148532224u,2148564992u,32768u,
    2148532224u,2147516416u,32u,2148565024u,1081376u,32u,32768u,2147483648u,
    32800u,2148564992u,1048576u,2147483680u,1048608u,2147516448u,2147483680u,1048608u,
    1081344u,0u,2147516416u,32800u,2147483648u,2148532256u,2148565024u,1081344u
    };


/*
   const long DESSP2[] = {
	   -2146402272, -2147450880, 32768, 1081376, 1048576, 32, -2146435040, -2147450848,
	    -2147483616, -2146402272, -2146402304, -2147483648, -2147450880, 1048576, 32, -2146435040,
	     1081344, 1048608, -2147450848, 0, -2147483648, 32768, 1081376, -2146435072,
	     1048608, -2147483616, 0, 1081344, 32800, -2146402304, -2146435072, 32800,
	      0, 1081376, -2146435040, 1048576, -2147450848, -2146435072, -2146402304, 32768,
	       -2146435072, -2147450880, 32, -2146402272, 1081376, 32, 32768, -2147483648,
	       32800, -2146402304, 1048576, -2147483616, 1048608, -2147450848, -2147483616, 1048608,
	       1081344, 0, -2147450880, 32800, -2147483648, -2146435040, -2146402272, 1081344 };
*/

    const int DESSP3[] = { 520, 134349312, 0, 134348808, 134218240, 0, 131592, 134218240, 131080, 134217736, 134217736, 131072, 134349320, 131080, 134348800, 520, 134217728, 8, 134349312, 512,
    131584, 134348800, 134348808, 131592, 134218248, 131584, 131072, 134218248, 8, 134349320, 512, 134217728, 134349312, 134217728, 131080, 520, 131072, 134349312, 134218240, 0, 512, 131080,
    134349320, 134218240, 134217736, 512, 0, 134348808, 134218248, 131072, 134217728, 134349320, 8, 131592, 131584, 134217736, 134348800, 134218248, 520, 134348800, 131592, 8, 134348808, 131584 };

    const int DESSP4[] = { 8396801, 8321, 8321, 128, 8396928, 8388737, 8388609, 8193, 0, 8396800, 8396800, 8396929, 129, 0, 8388736, 8388609, 1, 8192, 8388608, 8396801,
    128, 8388608, 8193, 8320, 8388737, 1, 8320, 8388736, 8192, 8396928, 8396929, 129, 8388736, 8388609, 8396800, 8396929, 129, 0, 0, 8396800, 8320, 8388736,
    8388737, 1, 8396801, 8321, 8321, 128, 8396929, 129, 1, 8192, 8388609, 8193, 8396928, 8388737, 8193, 8320, 8388608, 8396801, 128, 8388608, 8192, 8396928 };

    const int DESSP5[] = { 256, 34078976, 34078720, 1107296512, 524288, 256, 1073741824, 34078720, 1074266368, 524288, 33554688, 1074266368, 1107296512, 1107820544, 524544, 1073741824, 33554432, 1074266112, 1074266112,
    0, 1073742080, 1107820800, 1107820800, 33554688, 1107820544, 1073742080, 0, 1107296256, 34078976, 33554432, 1107296256, 524544, 524288, 1107296512, 256, 33554432, 1073741824, 34078720, 1107296512, 1074266368, 33554688, 1073741824,
    1107820544, 34078976, 1074266368, 256, 33554432, 1107820544, 1107820800, 524544, 1107296256, 1107820800, 34078720, 0, 1074266112, 1107296256, 524544, 33554688, 1073742080, 524288, 0, 1074266112, 34078976, 1073742080 };

    const int DESSP6[] = { 536870928, 541065216, 16384, 541081616, 541065216, 16, 541081616, 4194304, 536887296, 4210704, 4194304, 536870928, 4194320, 536887296, 536870912, 16400, 0, 4194320, 536887312, 16384,
    4210688, 536887312, 16, 541065232, 541065232, 0, 4210704, 541081600, 16400, 4210688, 541081600, 536870912, 536887296, 16, 541065232, 4210688, 541081616, 4194304, 16400, 536870928, 4194304, 536887296,
    536870912, 16400, 536870928, 541081616, 4210688, 541065216, 4210704, 541081600, 0, 541065232, 16, 16384, 541065216, 4210704, 16384, 4194320, 536887312, 0, 541081600, 536870912, 4194320, 536887312 };

    const int DESSP7[] = { 2097152, 69206018, 67110914, 0, 2048, 67110914, 2099202, 69208064, 69208066, 2097152, 0, 67108866, 2, 67108864, 69206018, 2050, 67110912, 2099202, 2097154, 67110912,
    67108866, 69206016, 69208064, 2097154, 69206016, 2048, 2050, 69208066, 2099200, 2, 67108864, 2099200, 67108864, 2099200, 2097152, 67110914, 67110914, 69206018, 69206018, 2, 2097154, 67108864,
    67110912, 2097152, 69208064, 2050, 2099202, 69208064, 2050, 67108866, 69208066, 69206016, 2099200, 0, 2, 69208066, 0, 2099202, 69206016, 2048, 67108866, 67110912, 2048, 2097154 };

    const int DESSP8[] = { 268439616, 4096, 262144, 268701760, 268435456, 268439616, 64, 268435456, 262208, 268697600, 268701760, 266240, 268701696, 266304, 4096, 64, 268697600, 268435520, 268439552, 4160,
    266240, 262208, 268697664, 268701696, 4160, 0, 0, 268697664, 268435520, 268439552, 266304, 262144, 266304, 262144, 268701696, 4096, 64, 268697664, 4096, 266304, 268439552, 64,
    268435520, 268697600, 268697664, 268435456, 262144, 268439616, 0, 268701760, 262208, 268435520, 268697600, 268439552, 268439616, 0, 268701760, 266240, 266240, 4160, 4160, 262208, 268435456, 268701696 };
    const int DESBLOCKSIZE = 8;

class DES
{
public:
	DES();
	virtual ~DES();

	//设置key 该key为字节数组
	//keyLen=Length(key)
    void SetKey(Byte* key,int keyLen);

	//解密
	//src为待解密字节数组
	//srcLen=Length(src)
	//decryptedArray为解密后存储数组，需先分配空间
	//daLen=Length(decryptedArray) daLen可以等于srcLen
	//返回decryptedArray长度等于srcLen
	int Decrypt(Byte* src,int srcLen,Byte* decryptedArray,int daLen);

	//加密
	//src为待加密数组
	//srcLen=Length(src)
	//encryptedArray为加密后存储数组，需先分配空间
	//enLen=Length(decryptedArray)  enLen可以等于((srcLen/8)+1)*8
	//返回encryptedArray实际长度
    int Encrypt(Byte* src,int srcLen,Byte* encryptedArray,int enLen);


private:
	    int* enKey;

        int* deKey;

		int* Genkey(bool encrypting, Byte* key,int keyLen);

		void DesFunc(int* wKey, Byte* ins, int inOff, Byte* outArray, int outOff);
};

#endif // !defined(AFX_DES_H__D824D167_DBD3_4684_8230_C971D098B81D__INCLUDED_)
