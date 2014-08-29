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
    [self.dangerLevel1 removeTarget:self.dangerLevel1 action:@selector(checkboxBtnChecked) forControlEvents:UIControlEventTouchUpInside];
    [self.dangerLevel2 removeTarget:self.dangerLevel2 action:@selector(checkboxBtnChecked) forControlEvents:UIControlEventTouchUpInside];
    [self.dangerLevel3 removeTarget:self.dangerLevel3 action:@selector(checkboxBtnChecked) forControlEvents:UIControlEventTouchUpInside];
    [self.dangerLevel4 removeTarget:self.dangerLevel4 action:@selector(checkboxBtnChecked) forControlEvents:UIControlEventTouchUpInside];
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
    if (self.dangerLevel4.checked) {
        return self.dangerLevel4;
    }
    NSLog(@"%s -> 未选择危险等级", __FUNCTION__);
    return nil;
}

- (IBAction)btnDoneTap:(id)sender
{
    QCheckBox *danger = [self selectCheckbox];
    NSString *otherTxt = self.sosOther.text.length == 0 ? @"其他..." : self.sosOther.text;
    NSString *sos_info = nil;
    if (danger == self.dangerLevel4) {
        sos_info = otherTxt;
    } else {
        sos_info = [danger titleForState:UIControlStateNormal];
    }
    NSString *sos = [sos_info stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *phone = @"18200509050";
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    BMKAddrInfo *addrInfo = [LocationManager shareInterface].addrInfo;
    if (addrInfo == nil) {
        [[NSError errorWithDomain:@"正在获取位置信息" code:100 userInfo:nil] showAlert];
        return ;
    }
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
        [self.dangerLevel4 setChecked:NO];
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    } else if (sender == self.dangerLevel2) {
        [self.dangerLevel1 setChecked:NO];
        [self.dangerLevel3 setChecked:NO];
        [self.dangerLevel4 setChecked:NO];
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    } else if (sender == self.dangerLevel3) {
        [self.dangerLevel2 setChecked:NO];
        [self.dangerLevel1 setChecked:NO];
        [self.dangerLevel4 setChecked:NO];
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    } else if (sender == self.dangerLevel4) {
        [self.dangerLevel2 setChecked:NO];
        [self.dangerLevel3 setChecked:NO];
        [self.dangerLevel1 setChecked:NO];
        [self.sosOther becomeFirstResponder];
    }
    [sender setChecked:YES];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self btnDangerTap:self.dangerLevel4];
}


@end
