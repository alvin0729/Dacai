//
//  PassModeDefine.cpp
//  DacaiProject
//
//  Created by WUFAN on 14-6-25.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#include "PassModeDefine.h"

////////////////////////////////////////////////////////////////////////////////
//
// 过关方式表格( http://www.dacai.com/help/QuestionContent?articleid=80774 )
//
// 定义说明:
//      #define PASSMODE_m_n    0xABCDEFGH    m串n
//
// 数值说明:
//      0xAB    - m
//      0xCD    - n
//      0xEF    - 最大的串, 0xEF串1
//      0xGH    - 最小的串, 0xGH串1
//
////////////////////////////////////////////////////////////////////////////////
const unsigned int PASSMODE_1_1         = 0x01010101;
const unsigned int PASSMODE_2_1         = 0x02010202;
const unsigned int PASSMODE_2_3         = 0x02030201;
const unsigned int PASSMODE_3_1         = 0x03010303;
const unsigned int PASSMODE_3_3         = 0x03030202;
const unsigned int PASSMODE_3_4         = 0x03040302;
const unsigned int PASSMODE_3_6         = 0x03060201;
const unsigned int PASSMODE_3_7         = 0x03070301;
const unsigned int PASSMODE_4_1         = 0x04010404;
const unsigned int PASSMODE_4_4         = 0x04040303;
const unsigned int PASSMODE_4_5         = 0x04050403;
const unsigned int PASSMODE_4_6         = 0x04060202;
const unsigned int PASSMODE_4_10        = 0x040A0201;
const unsigned int PASSMODE_4_11        = 0x040B0402;
const unsigned int PASSMODE_4_14        = 0x040E0301;
const unsigned int PASSMODE_4_15        = 0x040F0401;
const unsigned int PASSMODE_5_1         = 0x05010505;
const unsigned int PASSMODE_5_5         = 0x05050404;
const unsigned int PASSMODE_5_6         = 0x05060504;
const unsigned int PASSMODE_5_10        = 0x050A0202;
const unsigned int PASSMODE_5_15        = 0x050F0201;
const unsigned int PASSMODE_5_16        = 0x05100503;
const unsigned int PASSMODE_5_20        = 0x05140302;
const unsigned int PASSMODE_5_25        = 0x05190301;
const unsigned int PASSMODE_5_26        = 0x051A0502;
const unsigned int PASSMODE_5_30        = 0x051E0401;
const unsigned int PASSMODE_5_31        = 0x051F0501;
const unsigned int PASSMODE_6_1         = 0x06010606;
const unsigned int PASSMODE_6_6         = 0x06060505;
const unsigned int PASSMODE_6_7         = 0x06070605;
const unsigned int PASSMODE_6_15        = 0x060F0202;
const unsigned int PASSMODE_6_20        = 0x06140303;
const unsigned int PASSMODE_6_21        = 0x06150201;
const unsigned int PASSMODE_6_22        = 0x06160604;
const unsigned int PASSMODE_6_35        = 0x06230302;
const unsigned int PASSMODE_6_41        = 0x06290301;
const unsigned int PASSMODE_6_42        = 0x062A0603;
const unsigned int PASSMODE_6_50        = 0x06320402;
const unsigned int PASSMODE_6_56        = 0x06380401;
const unsigned int PASSMODE_6_57        = 0x06390602;
const unsigned int PASSMODE_6_62        = 0x063E0501;
const unsigned int PASSMODE_6_63        = 0x063F0601;
const unsigned int PASSMODE_7_1         = 0x07010707;
const unsigned int PASSMODE_7_7         = 0x07070606;
const unsigned int PASSMODE_7_8         = 0x07080706;
const unsigned int PASSMODE_7_21        = 0x07150505;
const unsigned int PASSMODE_7_35        = 0x07230404;
const unsigned int PASSMODE_7_120       = 0x07780702;
const unsigned int PASSMODE_7_127       = 0x077F0701;
const unsigned int PASSMODE_8_1         = 0x08010808;
const unsigned int PASSMODE_8_8         = 0x08080707;
const unsigned int PASSMODE_8_9         = 0x08090807;
const unsigned int PASSMODE_8_28        = 0x081C0606;
const unsigned int PASSMODE_8_56        = 0x08380505;
const unsigned int PASSMODE_8_70        = 0x08460404;
const unsigned int PASSMODE_8_247       = 0x08F70802;
const unsigned int PASSMODE_8_255       = 0x08FF0801;
const unsigned int PASSMODE_9_1         = 0x09010909;
const unsigned int PASSMODE_10_1        = 0x0A010A0A;
const unsigned int PASSMODE_11_1        = 0x0B010B0B;
const unsigned int PASSMODE_12_1        = 0x0C010C0C;
const unsigned int PASSMODE_13_1        = 0x0D010D0D;
const unsigned int PASSMODE_14_1        = 0x0E010E0E;
const unsigned int PASSMODE_15_1        = 0x0F010F0F;

