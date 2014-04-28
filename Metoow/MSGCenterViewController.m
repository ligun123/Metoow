//
//  MSGCenterViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-4-17.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "MSGCenterViewController.h"
#import "SVSegmentedControl.h"
#import "HWSegment.h"
#import "PersonalViewController.h"

@interface MSGCenterViewController ()

@end

@implementation MSGCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect frame;
    if ([HWDevice systemVersion] < 7.0) {
        frame = CGRectMake(50, 44, 220, 30);
    } else {
        frame = CGRectMake(50, 64, 220, 30);
    }
    HWSegment *seg = [[HWSegment alloc] initWithFrame:frame];
    seg.layer.cornerRadius = 5.0;
    seg.layer.borderWidth = 2.0;
    seg.layer.borderColor = COLOR_RGB(0, 159, 0).CGColor;
    [seg setTitles:@[@"私信", @"系统消息"]];
    [seg setSelectIndex:0];
    [self.view addSubview:seg];
    [seg setCallbackBlock:^(HWSegment *vseg, int selectIndex) {
        NSLog(@"%s -> %d", __FUNCTION__, selectIndex);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AppDelegateInterface setTabBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableView Delegate


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    UIButton *btn = (UIButton *)[cell.contentView viewWithTag:5];
    [btn addTarget:self action:@selector(cellHeaderTap:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:3];
    UILabel *contentLabel = (UILabel *)[cell.contentView viewWithTag:4];
    
    return cell;
}

- (void)cellHeaderTap:(UIButton *)sender
{
    UITableViewCell *cell = nil;
    if ([HWDevice systemVersion] < 7.0) {
        cell = (UITableViewCell *)[[sender superview] superview];
    } else {
        cell = (UITableViewCell *)[[[sender superview] superview] superview];
    }
    NSIndexPath *path = [self.msgTableView indexPathForCell:cell];
    //push to personal view controller
    [AppDelegateInterface setTabBarHidden:YES];
    PersonalViewController *personal = [AppDelegateInterface awakeViewController:@"PersonalViewController"];
    [self.navigationController pushViewController:personal animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%s -> ", __FUNCTION__);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}


@end
