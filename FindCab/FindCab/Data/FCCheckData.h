//
//  FCCheckData.h
//  FindCab
//
//  Created by leon on 13-1-16.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCCheckData : NSObject

+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)isValidatePhoneNumber:(NSString *)number;

@end
