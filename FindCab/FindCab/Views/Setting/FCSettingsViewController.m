//
//  FCSettingsViewController.m
//  FindCab
//
//  Created by paopao on 13-4-8.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCSettingsViewController.h"

#define TABLEVIEWWIDTH 300
@interface FCSettingsViewController ()

@end

@implementation FCSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"allBg.png"]]];
        [self createNaviBar];
        [self setStrNaviTitle:@"设置"];
        [self createNaviBtnLeft:[UIImage imageNamed:@"cancel.png"] title:@"返回"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _updateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TABLEVIEWWIDTH, 55)];
    [_updateTableView setCenter:CGPointMake(self.view.frame.size.width/2, 100)];
    [_updateTableView setDelegate:self];
    [_updateTableView setDataSource:self];
    [_updateTableView setScrollEnabled:NO];
    [self.view addSubview:_updateTableView];
    
    _myOrderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TABLEVIEWWIDTH, 55)];
    [_myOrderTableView setCenter:CGPointMake(self.view.frame.size.width/2, 170)];
    [_myOrderTableView setDelegate:self];
    [_myOrderTableView setDataSource:self];
    [_myOrderTableView setScrollEnabled:NO];
    [self.view addSubview:_myOrderTableView];
    
    _aboutTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TABLEVIEWWIDTH, 165)];
    [_aboutTableView setCenter:CGPointMake(self.view.frame.size.width/2, 295)];
    [_aboutTableView setDelegate:self];
    [_aboutTableView setDataSource:self];
    [_aboutTableView setScrollEnabled:NO];
    [self.view addSubview:_aboutTableView];
	// Do any additional setup after loading the view.
}

#pragma mark
#pragma mark UITableViewDataSoure

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_updateTableView] || [tableView isEqual:_myOrderTableView]) {
        return 1;
    }
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if ([tableView isEqual:_updateTableView]) {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
        cell.textLabel.text = phoneNumber;
        cell.detailTextLabel.text = @"更改";
    }else{
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:17]];
        if([tableView isEqual:_myOrderTableView])
        {
            cell.textLabel.text = @"我的订单"; 
        }else{
            int rowNumber = [indexPath row];
            switch (rowNumber) {
                case 0:
                    cell.textLabel.text = @"联系客服";
                case 1:
                    cell.textLabel.text = @"检查更新";
                    break;
                case 2:
                    cell.textLabel.text = @"关于我们";
                    break;
                default:
                    break;
            }
        }
    }
    
    return cell;
}

#pragma mark 
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([tableView isEqual:self.myOrderTableView]) {
        MyOrderViewController *order = [[MyOrderViewController alloc] init];
        [self.navigationController pushViewController:order animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
