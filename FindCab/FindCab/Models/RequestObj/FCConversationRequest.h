//
//  FCConversationRequest.h
//  FindCab
//
//  Created by leon on 13-1-23.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCHomePageViewController.h"

@protocol ConversationResponseDelegate <NSObject>

- (void)queryCFinished:(NSMutableDictionary *)dict;
//- (void)queryFinished:(NSString *)strData;
//- (void)queryError:(NSError *)errorConnect;

@end

@interface FCConversationRequest : NSObject{
    id<ConversationResponseDelegate> m_delegate;
    int tagRequest;
}

@property (nonatomic, strong) Passenger *passenger;

- (void)setDelegate:(id)sender;
- (void)createConversation:(NSMutableDictionary *)dict;
- (void)getConversation:(NSNumber *)tripID;
- (void)updateConversation:(NSNumber *)conversationID status:(enum ConversationType)type;

@end
