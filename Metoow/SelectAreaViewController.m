//
//  SelectAreaViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-5-7.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "SelectAreaViewController.h"
#import "RegisterViewController.h"

@interface SelectAreaViewController ()

@end

@implementation SelectAreaViewController

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

- (IBAction)btnBackTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableView Delegate & Datasource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    NSArray *arr = self.areaDic.allValues;
    cell.textLabel.text = arr[indexPath.row][@"title"];
    cell.detailTextLabel.text = arr[indexPath.row][@"id"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.areaDic allKeys].count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.areaDic.allValues[indexPath.row];
    [self saveArea:[dic mutableCopy]];
    if ([dic[@"level"] integerValue] == 2) {
        NSArray *subcons = [self.navigationController viewControllers];
        for (id con in subcons) {
            if ([con isKindOfClass:[RegisterViewController class]]) {
                [con setAreaTitle];
                [self.navigationController popToViewController:con animated:YES];
                break ;
            }
        }
    } else {
        SelectAreaViewController *slt = [[AppDelegateInterface mainStoryBoard] instantiateViewControllerWithIdentifier:@"SelectAreaViewController"];
        slt.areaDic = dic[@"child"];
        [self.navigationController pushViewController:slt animated:YES];
    }
}


- (void)saveArea:(NSDictionary *)dic
{
    NSMutableDictionary *dfdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dfdic removeObjectForKey:@"child"];
    NSString *key = [kAreaLevel stringByAppendingFormat:@"%d", [dic[@"level"] integerValue]];
    [[NSUserDefaults standardUserDefaults] setObject:dfdic forKey:key];
}

@end
