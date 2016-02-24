// RSAProvider.h: interface for the RSAProvider class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_RSAPROVIDER_H__E0D84573_984A_4775_A8AD_B21982929BBC__INCLUDED_)
#define AFX_RSAPROVIDER_H__E0D84573_984A_4775_A8AD_B21982929BBC__INCLUDED_


#include "BigInteger.h"
#include "Random.h"
#include "Base64.h"
#include "TypeDefinition.h"
#include "XmlRSAKey.h"

class RSAProvider
{
public:

    RSAProvider();

    RSAProvider(int bits);

    virtual ~RSAProvider();

    /*
    //content 为需加密的内容 cLen=Length(content)
    //返回加密结果 需要释放
    Byte *  Encrypt(Byte *  content,int cLen);

    //content 为需解密的内容 cLen=Length(content)
    //返回解密结果 需要释放
    Byte *  Decrypt(Byte *  content,int cLen);
    */

    //content 为需加密的内容 cLen=Length(content)
    //encrypted 为加密结果存储空间 enLen=Length(decrypted)  enlen=200
    //返回实际存储长度
    int Encrypt(Byte * content,int cLen,Byte *  encrypted,int enLen);


    //content 为需解密的内容 cLen=Length(content)
    //decrypted 为解密结果存储空间 deLen=Length(decrypted)
    //返回实际存储长度
    int Decrypt(Byte *  content,int cLen,Byte *  decrypted,int deLen);

    //密钥加密
    int EncryptByPrivate(Byte* content,int length,Byte* encrypted,int orgLength);

    //公钥解密
    int DecryptByPublic(Byte* content,int length,Byte* decrypted,int orgLength);


    //是否P==q
    bool IsSamePQ();


    //导出公钥或密钥
    string ToXmlString(bool includePrivateParams);

    //导入公钥或密钥
    void FromXmlString(string xmlString);

    //导出公钥或密钥
    int ToBytes(bool includePrivateParams,Byte* rsaBytes,int rbInLen);

    //导入公钥或密钥
    void FromBytes(Byte* rsaBytes,int rbLen);

private:
    //数1
    BigInteger one;

    //随机
    Random random;


    // 素数 P
    BigInteger p;

    // 素数 Q
    BigInteger q;

    // 素数 P－1
    BigInteger dp;

    // 素数Q－1
    BigInteger dq;

    // 数（P－1）*（Q－1）
    BigInteger u;


    // 公钥 exponent
    BigInteger e ;

    // 私钥 D
    BigInteger d ;

    // Modulus P*Q
    BigInteger n ;


    int exponent;

    //实际位数
    int bits;

    //虚拟长度
    int virtualBits;

    // 是否包含密钥
    bool includePrivateParams;
};

#endif // !defined(AFX_RSAPROVIDER_H__E0D84573_984A_4775_A8AD_B21982929BBC__INCLUDED_)