// 过关table大小
const unsigned int FreedomTableSize1    = 7;
const unsigned int FreedomTableSize2    = 4;
const unsigned int FreedomTableSize3    = 5;
const unsigned int FreedomTableSize4    = 3;
const unsigned int FreedomTableSize5    = 15;
const unsigned int FreedomTableSize6    = 3;
const unsigned int FreedomTableSize7    = 6;

const unsigned int CombineTableSize1    = 32;
const unsigned int CombineTableSize2    = 6;
const unsigned int CombineTableSize3    = 21;
const unsigned int CombineTableSize4    = 15;
const unsigned int CombineTableSize5    = 3;

const unsigned int PassModeTableSize    = 64;
const unsigned int FreedomTableSize     = 15;
const unsigned int CombineTableSize     = 49;

//////////////////////////////////////////////////////////////////////
// 自由过关

// 竞彩足球(胜平负、让球胜平负)、竞彩篮球(胜负、让分胜负、大小分)    7
const unsigned int FreedomPassModeTable1[] =
{
    PASSMODE_2_1,
    PASSMODE_3_1,
    PASSMODE_4_1,
    PASSMODE_5_1,
    PASSMODE_6_1,
    PASSMODE_7_1,
    PASSMODE_8_1
};

// 竞彩足球(比分)、竞彩篮球(胜分差)   4
const unsigned int FreedomPassModeTable2[] =
{
    PASSMODE_1_1,
    PASSMODE_2_1,
    PASSMODE_3_1,
    PASSMODE_4_1
};

// 竞彩足球(总进球)    5
const unsigned int FreedomPassModeTable3[] =
{
    PASSMODE_2_1,
    PASSMODE_3_1,
    PASSMODE_4_1,
    PASSMODE_5_1,
    PASSMODE_6_1
};

// 竞彩足球(半全场)    3
const unsigned int FreedomPassModeTable4[] =
{
    PASSMODE_2_1,
    PASSMODE_3_1,
    PASSMODE_4_1
};

// 北京单场(胜平负)    15
const unsigned int FreedomPassModeTable5[] =
{
    PASSMODE_1_1,
    PASSMODE_2_1,
    PASSMODE_3_1,
    PASSMODE_4_1,
    PASSMODE_5_1,
    PASSMODE_6_1,
    PASSMODE_7_1,
    PASSMODE_8_1,
    PASSMODE_9_1,
    PASSMODE_10_1,
    PASSMODE_11_1,
    PASSMODE_12_1,
    PASSMODE_13_1,
    PASSMODE_14_1,
    PASSMODE_15_1
};

// 北京单场(比分) 3
const unsigned int FreedomPassModeTable6[] =
{
    PASSMODE_1_1,
    PASSMODE_2_1,
    PASSMODE_3_1
};

