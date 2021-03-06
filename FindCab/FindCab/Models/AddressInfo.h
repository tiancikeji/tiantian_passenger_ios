//
//  AddressInfo.h
//  FindCab
//
//  Created by paopao on 13-3-27.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

@interface AddressInfo : NSObject

@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *detailAddress;
@property (nonatomic) CLLocationCoordinate2D location;
@end
