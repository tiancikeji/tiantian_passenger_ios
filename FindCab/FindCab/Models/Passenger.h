//
//  Passenger.h
//  FindCab
//
//  Created by leon on 13-1-5.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "NSRRemoteObject.h"

@interface Passenger : NSRRemoteObject

@property (nonatomic, strong) NSString *name,*mobile,*lat,*lng,*password;
@property (nonatomic, strong) NSNumber *uid;

@end
