//
//  InputLocationViewController.m
//  FindCab
//
//  Created by paopao on 13-3-26.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "InputLocationViewController.h"

@interface InputLocationViewController ()

@end

@implementation InputLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.searchTableView setFrame:CGRectMake(0, 44, 320,436)];
//    [self.view addSubview:self.searchTableView];
    // Do any additional setup after loading the view from its nib.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * showUserInfoCellIdentifier = @"ShowUserInfoCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    if (cell == nil)
    {
        // Create a cell to display an ingredient.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:showUserInfoCellIdentifier];
    }
    
    // Configure the cell.
    cell.textLabel.text=@"签名";
    cell.detailTextLabel.text = @"注释的呀";
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
//    [self setSearchTableView:nil];
//    [self setSearchTableView:nil];
    [super viewDidUnload];
}
@end
