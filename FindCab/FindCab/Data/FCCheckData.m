//
//  FCCheckData.m
//  FindCab
//
//  Created by leon on 13-1-16.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCCheckData.h"

@implementation FCCheckData

+ (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isValidatePhoneNumber:(NSString *)number{
    NSString *numberRegex = @"1[3|4|5|8]\\d{9}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberTest evaluateWithObject:number];
}

@end
