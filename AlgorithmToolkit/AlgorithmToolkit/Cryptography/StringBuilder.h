// StringBuilder.h: interface for the StringBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_STRINGBUILDER_H__EB0F3154_20F3_4F02_B526_E72B4B2BA517__INCLUDED_)
#define AFX_STRINGBUILDER_H__EB0F3154_20F3_4F02_B526_E72B4B2BA517__INCLUDED_


#include "TypeDefinition.h"
#include <string>
using namespace std;

 const int StringBuilderExpandLen=1024;

class StringBuilder
{
public:
	StringBuilder();

	//指定初始化长度len
    StringBuilder(int len);

	virtual ~StringBuilder();

	//向StringBuilder添加字符串
	int Append(string str);

	//int Append(char * str);

	//输出字符串  需要释放
    string ToString();

	//输出strLen-1个字符，不足补0
	//返回实际输出字符长度
	int ToString(char* str,int strLen);

	//返回实际字符长度
	int GetLength();
private:
	char* data;
	int len;
	int position;

	void expand();

	void Init();


};

#endif // !defined(AFX_STRINGBUILDER_H__EB0F3154_20F3_4F02_B526_E72B4B2BA517__INCLUDED_)