// 北京单场(总进球、半全场、上下单双)   6
const unsigned int FreedomPassModeTable7[] =
{
    PASSMODE_1_1,
    PASSMODE_2_1,
    PASSMODE_3_1,
    PASSMODE_4_1,
    PASSMODE_5_1,
    PASSMODE_6_1
};

//////////////////////////////////////////////////////////////////////
// 组合过关

// 竞彩足球(胜平负、让球胜平负)、竞彩篮球(胜负、让分胜负、大小分)    32
const unsigned int CombinePassModeTable1[] =
{
    PASSMODE_3_3,
    PASSMODE_3_4,
    PASSMODE_4_4,
    PASSMODE_4_5,
    PASSMODE_4_6,
    PASSMODE_4_11,
    PASSMODE_5_5,
    PASSMODE_5_6,
    PASSMODE_5_10,
    PASSMODE_5_16,
    PASSMODE_5_20,
    PASSMODE_5_26,
    PASSMODE_6_6,
    PASSMODE_6_7,
    PASSMODE_6_15,
    PASSMODE_6_20,
    PASSMODE_6_22,
    PASSMODE_6_35,
    PASSMODE_6_42,
    PASSMODE_6_50,
    PASSMODE_6_57,
    PASSMODE_7_7,
    PASSMODE_7_8,
    PASSMODE_7_21,
    PASSMODE_7_35,
    PASSMODE_7_120,
    PASSMODE_8_8,
    PASSMODE_8_9,
    PASSMODE_8_28,
    PASSMODE_8_56,
    PASSMODE_8_70,
    PASSMODE_8_247
};

// 竞彩足球(比分、半全场)、竞彩篮球(胜分差)   6
const unsigned int CombinePassModeTable2[] =
{
    PASSMODE_3_3,
    PASSMODE_3_4,
    PASSMODE_4_4,
    PASSMODE_4_5,
    PASSMODE_4_6,
    PASSMODE_4_11
};

// 竞彩足球(总进球)    21
const unsigned int CombinePassModeTable3[] =
{
    PASSMODE_3_3,
    PASSMODE_3_4,
    PASSMODE_4_4,
    PASSMODE_4_5,
    PASSMODE_4_6,
    PASSMODE_4_11,
    PASSMODE_5_5,
    PASSMODE_5_6,
    PASSMODE_5_10,
    PASSMODE_5_16,
    PASSMODE_5_20,
    PASSMODE_5_26,
    PASSMODE_6_6,
    PASSMODE_6_7,
    PASSMODE_6_15,
    PASSMODE_6_20,
    PASSMODE_6_22,
    PASSMODE_6_35,
    PASSMODE_6_42,
    PASSMODE_6_50,
    PASSMODE_6_57
};

// 北京单场(胜平负、总进球、半全场、上下单双)   15
const unsigned int CombinePassModeTable4[] =
{
    PASSMODE_2_3,
    PASSMODE_3_4,
    PASSMODE_3_7,
    PASSMODE_4_5,
    PASSMODE_4_11,
    PASSMODE_4_15,
    PASSMODE_5_6,
    PASSMODE_5_16,
    PASSMODE_5_26,
    PASSMODE_5_31,
    PASSMODE_6_7,
    PASSMODE_6_22,
    PASSMODE_6_42,
    PASSMODE_6_57,
    PASSMODE_6_63
};

// 北京单场(比分) 3
const unsigned int CombinePassModeTable5[] =
{
    PASSMODE_2_3,
    PASSMODE_3_4,
    PASSMODE_3_7
};

