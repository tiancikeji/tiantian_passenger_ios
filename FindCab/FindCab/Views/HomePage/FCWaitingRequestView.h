//
//  FCWaitingRequestView.h
//  FindCab
//
//  Created by leon on 13-1-20.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FCWaitingRequestViewDelegate  <NSObject>

- (void)countDownEnding;

@end

@interface FCWaitingRequestView : UIView{
    UIImageView *imgLoading;
    UILabel *labelCount;
    int timeDown;
    int lightTimeDown;
}

@property(nonatomic,unsafe_unretained) id<FCWaitingRequestViewDelegate> delegate;
@property (nonatomic, strong) UILabel *labelCount;
@property (nonatomic, strong) UILabel *time;
@property(nonatomic, strong) NSTimer *rotateTimer;
@property(nonatomic, strong) UIImageView *lightImageView;
@property(nonatomic, strong) NSTimer *countTimer;

- (void)count:(NSTimer *)timer;
- (void)stopTimer;

@end
