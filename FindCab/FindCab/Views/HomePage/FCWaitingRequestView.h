//
//  FCWaitingRequestView.h
//  FindCab
//
//  Created by leon on 13-1-20.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCWaitingRequestView : UIView{
    UIImageView *imgLoading;
    UILabel *labelCount;
    int timeDown;
}
@property (nonatomic, strong) UILabel *labelCount;
@property (nonatomic, strong) UILabel *time;

- (void)count:(NSTimer *)timer;
@end
