//
//  CancelView.m
//  FindCab
//
//  Created by paopao on 13-3-29.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "CancelView.h"

@implementation CancelView

- (id)initWithFrame:(CGRect)frame
{
    UIImage *bg = [UIImage imageNamed:@"cancelCallBg.png"];
    frame.size = bg.size;
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:bg]];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 310, 40)];
        [_titleLabel setCenter:CGPointMake(frame.size.width/2, frame.size.height/5*1)];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setText:@"确定要取消本次叫车服务吗?"];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_titleLabel];
        
        UIImage *cancelBg = [UIImage imageNamed:@"sureCancel.png"];
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancel setBackgroundImage:cancelBg forState:UIControlStateNormal];
        [cancel.titleLabel setTextColor:[UIColor whiteColor]];
        [cancel.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [cancel setTitle:@"确定取消" forState:UIControlStateNormal];
        [cancel setBackgroundImage:[UIImage imageNamed:@"sureCancelA.png"] forState:UIControlStateHighlighted];
        [cancel setFrame:CGRectMake(0, 0, cancelBg.size.width, cancelBg.size.height)];
        [cancel setCenter:CGPointMake(frame.size.width/2, frame.size.height/7*3+10)];
        [cancel addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancel];
        
        UIImage *stillBg = [UIImage imageNamed:@"stillTaxi.png"];
        UIButton *still = [UIButton buttonWithType:UIButtonTypeCustom];
        [still setBackgroundImage:stillBg forState:UIControlStateNormal];
        [still.titleLabel setTextColor:[UIColor whiteColor]];
        [still setTitle:@"继续叫车" forState:UIControlStateNormal];
        [still.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [still setBackgroundImage:[UIImage imageNamed:@"stillTaxiA.png"] forState:UIControlStateHighlighted];
        [still addTarget:self action:@selector(stillCall:) forControlEvents:UIControlEventTouchUpInside];
        [still setFrame:CGRectMake(0, 0, stillBg.size.width, stillBg.size.height)];
        [still setCenter:CGPointMake(frame.size.width/2, frame.size.height/5*4-5)];
        [self addSubview:still];
    }
    return self;
}

/* 继续叫车 */
- (void)stillCall:(UIButton *)sender
{
    [_delegate continueCall];
}

/* 确认取消 */
- (void)sure:(UIButton *)sender
{
    [_delegate cancelCall];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
