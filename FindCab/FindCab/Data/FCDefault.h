//
//  FCDefault.h
//  FindCab
//
//  Created by leon on 13-1-4.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#ifndef FindCab_FCDefault_h
#define FindCab_FCDefault_h

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define FC_BASE_URL @"http://vissul.com:8989/"
#import "FCServiceResponse.h"

//此appid为您所申请,请勿随意修改
//this APPID for your application,do not arbitrarily modify
#define APPID @"50f40371"
#define ENGINE_URL @"http://dev.voicecloud.cn:1028/index.htm"

#endif
