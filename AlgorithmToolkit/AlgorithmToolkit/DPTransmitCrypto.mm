//
//  DPTransmitCrypto.m
//  Jackpot
//
//  Created by wufan on 15/9/10.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPTransmitCrypto.h"
#import "TransmitEncode.h"

using namespace TransmitEncode;

@implementation DPTransmitCrypto

+ (NSData *)sessionEncrypt:(NSData *)plaintext key:(NSData *)key {
    NSAssert(key.length == 16, @"Invaild key length.");
    
    unsigned char *ciphertext = NULL;
    int ciphertext_length = 0;
    
    bool success = des_encrypt((const unsigned char *)plaintext.bytes, (int)plaintext.length, &ciphertext, &ciphertext_length, (const unsigned char *)key.bytes);
    if (!success) {
        return nil;
    }
    
    NSData *data = [NSData dataWithBytes:ciphertext length:ciphertext_length];
    delete [] ciphertext;
    return data;
}

+ (NSData *)sessionDecrypt:(NSData *)ciphertext key:(NSData *)key {
    NSAssert(key.length == 16, @"Invaild key length.");
    
    unsigned char *plaintext = NULL;
    int plaintext_length = 0;
    
    bool success = des_decrypt((const unsigned char *)ciphertext.bytes, (int)ciphertext.length, &plaintext, &plaintext_length, (const unsigned char *)key.bytes);
    if (!success) {
        return nil;
    }
    
    NSData *data = [NSData dataWithBytes:plaintext length:plaintext_length];
    delete [] plaintext;
    return data;
}

@end
