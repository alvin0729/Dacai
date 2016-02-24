//
//  TransmitEncode.cpp
//  DacaiLibrary
//
//  Created by wufan on 15/9/10.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#include "TransmitEncode.h"
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include "DES.h"

namespace TransmitEncode {
    
    /*
     *  填充格式:
     *  8 byte | padding byte | data byte | 8 byte
     *
     *  具体格式:
     *  8 byte: 随机流, 最后一字节后3位表示 date byte 补齐 8 byte 需要的字节数, 后3bit的值记为padding
     *  padding byte: 随机流, 即 8byte中的 n
     *  data byte: 源数据
     *  8 byte: 数据校验
     *
     */
    int des_input_stream(const unsigned char *data, int length, unsigned char **block_steam) {
        int mod = length % 8;
        int padding = mod == 0 ? 0 : (8 - mod);
        
        srand(time(0));
        
        unsigned char *buffer = new unsigned char[8 + padding + length + 8];
        
        // 生成8+padding字节的随机流
        for (int i = 0; i < 8 + padding; i++) {
            buffer[i] = (unsigned char)rand();
        }
        // 第8个字节后3位保存数据长度取余的结果
        buffer[7] &= 0xF8;
        buffer[7] |= 0xFF & padding;
        // 数据
        memcpy(buffer + 8 + padding, data, length);
        // 最后8字节作为数据校验位
        for (int i = 0; i < 8; i++) {
            buffer[8 + padding + length + i] = buffer[i] ^ buffer[8 + padding + length - 1 - i];
        }
        
        *block_steam = buffer;
        return 8 + padding + length + 8;
    }
    
    
    int des_output_stream(const unsigned char *block_steam, int size, unsigned char **data) {
        // 获取填充位数
        int padding = block_steam[7] & 0x07;
        // 计算原始数据长度
        int length = size - 16 - padding;
        // 验证数据正确性
        for (int i = 0; i < 8; i++) {
            if (block_steam[8 + padding + length + i] != (block_steam[i] ^ block_steam[8 + padding + length - 1 - i])) {
                return 0;
            }
        }
        *data = new unsigned char[static_cast<int>(length)];
        memcpy(*data, block_steam + 8 + padding, length);
        return length;
    }

    bool des_encrypt(const unsigned char *plaintext,
                     int plaintext_length,
                     unsigned char **ciphertext,
                     int *ciphertext_length,
                     const unsigned char des_key[16]) {
    
        // 初始化
        *ciphertext = NULL;
        *ciphertext_length = 0;
        
        // padding 操作
        unsigned char *block_stream = NULL;
        int block_length = des_input_stream(plaintext, plaintext_length, &block_stream);
        if (block_length == 0) {
            return false;
        }
        
        unsigned char *bytes = new unsigned char[block_length + 8];
        
        DES des;
        des.SetKey((Byte *)des_key, 16);
        int bytes_length = des.Encrypt(block_stream, block_length, bytes, block_length + 8);
        
        // 释放内存
        delete [] block_stream;
        
        // 加密失败
        if (bytes_length <= 0) {
            delete [] bytes;
            return false;
        }
        
        *ciphertext = bytes;
        *ciphertext_length = bytes_length;
        
        return true;
    }
    
    bool des_decrypt(const unsigned char *ciphertext,
                     int ciphertext_length,
                     unsigned char **plaintext,
                     int *plaintext_length,
                     const unsigned char des_key[16]) {
        
        // 初始化
        *plaintext = NULL;
        *plaintext_length = 0;
        
        unsigned char *bytes = new unsigned char[ciphertext_length + 8];
        
        DES des;
        des.SetKey((Byte *)des_key, 16);
        int bytes_length = des.Decrypt((Byte *)ciphertext, ciphertext_length, bytes, ciphertext_length + 8);
        
        // 解密失败
        if (bytes_length <= 0) {
            delete [] bytes;
            return false;
        }
        
        
        unsigned char *block_steam = NULL;
        int block_length = des_output_stream(bytes, bytes_length, &block_steam);
        
        // 释放内存
        delete [] bytes;
        
        if (block_length == 0) {
            return false;
        }
        
        *plaintext = block_steam;
        *plaintext_length = block_length;
        
        return true;
    }
    
}