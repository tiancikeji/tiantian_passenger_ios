//
//  MyOrderViewController.m
//  FindCab
//
//  Created by paopao on 13-4-11.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "MyOrderViewController.h"

#define TABLEVIEWWIDTH 300
@interface MyOrderViewController ()

@end

@implementation MyOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"allBg.png"]]];
        [self createNaviBar];
        [self setStrNaviTitle:@"我的订单"];
        [self createNaviBtnLeft:[UIImage imageNamed:@"cancel.png"] title:@"返回"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *on = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 200, 30)];
    [on setText:@"正在进行中的订单"];
    [on setBackgroundColor:[UIColor clearColor]];
    [on setTextColor:[UIColor blackColor]];
    [self.view addSubview:on];
    
    _ongoingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TABLEVIEWWIDTH, 89)];
    [_ongoingTableView setCenter:CGPointMake(self.view.frame.size.width/2, 150)];
    [_ongoingTableView setDelegate:self];
    [_ongoingTableView setDataSource:self];
//    [_ongoingTableView setBackgroundColor:[UIColor clearColor]];
    [_ongoingTableView setScrollEnabled:NO];
//    _ongoingTableView.backgroundView = nil;
//    _ongoingTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_ongoingTableView];
    
    UILabel *past = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, 200, 30)];
    [past setText:@"已完成的订单"];
    [past setBackgroundColor:[UIColor clearColor]];
    [past setTextColor:[UIColor blackColor]];
    [self.view addSubview:past];
    _pastOrderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TABLEVIEWWIDTH, 178)];
    [_pastOrderTableView setCenter:CGPointMake(self.view.frame.size.width/2, 330)];
    [_pastOrderTableView setDelegate:self];
    [_pastOrderTableView setDataSource:self];
    [_pastOrderTableView setScrollsToTop:YES];
//    [_pastOrderTableView setBackgroundColor:[UIColor clearColor]];
//    _pastOrderTableView.backgroundView = nil;
//    _pastOrderTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_pastOrderTableView];
}

#pragma mark
#pragma mark UITableviewDatasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 89;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.ongoingTableView]) {
        return 1;
    }
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"CellReuseID";
    MyOrderCell *cell = (MyOrderCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor blueColor];
    [cell.startIcon setImage:[UIImage imageNamed:@"green.png"]];
    [cell.endIcon setImage:[UIImage imageNamed:@"green.png"]];
    [cell.dateIcon setImage:[UIImage imageNamed:@"green.png"]];
    [cell.startLabel setText:@"中关村南大街"];
    [cell.endLabel setText:@"立水桥"];
    [cell.dateLabel setText:@"2013年4月10日 12:00"];
    return cell;
}

#pragma mark
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    FCOrderDetailViewController *orderDetail = [[FCOrderDetailViewController alloc] init];
    [self.navigationController pushViewController:orderDetail animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
