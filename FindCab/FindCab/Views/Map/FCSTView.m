//
//  FCSTView.m
//  FindCab
//
//  Created by paopao on 13-3-27.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCSTView.h"

@implementation FCSTView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 70, 310, 590) style:UITableViewStylePlain];
        _tableView.backgroundView = nil;
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        [[self tableView] setAutoresizingMask:[self autoresizingMask]];
        [self addSubview:[self tableView]];
        
        FCCustomToolbar *bar = [[FCCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 59)];
        
        UIButton *searchbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *bg = [UIImage imageNamed:@"cancel"];
        [searchbutton setBackgroundImage:bg forState:UIControlStateNormal];
        [searchbutton setFrame:CGRectMake(0, 0, bg.size.width, bg.size.height)];
        [searchbutton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [searchbutton setTitle:@"取消" forState:UIControlStateNormal];
        [searchbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithCustomView:searchbutton];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [bar setItems:[NSArray arrayWithObjects:space,cancel, nil]];
        [self addSubview:bar];
        
        UIImage *searchBg = [UIImage imageNamed:@"searchInput"];
        _searchField = [[UITextField alloc] init];
        [_searchField setBackground:searchBg];
        [_searchField setKeyboardType:UIKeyboardTypeDefault];
        _searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_searchField setDelegate:self];
        [_searchField becomeFirstResponder];
        [_searchField setReturnKeyType:UIReturnKeyGo];
        [_searchField setFrame:CGRectMake(10, 0, searchBg.size.width, searchBg.size.height)];
        [_searchField setCenter:CGPointMake(10+searchBg.size.width/2, bar.frame.size.height/2)];
        [_searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [bar addSubview:_searchField];
    }
    return self;
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidChange:(UITextField *)textField
{
    /* 根据用户信息及输入地址 请求获取该地址相关地点信息 */
    [_delegate  loadAddress];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"HISTORYARRAY"]) {
        _historyArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"HISTORYARRAY"];
        [_historyArray removeLastObject];
        AddressInfo *addre = [[AddressInfo alloc] init];
        addre.placeName = textField.text;
        [_historyArray addObject:addre];
    }
    
    
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
