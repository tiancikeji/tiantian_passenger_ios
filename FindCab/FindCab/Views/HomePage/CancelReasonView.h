//
//  CancelReasonView.h
//  FindCab
//
//  Created by paopao on 13-4-1.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CancelReasonViewDelegate <NSObject>

- (void)chooseReason;

@end

@interface CancelReasonView : UIView

@property(nonatomic,unsafe_unretained) id<CancelReasonViewDelegate> delegate;

- (void)chooseReason:(UIButton *)sender;

@end
