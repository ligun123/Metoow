//
//  HPsfcViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-5-22.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HPsfcViewController.h"

@interface HPsfcViewController ()

@end

@implementation HPsfcViewController

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
    self.type = @"2";
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

- (void)done
{
    [SVProgressHUD show];
    //super will pop
    NSString *title = self.placeFrom.text;
    NSString *parent_id = @"1";
    NSString *address = self.placeTo.text;
    NSString *method = [self tripMethods];
//    NSString *Aggregation_date = [self.btnTimeSet titleForState:UIControlStateNormal];
    NSString *Aggregation_date = @"2014-06-02 19:32:44";
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *explain = self.detailText.text;
    NSString *lng = [NSString stringWithFormat:@"%f", self.addrInfo.geoPt.longitude];
    NSString *lat = [NSString stringWithFormat:@"%f", self.addrInfo.geoPt.latitude];
    NSString *pos = self.addrInfo.strAddr;
    if (pos == nil) {
        pos = @"我在这个位置";
    }
    NSDictionary *para = @{@"typeid" : self.type, @"title": title, @"parent_id" : parent_id, @"mudi_address" : address, @"fangshi" : method, @"Aggregation_date" : Aggregation_date, @"uid" : uid, @"explain" : explain, @"lng" : lng, @"lat" : lat, @"pos" : pos};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Huzhu act:Mod_Huzhu_add_hz Paras:para] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showAlert];
    }];
}

- (NSString *)tripMethods
{
    NSMutableArray *methods = [NSMutableArray array];
    for (QCheckBox *box in self.tripMethodView.subviews) {
        if ([box checked]) {
            [methods addObject:[box titleForState:UIControlStateNormal]];
        }
    }
    return [methods componentsJoinedByString:@","];
}

@end
