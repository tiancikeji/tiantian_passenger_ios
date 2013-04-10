//
//  CancelView.h
//  FindCab
//
//  Created by paopao on 13-3-29.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CancelReasonView.h"

@protocol CancelViewDelegate <NSObject>

- (void)cancelCall;
- (void)continueCall;

@end
@interface CancelView : UIView
{
    __unsafe_unretained id<CancelViewDelegate> _delegate;
}

@property(nonatomic,unsafe_unretained) id<CancelViewDelegate> delegate;
@property(nonatomic,strong) UIView *translucentView;
@property(nonatomic,strong) UILabel *titleLabel;

- (void)sure:(UIButton *)sender;
- (void)stillCall:(UIButton *)sender;

@end
