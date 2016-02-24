// Random.h: interface for the Random class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_RANDOM_H__5FACECF6_027F_4BC7_A1F4_F6DED8224732__INCLUDED_)
#define AFX_RANDOM_H__5FACECF6_027F_4BC7_A1F4_F6DED8224732__INCLUDED_


const int RandomRandMax=32767;
const double RandomDoubleMax=1073741826;//2^30+2

class Random
{
public:
	Random(void);
	~Random(void);

    //产生15位随机正数
	int NextShort();

	//产生双精度浮点随机正数 （0~1,不含0，1） 总个数=Uint个
	double NextDouble();

	//产生无符号32位随机数
	unsigned int NextUint();

	//产生31位随机正数
	int NextValue();

	//产生1到max 的随机正数
	int NextValue(int max);

	//产生min到max 的随机正数
	int NextValue(int min,int max);

};



#endif // !defined(AFX_RANDOM_H__5FACECF6_027F_4BC7_A1F4_F6DED8224732__INCLUDED_)
