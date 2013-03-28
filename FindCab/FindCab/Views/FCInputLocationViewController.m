//
//  FCInputLocationViewController.m
//  FindCab
//
//  Created by paopao on 13-3-27.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCInputLocationViewController.h"

static NSString *const STCellIdentifier = @"STCell";

@interface FCInputLocationViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    FCSTView *_customView;
    NSArray *_datasource;
    NSMutableArray *_searchDatasource;
    BMKMapView *_map;
    BMKSearch *_search;
}
@end

@implementation FCInputLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationController.navigationBarHidden  =YES;
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"allBg.png"]]];
        //        [[self navigationItem] setTitle:@"Search Display Controller!"];
        _datasource = @[@"Apple", @"Banana", @"Orange", @"Grape"];
//        _searchDatasource = n
    }
    return self;
}

- (void)loadView
{
    FCSTView *view = [[FCSTView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _customView = view;
    [_customView setDelegate:self];
    [self setView:view];
    
    myPosition = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_location"]];
    CGRect frame = myPosition.frame;
    frame.origin = CGPointMake(4,8);
    myPosition.frame = frame;
    [_customView.searchField addSubview:myPosition];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_customView.searchField becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_map setDelegate:self];
    _search = [[BMKSearch alloc] init];
    [_search setDelegate:self];
//    [_search poiSearchNearBy:nil center:_map.userLocation radius:360 pageIndex:1];
    [[_customView tableView] setDelegate:self];
    [[_customView tableView] setDataSource:self];
//    if ([[_customView tableView] respondsToSelector:@selector(registerClass:forCellReuseIdentifier:)]) {
//        [[_customView tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:STCellIdentifier];
//    }
	// Do any additional setup after loading the view.
}


#pragma mark - STViewDelegate Methods

- (void)cancelClicked
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)loadAddress
{
    [myPosition removeFromSuperview];
    _searchDatasource = [NSArray arrayWithObjects:@"haha",@"heihei", @"xixi",@"huhu",nil];
    [_customView.tableView reloadData];
}

#pragma mark - UITableViewDatasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSArray *datasouce = [tableView isEqual:[_customView tableView]] ? _datasource : _searchDatasource;
  NSArray *  datasouce = (![_searchDatasource count])?_datasource:_searchDatasource;
    return [datasouce count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:STCellIdentifier];
    }
    
//    NSArray *datasouce = [tableView isEqual:[_customView tableView]] ? _datasource : _searchDatasource;
   NSArray * datasouce = (![_searchDatasource count])?_datasource:_searchDatasource;
    [[cell textLabel] setText:datasouce[[indexPath row]]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(inputLocationViewController:selectedLocation:)]) {
        [self.delegate inputLocationViewController:self selectedLocation:cell.textLabel.text];
    }
    if (self.starting) {
        
    }else{
        
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
