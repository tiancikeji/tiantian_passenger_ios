//
//  FCConversationRequest.m
//  FindCab
//
//  Created by leon on 13-1-23.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCConversationRequest.h"
#import "Conversation.h"

@implementation FCConversationRequest
@synthesize passenger;

- (void)setDelegate:(id)sender{
    m_delegate = sender;
}

- (void)createConversation:(NSMutableDictionary *)dict{
    tagRequest = 1;
    FCServiceResponse *response = [[FCServiceResponse alloc] init];
    [response setDelegate:self];
    response.strUrl = @"api/trips";
    response.type = POST;
    [response startQueryAndParse:dict];
}

- (void)getConversation:(NSNumber *)tripID{
    tagRequest = 2;
    FCServiceResponse *response = [[FCServiceResponse alloc] init];
    [response setDelegate:self];
    response.strUrl = @"api/conversations";
    response.type = GET;
    [response startQueryAndParse:[NSMutableDictionary dictionaryWithObject:passenger.uid forKey:@"from_id"]];
}

- (void)updateConversation:(NSNumber *)conversationID status:(int)type andCancelReason:(NSString *)reason{
    tagRequest = 3;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    switch (type) {
        case ConversationTypeNew:
            [dict setObject:@"0" forKey:@"status"];
            break;
        case ConversationTypeAccept:
            [dict setObject:@"3" forKey:@"status"];
            break;
        case ConversationTypeRefuse:
            [dict setObject:@"-1" forKey:@"status"];
            break;
            
        default:
            break;
    }
    [dict setObject:reason forKey:@"content"];
    FCServiceResponse *response = [[FCServiceResponse alloc] init];
    [response setDelegate:self];
    response.strUrl = [NSString stringWithFormat:@"api/conversations/%@",conversationID];
    response.type = POST;
    [response startQueryAndParse:[NSMutableDictionary dictionaryWithObject:dict forKey:@"conversation"]];
}

- (void)queryFinished:(NSString *)strData{
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSError *parseError = nil;
    NSMutableDictionary *dict = (NSMutableDictionary *)[jsonParser objectWithString:strData error:&parseError];
    
    if (tagRequest == 2) {
        
        NSArray *array = [dict valueForKey:@"conversations"];
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (int i = 0; i < array.count; i++) {
            Conversation *conversation = [[Conversation alloc] init];
            NSDictionary *dict = [array objectAtIndex:i];
            conversation._id = [dict valueForKey:@"id"];
            conversation.from = [dict valueForKey:@"from_id"];
            conversation.to = [dict valueForKey:@"to_id"];
            conversation.status = [dict valueForKey:@"status"];
            [temp addObject:conversation];
        }
        if ([m_delegate respondsToSelector:@selector(queryCFinished:)]) {
            [m_delegate performSelector:@selector(getConversationFinished:) withObject:temp];
        }
        
        return;
    }
    
    if ([m_delegate respondsToSelector:@selector(queryCFinished:)]) {
        [m_delegate performSelector:@selector(queryCFinished:) withObject:dict];
    }
}

- (void)queryError:(NSError *)errorConnect
{
    
}

@end
