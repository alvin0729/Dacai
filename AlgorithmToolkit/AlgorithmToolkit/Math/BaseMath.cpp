//
//  BaseMath.cpp
//  DacaiProject
//
//  Created by WUFAN on 14-7-2.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#include "BaseMath.h"
#include <stdlib.h>
#include <assert.h>
#include <string.h>

void CMathHelper::MemoryCopy(void *dst, const void *src, size_t n) {
    memcpy(dst, src, n);
}

void CMathHelper::ZeroMemory(void *s, size_t n) {
    memset(s, 0, n);
}

bool CMathHelper::IsZero(void *mem, size_t n) {
    unsigned int  int_count = n / sizeof(unsigned int);
    unsigned int *int_point = static_cast<unsigned int *>(mem);
    for (int i = 0; i < int_count; i++) {
        if (int_point[i]) {
            return false;
        }
    }
    
    unsigned int   char_count = n - int_count * sizeof(unsigned int);
    unsigned char *char_point = static_cast<unsigned char *>(mem) + int_count * sizeof(unsigned int);
    for (int i = 0; i < char_count; i++) {
        if (char_point[i]) {
            return false;
        }
    }
    return true;
}

int CMathHelper::GetCombinationInt(int n, int m) {
    if (n < m || m <= 0 || n <= 0) {
        return 0;
    }
    
    // n! / (m! * (n - m)!)
    unsigned long long denominator = 1;
    unsigned long long member = 1;
    
    int min = m;
    int max = n - m;
    if (min > max) {
        std::swap(min, max);
    }
    
    for (int i = max + 1; i <= n; i++) {
        denominator *= i;
    }
    for (int i = 1; i <= min; i++) {
        member *= i;
    }
    
    return static_cast<int>(denominator / member);
}

vector<char *> CMathHelper::GetCombinationGroup(const char *source, int length, int count) {
    int * rangeLowers = new int[count];
    int * rangeUppers = new int[count];
    int * currentIndexs = new int[count];
    
    vector<char *> groups;
    
    for (int i = 0; i < count; i++) {
        rangeLowers[i] = i;
        rangeUppers[i] = length - count + i;
        currentIndexs[i] = i;
    }

    bool carry = true;
    do {
        char *sub = new char[count];
        for (int i = 0; i < count; i++) {
            sub[i] = source[currentIndexs[i]];
        }
        groups.push_back(sub);

        carry = true;   // 需要进位
        for (int i = count - 1; carry && i >= 0; i--) {
            carry = currentIndexs[i] >= rangeUppers[i];
            if (!carry) {
                currentIndexs[i]++;
                for (int j = 1; j < count - i; j++) {
                    currentIndexs[i + j] = currentIndexs[i] + j;
                }
            }
        }
    } while (!carry);
    
    delete []rangeLowers;
    delete []rangeUppers;
    delete []currentIndexs;
    
    return groups;
}

void CMathHelper::ClearGroup(vector<char *> groups) {
    for (int i = groups.size() - 1; i >= 0; i--) {
        char * sub = groups[i];
        groups.pop_back();
        delete [] sub;
    }
}

void CMathHelper::OrderIntAscending(int *array, int length) {
    for (int i = 0; i < length; i++) {
        bool hasSwaped = false;
        for (int j = 0; j < length - i - 1; j++) {
            if (array[j] > array[j + 1]) {
                hasSwaped = true;
                std::swap(array[j], array[j + 1]);
            }
        }
        if (!hasSwaped) {
            break;
        }
    }
}

void CMathHelper::OrderIntDescending(int *array, int length) {
    for (int i = 0; i < length; i++) {
        bool hasSwaped = false;
        for (int j = 0; j < length - i - 1; j++) {
            if (array[j] < array[j + 1]) {
                hasSwaped = true;
                std::swap(array[j], array[j + 1]);
            }
        }
        if (!hasSwaped) {
            break;
        }
    }
}

int CMathHelper::IntersectIntSet(int *array1, int lenght1, int *array2, int length2, int *array, int length, int &size) {
    assert(array1 != array && array2 != array);
    int outsize = 0;
    for (int i = 0, j = 0; i < lenght1 && j < length2; ) {
        if (array1[i] > array2[j]) {
            j++;
        } else if (array1[i] < array2[j]) {
            i++;
        } else {
            if (outsize + 1 > length) {
                return -1;
            }
            array[outsize++] = array1[i];
            j++; i++;
        }
    }
    size = outsize;
    
    return 0;
}