// 所有的过关方式
const unsigned int PassModeTable[] =
{
    PASSMODE_1_1,
    PASSMODE_2_1,
    PASSMODE_2_3,
    PASSMODE_3_1,
    PASSMODE_3_3,
    PASSMODE_3_4,
    PASSMODE_3_6,
    PASSMODE_3_7,
    PASSMODE_4_1,
    PASSMODE_4_4,
    PASSMODE_4_5,
    PASSMODE_4_6,
    PASSMODE_4_10,
    PASSMODE_4_11,
    PASSMODE_4_14,
    PASSMODE_4_15,
    PASSMODE_5_1,
    PASSMODE_5_5,
    PASSMODE_5_6,
    PASSMODE_5_10,
    PASSMODE_5_15,
    PASSMODE_5_16,
    PASSMODE_5_20,
    PASSMODE_5_25,
    PASSMODE_5_26,
    PASSMODE_5_30,
    PASSMODE_5_31,
    PASSMODE_6_1,
    PASSMODE_6_6,
    PASSMODE_6_7,
    PASSMODE_6_15,
    PASSMODE_6_20,
    PASSMODE_6_21,
    PASSMODE_6_22,
    PASSMODE_6_35,
    PASSMODE_6_41,
    PASSMODE_6_42,
    PASSMODE_6_50,
    PASSMODE_6_56,
    PASSMODE_6_57,
    PASSMODE_6_62,
    PASSMODE_6_63,
    PASSMODE_7_1,
    PASSMODE_7_7,
    PASSMODE_7_8,
    PASSMODE_7_21,
    PASSMODE_7_35,
    PASSMODE_7_120,
    PASSMODE_7_127,
    PASSMODE_8_1,
    PASSMODE_8_8,
    PASSMODE_8_9,
    PASSMODE_8_28,
    PASSMODE_8_56,
    PASSMODE_8_70,
    PASSMODE_8_247,
    PASSMODE_8_255,
    PASSMODE_9_1,
    PASSMODE_10_1,
    PASSMODE_11_1,
    PASSMODE_12_1,
    PASSMODE_13_1,
    PASSMODE_14_1,
    PASSMODE_15_1
};


// 所有的自由过关方式
const unsigned int FreedomPassModeTable[] =
{
    PASSMODE_1_1,
    PASSMODE_2_1,
    PASSMODE_3_1,
    PASSMODE_4_1,
    PASSMODE_5_1,
    PASSMODE_6_1,
    PASSMODE_7_1,
    PASSMODE_8_1,
    PASSMODE_9_1,
    PASSMODE_10_1,
    PASSMODE_11_1,
    PASSMODE_12_1,
    PASSMODE_13_1,
    PASSMODE_14_1,
    PASSMODE_15_1
};

// 所有的组合过关方式
const unsigned int CombinePassModeTable[] =
{
    PASSMODE_2_3,
    PASSMODE_3_3,
    PASSMODE_3_4,
    PASSMODE_3_6,
    PASSMODE_3_7,
    PASSMODE_4_4,
    PASSMODE_4_5,
    PASSMODE_4_6,
    PASSMODE_4_10,
    PASSMODE_4_11,
    PASSMODE_4_14,
    PASSMODE_4_15,
    PASSMODE_5_5,
    PASSMODE_5_6,
    PASSMODE_5_10,
    PASSMODE_5_15,
    PASSMODE_5_16,
    PASSMODE_5_20,
    PASSMODE_5_25,
    PASSMODE_5_26,
    PASSMODE_5_30,
    PASSMODE_5_31,
    PASSMODE_6_6,
    PASSMODE_6_7,
    PASSMODE_6_15,
    PASSMODE_6_20,
    PASSMODE_6_21,
    PASSMODE_6_22,
    PASSMODE_6_35,
    PASSMODE_6_41,
    PASSMODE_6_42,
    PASSMODE_6_50,
    PASSMODE_6_56,
    PASSMODE_6_57,
    PASSMODE_6_62,
    PASSMODE_6_63,
    PASSMODE_7_7,
    PASSMODE_7_8,
    PASSMODE_7_21,
    PASSMODE_7_35,
    PASSMODE_7_120,
    PASSMODE_7_127,
    PASSMODE_8_8,
    PASSMODE_8_9,
    PASSMODE_8_28,
    PASSMODE_8_56,
    PASSMODE_8_70,
    PASSMODE_8_247,
    PASSMODE_8_255,
};
