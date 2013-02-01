//
//  GBUtility.m
//  GangBeng
//
//  Created by He leon on 12-7-25.
//  Copyright (c) 2012年 Wodache. All rights reserved.
//

#import "GBUtility.h"
#import <CommonCrypto/CommonDigest.h>


@implementation GBUtility

+ (NSString *)encode:(NSString *)value{
    const char* str = [value UTF8String];
    unsigned char result[32];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }  
    return ret;
}

//+ (NSString*)encodeBase64:(NSString*)input 
//{ 
//    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; 
//    //转换到base64 
//    data = [GTMBase64 encodeData:data]; 
//    NSString * base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    return base64String; 
//}

@end
