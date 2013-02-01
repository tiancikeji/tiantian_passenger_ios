//
//  Conversation.h
//  FindCab
//
//  Created by leon on 13-1-5.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "NSRRemoteObject.h"

@interface Conversation : NSRRemoteObject

@property (nonatomic, strong) NSString *from,*to;
@property (nonatomic, strong) NSNumber *_id,*status;

@end
