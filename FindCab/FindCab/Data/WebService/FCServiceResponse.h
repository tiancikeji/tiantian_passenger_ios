//
//  FCServiceResponse.h
//  FindCab
//
//  Created by leon on 13-1-14.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FCServiceResponseDelegate <NSObject>

- (void)queryFinished:(NSString *)strData;
- (void)queryError:(NSError *)errorConnect;

@end

typedef enum {
    POST,
    GET,
    DELETE,
    UPDATE,
}
HTTPRequestType;

@interface FCServiceResponse : NSObject{
    id<FCServiceResponseDelegate> m_delegate;
    NSURLConnection*  connection;
    NSArray *_arrayUrl;
    id mainsender;
    NSMutableData *dt;
    NSString *strUrl;
    HTTPRequestType type;
}

@property (nonatomic, retain) NSString *strUrl;
@property (nonatomic, assign) HTTPRequestType type;


- (void)startQueryAndParse:(NSMutableDictionary *)dictData;
- (void)setDelegate:(id)sender;
- (void)startRequest:(NSString *)stringData;
@end
