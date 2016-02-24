// MD5.h: interface for the MD5 class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MD5_H__1FE47746_55B6_4489_9CD4_382B03923F9B__INCLUDED_)
#define AFX_MD5_H__1FE47746_55B6_4489_9CD4_382B03923F9B__INCLUDED_


#include "TypeDefinition.h"

  const int MD5S11 = 7;
  const int MD5S12 = 12;
  const int MD5S13 = 17;
  const int MD5S14 = 22;

  const int MD5S21 = 5;
  const int MD5S22 = 9;
  const int MD5S23 = 14;
  const int MD5S24 = 20;

  const int MD5S31 = 4;
  const int MD5S32 = 11;
  const int MD5S33 = 16;
  const int MD5S34 = 23;

  const int MD5S41 = 6;
  const int MD5S42 = 10;
  const int MD5S43 = 15;
  const int MD5S44 = 21;

  const Byte MD5PADDING[] = { 128, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

  const char MD5Digit[] = { '0','1','2','3','4','5','6','7','8','9',
            'A','B','C','D','E','F' };


class MD5
{
public:
	MD5();
	virtual ~MD5();

	//摘要返回32位字符
	//dlen=Length(digested)  要求>=32
	//srcLen=Length(src);
	int Digest(Byte *src,int srcLen,char* digested,int dLen);

	//摘要 返回16位字节
	//dlen=Length(digested) 要求>=16
	//srcLen=Length(src);
	int Digest(Byte *src,int srcLen,Byte* digested,int dLen);

private:
	  Int64 state[4]; // state (ABCD)
      Int64 count[2]; // number of bits, modulo 2^64 (lsb first)

	  Byte buffer[64]; // input buffer

	  Byte digestedBytes[16];

	  void Md5Init();

	  void Md5Update(const Byte* inbuf, int inputLen);

	  void Md5Final();

	  void Md5Memcpy(Byte* output,const Byte* input, int outpos, int inpos, int len);

	  void Md5Transform(Byte* block);

      void Encode(Byte* output, Int64* input, int len);

	  void Decode(Int64* output, Byte* input, int len);

	  static Int64 F(Int64 x, Int64 y, Int64 z);

	  static Int64 G(Int64 x, Int64 y, Int64 z);

	  static Int64 H(Int64 x, Int64 y, Int64 z);

	  static Int64 I(Int64 x, Int64 y, Int64 z);

	  static Int64 FF(Int64 a, Int64 b, Int64 c, Int64 d, Int64 x, Int64 s,Int64 ac);

	  static Int64 GG(Int64 a, Int64 b, Int64 c, Int64 d, Int64 x, Int64 s,Int64 ac);

	  static Int64 HH(Int64 a, Int64 b, Int64 c, Int64 d, Int64 x, Int64 s,Int64 ac);

	  static Int64 II(Int64 a, Int64 b, Int64 c, Int64 d, Int64 x, Int64 s,Int64 ac);


public:
	  static void ByteHEX(Byte byte,char* src,int srcLen,int index);

};

#endif // !defined(AFX_MD5_H__1FE47746_55B6_4489_9CD4_382B03923F9B__INCLUDED_)