// options 为有序数组
//template <typename T>
//void CombinationSplit(T * options, int length, int count) {
//    int * rangeLowers = static_cast<int *>(alloca(sizeof(int) * count));
//    int * rangeUppers = static_cast<int *>(alloca(sizeof(int) * count));
//    int * currentIndexs = static_cast<int *>(alloca(sizeof(int) * count));
//    
//    for (int i = 0; i < count; i++) {
//        rangeLowers[i] = i;
//        rangeUppers[i] = length - count + i;
//        currentIndexs[i] = i;
//    }
//    
//    bool carry = true;
//    do {
//        for (int i = 0; i < count; i++) {
//            printf("%d  ", options[currentIndexs[i]]);
//        }
//        printf("\n");
//        
//        carry = true;   // 需要进位
//        for (int i = count - 1; carry && i >= 0; i--) {
//            carry = currentIndexs[i] >= rangeUppers[i];
//            if (!carry) {
//                currentIndexs[i]++;
//                for (int j = 1; j < count - i; j++) {
//                    currentIndexs[i + j] = currentIndexs[i] + j;
//                }
//            }
//        }
//    } while (!carry);
//}

#include "RSAProvider.h"
#include "DES.h"
#include "MD5.h"
#include "HMAC.h"
#include <time.h>

