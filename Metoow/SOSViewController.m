//
//  SOSViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-4-13.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "SOSViewController.h"
#import "APIHelper.h"
#import "LocationManager.h"

@interface SOSViewController ()

@end

@implementation SOSViewController

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
    [self.dangerLevel1 setChecked:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AppDelegateInterface setTabBarHidden:YES];
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


- (QCheckBox *)selectCheckbox
{
    if (self.dangerLevel1.checked) {
        return self.dangerLevel1;
    }
    if (self.dangerLevel2.checked) {
        return self.dangerLevel2;
    }
    if (self.dangerLevel3.checked) {
        return self.dangerLevel3;
    }
    NSLog(@"%s -> 为选择危险等级", __FUNCTION__);
    return nil;
}

- (IBAction)btnDoneTap:(id)sender
{
    QCheckBox *danger = [self selectCheckbox];
    NSString *sos_info = [[danger titleForState:UIControlStateNormal] stringByAppendingFormat:@"。%@", self.sosOther.text];
    NSString *sos = [sos_info stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *phone = @"18200509050";
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    BMKAddrInfo *addrInfo = [LocationManager shareInterface].addrInfo;
    NSDictionary *dic = @{@"uid": uid, @"lng" : [NSString stringWithFormat:@"%f", addrInfo.geoPt.longitude], @"lat" : [NSString stringWithFormat:@"%f", addrInfo.geoPt.latitude], @"pos" : addrInfo.strAddr, @"phone" : phone, @"sos_info" : sos};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_SOS act:Mod_SOS_add_sos Paras:dic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s -> %@", __FUNCTION__, operation.responseString);
        if ([responseObject isOK]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s -> %@", __FUNCTION__, error);
    }];
}

- (IBAction)btnBackTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnDangerTap:(id)sender
{
    if (sender == self.dangerLevel1) {
        [self.dangerLevel2 setChecked:NO];
        [self.dangerLevel3 setChecked:NO];
    } else if (sender == self.dangerLevel2) {
        [self.dangerLevel1 setChecked:NO];
        [self.dangerLevel3 setChecked:NO];
    } else if (sender == self.dangerLevel3) {
        [self.dangerLevel2 setChecked:NO];
        [self.dangerLevel1 setChecked:NO];
    }
}

@end
