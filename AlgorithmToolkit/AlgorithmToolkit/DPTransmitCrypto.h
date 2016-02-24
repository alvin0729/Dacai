//
//  DPTransmitCrypto.h
//  Jackpot
//
//  Created by wufan on 15/9/10.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPTransmitCrypto : NSObject

/**
 *  DES 加密
 *
 *  @param plaintext [in]明文
 *  @param key       [in]密钥
 *
 *  @return 加密后的密文
 */
+ (NSData *)sessionEncrypt:(NSData *)plaintext key:(NSData *)key;

/**
 *  DES 解密
 *
 *  @param ciphertext [in]密文
 *  @param key        [in]密钥
 *
 *  @return 解密后的明文
 */
+ (NSData *)sessionDecrypt:(NSData *)ciphertext key:(NSData *)key;

@end