namespace CryptUtilities {
    
//    /* HTTP gzip decompress */
//    int httpgzdecompress(Byte *zdata, uLong nzdata,
//                         Byte *data, uLong *ndata)
//    {
//        int err = 0;
//        z_stream d_stream = {0}; /* decompression stream */
//        static char dummy_head[2] =
//        {
//            0x8 + 0x7 * 0x10,
//            (((0x8 + 0x7 * 0x10) * 0x100 + 30) / 31 * 31) & 0xFF,
//        };
//        d_stream.zalloc = (alloc_func)0;
//        d_stream.zfree = (free_func)0;
//        d_stream.opaque = (voidpf)0;
//        d_stream.next_in  = zdata;
//        d_stream.avail_in = 0;
//        d_stream.next_out = data;
//        if(inflateInit2(&d_stream, 47) != Z_OK) return -1;
//        while (d_stream.total_out < *ndata && d_stream.total_in < nzdata) {
//            d_stream.avail_in = d_stream.avail_out = 1; /* force small buffers */
//            if((err = inflate(&d_stream, Z_NO_FLUSH)) == Z_STREAM_END) break;
//            if(err != Z_OK )
//            {
//                if(err == Z_DATA_ERROR)
//                {
//                    d_stream.next_in = (Bytef*) dummy_head;
//                    d_stream.avail_in = sizeof(dummy_head);
//                    if((err = inflate(&d_stream, Z_NO_FLUSH)) != Z_OK)
//                    {
//                        return -1;
//                    }
//                }
//                else return -1;
//            }
//        }
//        if(inflateEnd(&d_stream) != Z_OK) return -1;
//        *ndata = d_stream.total_out;
//        return 0;
//    }

    
    int encrypt(const unsigned char *plaintext, const int len, unsigned char *ciphertext, const int buffsize, const RSAProvider *pRSAProvider) {
        int mix_type = 0;   // 混淆方式
        
        /**
         *  header(part1):
         *    |--type_header(16 bytes)--|
         *
         *    type 1(part2):
         *      |--range_header(16 bytes)--|--rand_stream(256 bytes)--|
         *
         *    data 1(part3):
         *      |--rand stream--|--public_key(location: public_key_pos, length: public_key_len)--|
         *      |--rand stream--|--output(location: output_key_pos, length: output_key_len)--|--rand stream--|
         *
         *
         *  output:
         *    |--part1--|--part2--|--part3--|
         */
        
        srand(time(0));
        // ==========类型部分
        // ==========|--type_header(16 bytes)--|
        
        unsigned char type_header[16];
        for (int i = 0; i < 16; i++) {  // 填充随机数
            type_header[i] = rand() & 0xff;
        }
        // 通过type_header中第一字节byte1的后三位定位到下一个字节byte2, 在由byte2的后三位找到byte3, 以此
        // 类推, 经过三次操作后, 定位到bytek, 得到bytek后3位值, 即得到type_index, 以上
        // 操作肯定被限制在type_header索引为0~7的位置上
        int type_index = 0;
        for (int i = 0; i < 3; i++) {
            type_index = type_header[type_index] & 0x07;
        }
        // 此时满足 type_index >= 0 && type_index < 8
        // 得到 type_header 中位于第 8 + type_index 和第 8 + type_index + 1 上的字节
        // (如果 8 + type_index + 1 == 16, 则取位于第 0 位上的字节), 得到b1, b2, 用b1的最后
        // 1位和b2的前2位组成的3为数字表示mix_type(我们约定共有8种形式, 所以有 mix_type >= 0 && mix_type < 8)
        type_header[8 + type_index] = (type_header[8 + type_index] & 0xfe) | ((mix_type & 0x04) >> 2);
        if (8 + type_index + 1 == 16) {
            type_header[0] = (type_header[0] & 0x3f) | ((mix_type & 0x03) << 6);
        } else {
            type_header[8 + type_index + 1] = (type_header[8 + type_index + 1] & 0x3f) | ((mix_type & 0x03) << 6);
        }
        
        // ============|--range_header(16 bytes)--|
        // 标记位, 0-3标记公钥pos, 4-7标记公钥len, 8-11标记密文pos, 12-15标记密文len
        unsigned char rand_byte[16] = { 0 };
        // 生成16个互不相等的byte
        for (int i = 0, j = 0; i < 16; i++, j = 0) {
            rand_byte[i] = rand() & 0xff;
            while (j < i) {
                if (rand_byte[i] == rand_byte[j]) {
                    rand_byte[i]++; // char: 255 + 1 = 0
                    j = 0;
                } else {
                    j++;
                }
            }
        }
        
        // 将rand_byte写入range_header中, 用range_header第一个字节的后4位+第二个字节的前4位表示rand_byte的第
        // 一位, 以此类推, range_header第十五字节的后4位+第一个字节的前4位表示rand_byte的第15位
        unsigned char range_header[16];
        for (int i = 0; i < 16; i++) {
            range_header[i] = ((rand_byte[i] & 0xf0) >> 4) | (range_header[i] & 0xf0);
            if (i == 15) {
                range_header[0] = ((rand_byte[i] & 0x0f) << 4) | (range_header[0] & 0x0f);
            } else {
                range_header[i + 1] = ((rand_byte[i] & 0x0f) << 4) | (range_header[i + 1] & 0x0f);
            }
        }
        
        memcpy(ciphertext, type_header, sizeof(unsigned char) * 16);
        memcpy(ciphertext + 16, range_header, sizeof(unsigned char) * 16);
        
        // ==========rand stream
        // 生成随机流
        bool key_data_first = rand() % 2;   // 密钥or数据在前, true表示密钥在前
        int rand_len1 = 100 + rand() % 300; // 100~399
        int rand_len2 = 100 + rand() % 300; // 100~399
        int rand_len3 = 100 + rand() % 300; // 100~399
        
        unsigned char *rand_stream1 = new unsigned char[rand_len1];
        unsigned char *rand_stream2 = new unsigned char[rand_len2];
        unsigned char *rand_stream3 = new unsigned char[rand_len3];
        for (int i = 0; i < rand_len1; i++) {
            rand_stream1[i] = rand() & 0xff;
        }
        for (int i = 0; i < rand_len2; i++) {
            rand_stream2[i] = rand() & 0xff;
        }
        for (int i = 0; i < rand_len3; i++) {
            rand_stream3[i] = rand() & 0xff;
        }
        
        unsigned char *rsa_out_buf = new unsigned char[len + 64];
        // 生成rsa公钥
        RSAProvider &provider = *const_cast<RSAProvider *>(pRSAProvider);
        int rsa_out_len = provider.EncryptByPrivate((Byte *)plaintext, len, rsa_out_buf, len + 64);
        
        // 对原始数据进行rsa加密
        unsigned char rsa_public_key_buff[100];
        int rsa_public_key_len = provider.ToBytes(false, rsa_public_key_buff, 100);
        
        // 生成des key
        unsigned char des_key_input[32];
        for (int i = 0; i < 16; i++) {
            des_key_input[i] = type_header[i] ^ rand_stream1[i];
            des_key_input[i + 16] = range_header[i] ^ rand_stream1[i + 16];
        }
        
        // 对公钥进行摘要, 做为对数据进行二次加密的des key
        unsigned char hmac_key_buf[16];
        HMAC hmac;
        hmac.Digest(des_key_input, 32, rsa_public_key_buff, rsa_public_key_len, hmac_key_buf, 16);
        
        // 位到转
        for (int i = 0; i < rsa_out_len; i++) {
            rsa_out_buf[i] = ((rsa_out_buf[i] & 0xf0) >> 4) | ((rsa_out_buf[i] & 0x0f) << 4);
        }
        
        DES desCrypt;
        desCrypt.SetKey(hmac_key_buf, 16);
        unsigned char *raw_buf = new unsigned char[rsa_out_len + 100];
        int raw_buf_len = desCrypt.Encrypt(rsa_out_buf, rsa_out_len, raw_buf, rsa_out_len + 100);
        
        // 对公钥进行加密
        desCrypt.SetKey(des_key_input, 32);
        unsigned char *raw_key_buf = new unsigned char[rsa_public_key_len + 100];
        int raw_key_len = desCrypt.Encrypt(rsa_public_key_buff, rsa_public_key_len, raw_key_buf, rsa_public_key_len + 100);
        
        int raw_buf_pos = 0;
        int raw_key_pos = 0;
        
        // ==========进行混淆
        // ==========|--rand stream--|--public_key(location: public_key_pos, length: public_key_len)--|--rand stream--|--output(location: output_key_pos, length: output_key_len)--|--rand stream--|
        unsigned char *buff = ciphertext + 32 + 256;
        if (key_data_first) {
            raw_key_pos = rand_len1;
            raw_buf_pos = rand_len1 + raw_key_len + rand_len2;
            
            memcpy(buff, rand_stream1, rand_len1);
            buff += rand_len1;
            memcpy(buff, raw_key_buf, raw_key_len);
            buff += raw_key_len;
            memcpy(buff, rand_stream2, rand_len2);
            buff += rand_len2;
            memcpy(buff, raw_buf, raw_buf_len);
            buff += raw_buf_len;
            memcpy(buff, rand_stream3, rand_len3);
        } else {
            raw_buf_pos = rand_len1;
            raw_key_pos = rand_len1 + raw_buf_len + rand_len2;
            
            memcpy(buff, rand_stream1, rand_len1);
            buff += rand_len1;
            memcpy(buff, raw_buf, raw_buf_len);
            buff += raw_buf_len;
            memcpy(buff, rand_stream2, rand_len2);
            buff += rand_len2;
            memcpy(buff, raw_key_buf, raw_key_len);
            buff += raw_key_len;
            memcpy(buff, rand_stream3, rand_len3);
        }
        
        // ===========|--rand_stream(256 bytes)--|
        unsigned char rand_stream[256];
        for (int i = 0; i < 256; i++) {
            rand_stream[i] = rand() & 0xff;
        }
        rand_stream[rand_byte[0]] = (raw_buf_pos & 0xff000000) >> 24;
        rand_stream[rand_byte[1]] = (raw_buf_pos & 0x00ff0000) >> 16;
        rand_stream[rand_byte[2]] = (raw_buf_pos & 0x0000ff00) >> 8;
        rand_stream[rand_byte[3]] = (raw_buf_pos & 0x000000ff) >> 0;
        
        rand_stream[rand_byte[4]] = (raw_buf_len & 0xff000000) >> 24;
        rand_stream[rand_byte[5]] = (raw_buf_len & 0x00ff0000) >> 16;
        rand_stream[rand_byte[6]] = (raw_buf_len & 0x0000ff00) >> 8;
        rand_stream[rand_byte[7]] = (raw_buf_len & 0x000000ff) >> 0;
        
        rand_stream[rand_byte[8]]  = (raw_key_pos & 0xff000000) >> 24;
        rand_stream[rand_byte[9]]  = (raw_key_pos & 0x00ff0000) >> 16;
        rand_stream[rand_byte[10]] = (raw_key_pos & 0x0000ff00) >> 8;
        rand_stream[rand_byte[11]] = (raw_key_pos & 0x000000ff) >> 0;
        
        rand_stream[rand_byte[12]] = (raw_key_len & 0xff000000) >> 24;
        rand_stream[rand_byte[13]] = (raw_key_len & 0x00ff0000) >> 16;
        rand_stream[rand_byte[14]] = (raw_key_len & 0x0000ff00) >> 8;
        rand_stream[rand_byte[15]] = (raw_key_len & 0x000000ff) >> 0;
        memcpy(ciphertext + 32, rand_stream, 256);
        
        delete [] rand_stream1;
        delete [] rand_stream2;
        delete [] rand_stream3;
        delete [] rsa_out_buf;
        delete [] raw_buf;
        delete [] raw_key_buf;
        
        int output_len = 16 + 16 + 256 + rand_len1 + rand_len2 + rand_len3 + raw_key_len + raw_buf_len;
        for (int i = 0; i < 16; i++) {
            ciphertext[i] ^= ciphertext[output_len - i - 1];
        }
        
        return output_len;
    }

