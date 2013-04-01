//
//  FCSTView.m
//  FindCab
//
//  Created by paopao on 13-3-27.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCSTView.h"

@implementation FCSTView

- (id)initWithFrame:(CGRect)frame Starting:(BOOL)starting
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        
        [self addTapGuesture];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 80, 300, 400) style:UITableViewStylePlain];
        _tableView.backgroundView = nil;
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [[self tableView] setAutoresizingMask:[self autoresizingMask]];
        [self addSubview:[self tableView]];
        
        FCCustomToolbar *bar = [[FCCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 59)];
        
        UIButton *searchbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *bg = [UIImage imageNamed:@"cancel.png"];
        [searchbutton setBackgroundImage:bg forState:UIControlStateNormal];
        [searchbutton setFrame:CGRectMake(0, 0, bg.size.width, bg.size.height)];
        [searchbutton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [searchbutton setTitle:@"取消" forState:UIControlStateNormal];
        [searchbutton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [searchbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithCustomView:searchbutton];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [bar setItems:[NSArray arrayWithObjects:space,cancel, nil]];
        [self addSubview:bar];
        
        UIImage *searchBg = [UIImage imageNamed:@"searchInput.png"];
        
        UIImageView *view = [[UIImageView alloc] initWithImage:searchBg];
        [view setFrame:CGRectMake(10, 0, searchBg.size.width, searchBg.size.height)];
        [view setCenter:CGPointMake(10+searchBg.size.width/2, bar.frame.size.height/2)];
        [bar addSubview:view];
        
        _searchField = [[UITextField alloc] init];
        [_searchField setKeyboardType:UIKeyboardTypeDefault];
        _searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_searchField setDelegate:self];
        [_searchField becomeFirstResponder];
        [_searchField setReturnKeyType:UIReturnKeySearch];
        [_searchField setFrame:CGRectMake(5, 0, searchBg.size.width-5, searchBg.size.height)];
        [_searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [view addSubview:_searchField];
        self.starting = starting;
        if (starting) {
            myPosition = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_location"]];
            CGRect frame = myPosition.frame;
            myPosition.frame = frame;
            [myPosition setCenter:CGPointMake(4+frame.size.width/2, _searchField.frame.size.height/2)];
            [_searchField addSubview:myPosition];
        }
    }
    return self;
}

-(void)addTapGuesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(confirmAction:)];
    tapGesture.delegate = self;
    [tapGesture setNumberOfTapsRequired:1];
    [_searchField addGestureRecognizer:tapGesture];
}

-(void)confirmAction:(UITapGestureRecognizer *)gesture
{
    [_searchField becomeFirstResponder];
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
    NSLog(@"textFieldDidBeginEditing");
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidChange:(UITextField *)textField
{
    /* 根据用户信息及输入地址 请求获取该地址相关地点信息 */
    if (self.starting) {
        [myPosition removeFromSuperview];
    }
    if (textField.markedTextRange == nil) {
        [_delegate  loadAddress:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)cancel:(UIButton *)sender
{
    [_delegate cancelClicked];
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
