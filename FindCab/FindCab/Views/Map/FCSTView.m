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
        oldHeight = 0.0f;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
                
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 80, 300, 400) style:UITableViewStylePlain];
        _tableView.backgroundView = nil;
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [[self tableView] setAutoresizingMask:[self autoresizingMask]];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        [view setUserInteractionEnabled:YES];
        [view setFrame:CGRectMake(10, 0, searchBg.size.width, searchBg.size.height)];
        [view setCenter:CGPointMake(10+searchBg.size.width/2, bar.frame.size.height/2)];
        [bar addSubview:view];
        
        _searchField = [[UITextField alloc] init];
        [_searchField setKeyboardType:UIKeyboardTypeDefault];
        _searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_searchField setDelegate:self];
        [_searchField becomeFirstResponder];
        [_searchField setReturnKeyType:UIReturnKeyDefault];
        [_searchField setFrame:CGRectMake(5, 0, searchBg.size.width-5, searchBg.size.height)];
        [_searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_searchField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [view addSubview:_searchField];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//         
//                                                 selector:@selector(keyboardWillShowDelay:) name:UIKeyboardWillShowNotification object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//         
//                                                 selector:@selector(keyboardDidHide:)
//         
//                                                     name:UIKeyboardDidHideNotification  object:nil];
        
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

- (void)keyboardWillShowDelay:(NSNotification *)notify
{
    [self performSelector:@selector(keyboardWillShow:) withObject:notify afterDelay:0];
}

- (void)keyboardWillShow:(NSNotification *)notify
{
//    self.doneButton.hidden = YES;
    UIWindow* tempWindow = nil;
    UIView* keyboard = nil;
    
    tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:2];
    
    if (tempWindow == nil)
    {
        return;
    }
    
    int viewCount = [tempWindow.subviews count];
    
    ////find key board view.
    for(int i=0; i<viewCount; i++)
    {
        keyboard = [tempWindow.subviews objectAtIndex:i];
        
        //keyboard view found; add the custom button to it
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2)
        {
            if(([[keyboard description] hasPrefix:@"<UIPeripheralHostView"] == YES) ||(([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)))
            {
                NSLog(@"find UIKeyboard or UIPeripheralHostView");
                NSDictionary *userInfo = [notify userInfo];
                NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
                CGRect keyboardRect = [aValue CGRectValue];
                CGFloat height = keyboardRect.size.height;
                [self creatDoneButton:height andOldHeight:oldHeight];
                oldHeight = height;
                [keyboard addSubview:_doneButton];
                break;
            }
        }
        else
        {
            if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
            {
                NSLog(@"find UIKeyboard");
                break;
            }
        }
    }
}

- (void)findKeyboard
{
    
}

- (void)creatDoneButton:(CGFloat)keyboardHeight andOldHeight:(CGFloat)pastHeight
{
    UIImage *go = [UIImage imageNamed:@"keyGo.png"];
    // 在键盘第1次弹出时，创建按钮
    if (self.doneButton == nil) {
        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.doneButton.hidden=YES;
        [self.doneButton setFrame:CGRectMake(243,keyboardHeight-go.size.height-4 , go.size.width, go.size.height)];

        // 设置按钮背景图片
        [self.doneButton setBackgroundImage:go forState:UIControlStateNormal];
//        [self.doneButton setTitle:@"前往" forState:UIControlStateNormal];   // 设置按钮的位置在恰当的地方
        [self.doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
        

        
        // 当按钮按下时，触发doneButton方法
        [self.doneButton addTarget:self action:@selector(doneButton:)  forControlEvents:UIControlEventTouchUpInside];
    }
    [self.doneButton setFrame:CGRectMake(243,keyboardHeight-go.size.height-4 , go.size.width, go.size.height)];
    self.doneButton.hidden = NO;
}

- (void)keyboardDidHide:(NSNotification *)notify
{
    if (self.doneButton) {
        self.doneButton.hidden=YES;
    }
    oldHeight = 0.0f;
}

- (void)doneButton:(UIButton *)sender
{
    [_searchField resignFirstResponder];
}


- (void)cancel:(UIButton *)sender
{
    [_delegate cancelClicked];
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

@end