    int decrypt(const unsigned char *ciphertext, const int len, unsigned char *plaintext, const int buffsize) {
        unsigned char type_header[16];
        for (int i = 0; i < 16; i++) {
            type_header[i] = ciphertext[i] ^ ciphertext[len - i - 1];
        }
        
        int type_index = 0;
        for (int i = 0; i < 3; i++) {
            type_index = type_header[type_index] & 0x07;
        }
        int mix_type = 0;
        if (8 + type_index + 1 == 16) {
            mix_type = ((type_header[8 + type_index] & 0x01) << 2) | ((type_header[0] & 0xc0) >> 6);
        } else {
            mix_type = ((type_header[8 + type_index] & 0x01) << 2) | ((type_header[8 + type_index + 1] & 0xc0) >> 6);
        }
        
        // 解析获得加密类型mix_type
        if (mix_type != 0) {
            return -1;
        }
        unsigned char range_header[16];
        unsigned char rand_byte[16];
        memcpy(range_header, ciphertext + 16, 16 * sizeof(unsigned char));
        for (int i = 0; i < 16; i++) {
            if (i == 15) {
                rand_byte[15] = ((range_header[15] & 0x0f) << 4) | ((range_header[0] & 0xf0) >> 4);
            } else {
                rand_byte[i] = ((range_header[i] & 0x0f) << 4) | ((range_header[i + 1] & 0xf0) >> 4);
            }
        }
        
        const unsigned char *rand_stream = ciphertext + 32;
        
        int raw_buf_pos = (rand_stream[rand_byte[0]] << 24) | (rand_stream[rand_byte[1]] << 16) |
        (rand_stream[rand_byte[2]] <<  8) | (rand_stream[rand_byte[3]] << 0);
        int raw_buf_len = (rand_stream[rand_byte[4]] << 24) | (rand_stream[rand_byte[5]] << 16) |
        (rand_stream[rand_byte[6]] <<  8) | (rand_stream[rand_byte[7]] << 0);
        
        int raw_key_pos = (rand_stream[rand_byte[8]]  << 24) | (rand_stream[rand_byte[9]]  << 16) |
        (rand_stream[rand_byte[10]] <<  8) | (rand_stream[rand_byte[11]] << 0);
        int raw_key_len = (rand_stream[rand_byte[12]] << 24) | (rand_stream[rand_byte[13]] << 16) |
        (rand_stream[rand_byte[14]] <<  8) | (rand_stream[rand_byte[15]] << 0);
        
        unsigned char *raw_buf = const_cast<unsigned char *>(ciphertext) + 32 + 256 + raw_buf_pos;
        unsigned char *raw_key_buf = const_cast<unsigned char *>(ciphertext) + 32 + 256 + raw_key_pos;
        unsigned char *rand_stream1 = const_cast<unsigned char *>(ciphertext) + 32 + 256;
        
        // 生成des key
        unsigned char des_key_input[32];
        for (int i = 0; i < 16; i++) {
            des_key_input[i] = type_header[i] ^ rand_stream1[i];
            des_key_input[i + 16] = range_header[i] ^ rand_stream1[i + 16];
        }
        
        // 获得公钥
        unsigned char *rsa_public_key_buff = new unsigned char[raw_key_len];
        DES desCrypt;
        desCrypt.SetKey(des_key_input, 32);
        int rsa_public_key_len = desCrypt.Decrypt(raw_key_buf, raw_key_len, rsa_public_key_buff, raw_key_len);
        
        // 人工-4， des加密前解密后长度不一致，问老历
        rsa_public_key_len -= 4;
        
        // 对公钥进行摘要, 做为对数据进行二次加密的des key
        unsigned char hmac_key_buf[16];
        HMAC hmac;
        hmac.Digest(des_key_input, 32, rsa_public_key_buff, rsa_public_key_len, hmac_key_buf, 16);
        
        unsigned char *rsa_out_buf = new unsigned char[raw_buf_len + 100];
        desCrypt.SetKey(hmac_key_buf, 16);
        int rsa_out_len = desCrypt.Decrypt(raw_buf, raw_buf_len, rsa_out_buf, raw_buf_len + 100);
        
        // 位到转
        for (int i = 0; i < rsa_out_len; i++) {
            rsa_out_buf[i] = ((rsa_out_buf[i] & 0xf0) >> 4) | ((rsa_out_buf[i] & 0x0f) << 4);
        }
        
        RSAProvider provider;
        provider.FromBytes(rsa_public_key_buff, rsa_public_key_len);
        int plainlen = provider.DecryptByPublic(rsa_out_buf, rsa_out_len, plaintext, buffsize);
        
        return plainlen;
    }

}












