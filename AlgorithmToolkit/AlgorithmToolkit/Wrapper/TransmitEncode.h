//
//  TransmitEncode.h
//  DacaiLibrary
//
//  Created by wufan on 15/9/10.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#ifndef __DacaiLibrary__TransmitEncode__
#define __DacaiLibrary__TransmitEncode__

#include <stdio.h>

namespace TransmitEncode {
    
    /**
     *  DES 加密算法
     *
     *  @param plaintext         [in]明文
     *  @param plaintext_length  [in]明文长度, 单位 Byte
     *  @param ciphertext        [out]加密后的密文, 需要调用者使用 delete [] 释放内存
     *  @param ciphertext_length [out]加密后的密文长度, 单位 Byte
     *  @param des_key           [in]密钥
     *
     *  @return 成功返回 true
     */
    bool des_encrypt(const unsigned char *plaintext,
                     int plaintext_length,
                     unsigned char **ciphertext,
                     int *ciphertext_length,
                     const unsigned char des_key[16]);
    
    /**
     *  DES 解密密算法
     *
     *  @param ciphertext        [in]密文
     *  @param ciphertext_length [in]密文长度, 单位 Byte
     *  @param plaintext         [out]解密后的明文, 需要调用者使用 delete [] 释放内存
     *  @param plaintext_length  [out]解密后的明文长度, 单位 Byte
     *  @param des_key           [in]密钥
     *
     *  @return 成功返回 true
     */
    bool des_decrypt(const unsigned char *ciphertext,
                     int ciphertext_length,
                     unsigned char **plaintext,
                     int *plaintext_length,
                     const unsigned char des_key[16]);
    
}

#endif /* defined(__DacaiLibrary__TransmitEncode__) */
