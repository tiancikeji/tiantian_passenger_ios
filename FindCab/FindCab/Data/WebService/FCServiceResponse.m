//
//  FCServiceResponse.m
//  FindCab
//
//  Created by leon on 13-1-14.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCServiceResponse.h"



#define KT_CONNECT_TIMEOUT 100

@implementation FCServiceResponse
@synthesize strUrl;
@synthesize type;

- (id) init{
    self = [super init];
	if(self){
	}
	return self;
}

- (void)setDelegate:(id)sender{
    m_delegate = sender;
    mainsender = sender;
}

- (void)startQueryAndParse:(NSMutableDictionary *)dictData{
    NSLog(@"param:%@",dictData);
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString *strJson = [jsonWriter stringWithObject:dictData];
    NSData *sendData = [strJson dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSMutableString *stringURL = [[NSMutableString alloc] initWithCapacity:128];
    [stringURL appendFormat:@"%@%@",FC_BASE_URL,strUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *strMethod;
    switch (type) {
        case POST:
        {
            strMethod = @"POST";
           
            /*
             [stringURL appendString:@"?"];
             NSString *key;
             for (key in dictData) {
             NSString *value= [dictData objectForKey:key];
             if ([value isKindOfClass:[NSNull class]]) {
             value = @"";
             }
             [stringURL appendFormat:@"%@=%@&",key,value];
             }
             stringURL = (NSMutableString *)[stringURL substringToIndex:stringURL.length-1];
             
             NSData *data = UIImageJPEGRepresentation(imgPhoto, 0.3);
             NSLog(@"%@ %f",NSStringFromCGSize(imgPhoto.size),imgPhoto.size.height);
             [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
             [request setHTTPBody:data];*/
            /*
            if (imgPhoto) {
                
                NSData *data = UIImageJPEGRepresentation(imgPhoto, 0.3);
                NSMutableString *body=[[NSMutableString alloc]init];
                
                NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
                NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
                NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
                
                NSString *key;
                for (key in dictData) {
                    [body appendFormat:@"%@\r\n",MPboundary];
                    //添加字段名称，换2行
                    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
                    //添加字段的值
                    [body appendFormat:@"%@\r\n",[dictData objectForKey:key]];
                }
                [body appendFormat:@"%@\r\n",MPboundary];
                //声明pic字段，文件名为boris.png
                [body appendFormat:@"Content-Disposition: form-data; name=\"photo[]\"; filename=\"boris.png\"\r\n"];
                //声明上传文件的格式
                [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
                
                //声明结束符：--AaB03x--
                NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
                //声明myRequestData，用来放入http body
                NSMutableData *myRequestData=[NSMutableData data];
                //将body字符串转化为UTF8格式的二进制
                [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
                //将image的data加入
                [myRequestData appendData:data];
                //加入结束符--AaB03x--
                [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
                
                //设置HTTPHeader中Content-Type的值
                NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
                //设置HTTPHeader
                [request setValue:content forHTTPHeaderField:@"Content-Type"];
                //设置Content-Length
                [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
                //设置http body
                [request setHTTPBody:myRequestData];
                //http method
                [request setHTTPMethod:@"POST"];
                
            }
            else{*/
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:sendData];
            //}
            
            
            
            //            [request setValue:@"application/x-www-form-urlencode" forHTTPHeaderField:@"Content-Type"];
            //            if (dictData) {
            //                [stringURL appendString:@"?"];
            //                NSString *key;
            //                for (key in dictData) {
            //                    [stringURL appendFormat:@"%@=%@&",key,[dictData objectForKey:key]];
            //                }
            //                stringURL = (NSMutableString *)[stringURL substringToIndex:stringURL.length-1];
            //            }
            //            //[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            //            if (sendData && imgPhoto) {
            //                //[request setHTTPBody:sendData];
            //
            //                NSData *data = UIImageJPEGRepresentation(imgPhoto, 0.3);
            //                NSLog(@"%@ %f",NSStringFromCGSize(imgPhoto.size),imgPhoto.size.height);
            //                [request setValue:@"application/x-www-form-urlencode" forHTTPHeaderField:@"Content-Type"];
            //                [request setHTTPBody:data];
            //            }
        }
            break;
        case GET:
        {
            strMethod = @"GET";
            
            if (dictData) {
                [stringURL appendString:@"?"];
                NSString *key;
                for (key in dictData) {
                    [stringURL appendFormat:@"%@=%@&",key,[dictData objectForKey:key]];
                }
                stringURL = (NSMutableString *)[stringURL substringToIndex:stringURL.length-1];
            }
        }
            break;
        case DELETE:
            strMethod = @"DELETE";
            break;
        case UPDATE:
            strMethod = @"UPDATE";
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:sendData];
            break;
            
        default:
            break;
    }
    stringURL = (NSMutableString *)[stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:stringURL];
    [request setURL:url];
    [request setHTTPMethod:strMethod];
    //    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    if (sendData) {
    //        [request setHTTPBody:sendData];
    //    }
    [self performSelector:@selector(connectTimeOut) withObject:nil afterDelay:KT_CONNECT_TIMEOUT];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    /*
     NSMutableString *stringURL = [[NSMutableString alloc] initWithCapacity:128];
     [stringURL appendFormat:@"%@%@?auth_code=%@",KT_BASE_URL,[_arrayUrl objectAtIndex:type],BBX_AUTH_CODE];
     NSURL *url;
     if (type == RequstPhotoUpload ||
     type == RequstAvatarUpload ||
     type == RequstCoverUpload) {
     NSString *key;
     for (key in dictPost) {
     [stringURL appendFormat:@"&%@=%@",key,[dictPost valueForKey:key]];
     }
     NSString *strUrl = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
     (CFStringRef)stringURL,
     NULL,
     NULL,
     kCFStringEncodingUTF8);
     url = [NSURL URLWithString:strUrl];
     }
     else {
     url = [NSURL URLWithString:stringURL];
     }
     
     
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
     [request setURL:url];
     [request setHTTPMethod:@"POST"];
     
     if (type == RequstPhotoUpload ||
     type == RequstAvatarUpload ||
     type == RequstCoverUpload) {
     NSData *data = UIImageJPEGRepresentation(imgPhoto, 0.3);
     NSLog(@"%@ %f",NSStringFromCGSize(imgPhoto.size),imgPhoto.size.height);
     //NSData *data = UIImagePNGRepresentation(imgPhoto);
     [request setValue:@"application/x-www-form-urlencode" forHTTPHeaderField:@"Content-Type"];
     [request setHTTPBody:data];
     
     
     //        NSString *str = [[BBXData sharedObject] getUnUploadPhotoFolderPath];
     //        NSString *filename = [str stringByAppendingPathComponent:[NSString stringWithFormat:@"12345.png"]];
     //        [data writeToFile:filename atomically:NO];
     }
     else {
     [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     if (postData) {
     [request setHTTPBody:postData];
     }
     
     }
     */
    
    
    //同步请求的的代码
    //connection = [[NSURLConnection alloc] initWithRequest:request
    //                                             delegate:self];
}

- (void)connectTimeOut{
    if (connection) {
        NSError *err = [[NSError alloc] initWithDomain:@"time out" code:-1001 userInfo:nil];
        [self connection:connection didFailWithError:err];
    }
    [connection cancel];
	connection = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if (!dt) {
        dt = [[NSMutableData alloc] initWithData:data];
    }
    else {
        [dt appendData:data];
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
				  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
	return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectTimeOut) object:nil];
    
    
    NSString *strData = [[NSString alloc] initWithData:dt encoding:NSUTF8StringEncoding];
    //strData = [strData stringByReplacingOccurrencesOfString:@"null" withString:@"\"kong\""];
    if ([m_delegate respondsToSelector:@selector(queryFinished:)]) {
        [m_delegate queryFinished:strData];
    }
    
    [connection cancel];
	connection = nil;
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)connectError
{
    if ([m_delegate respondsToSelector:@selector(queryError:)]) {
        [m_delegate queryError:connectError];
    }
}


@end
