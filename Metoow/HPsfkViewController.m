//
//  HPsfkViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-5-22.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HPsfkViewController.h"
#import "IQKeyBoardManager/IQKeyboardManager.h"

@interface HPsfkViewController ()

@end

@implementation HPsfkViewController

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
    // Do any additional setup after loading the view from its nib.
    self.type = @"4";
    [self.myAccessaryView setOutsideInput:self.detailText];
    self.detailText.inputAccessoryView = self.myAccessaryView;
    self.detailText.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)publishTxtAndPic
{
    [SVProgressHUD show];
    [FileUploader uploadTo:UploadCategaryHuzhu images:self.picRoll.images finished:^(NSArray *resultList) {
        [SVProgressHUD dismiss];
        BOOL hasError = NO;
        NSMutableArray *picids = [NSMutableArray arrayWithCapacity:10];
        for (NSDictionary *result in resultList) {
            NSDictionary *response = result[@"response"];
            if (![response isOK]) {
                hasError = YES;
            } else {
                [picids addObject:response[@"data"]];
            }
        }
        if (!hasError) {
            [self publishTxtWithPicIDs:[picids componentsJoinedByString:@"|"]];
        } else {
            [[NSError errorWithDomain:@"上传图片出错" code:101 userInfo:@{@"reason" : resultList}] showAlert];
        }
    }];
}


- (void)publishTxtWithPicIDs:(NSString *)pic_ids
{
    [SVProgressHUD show];
    //super will pop
    NSString *title = self.placeFrom.text;
    NSString *parent_id = @"1";
    NSString *address = self.placeTo.text;
    NSString *method = [self tripMethods];
    NSString *Aggregation_date = [self.btnTimeSet titleForState:UIControlStateNormal];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *explain = self.detailText.text;
    NSString *lng = [NSString stringWithFormat:@"%f", self.addrInfo.geoPt.longitude];
    NSString *lat = [NSString stringWithFormat:@"%f", self.addrInfo.geoPt.latitude];
    NSString *pos = self.addrInfo.strAddr;
    if (pos == nil) {
        pos = @"我在这个位置";
    }
    NSDictionary *para = @{@"typeid" : self.type, @"title": title, @"parent_id" : parent_id, @"mudi_address" : address, @"fangshi" : method, @"Aggregation_date" : Aggregation_date, @"uid" : uid, @"explain" : explain, @"lng" : lng, @"lat" : lat, @"pos" : pos, @"planning_cycle"  : @"0", @"costExplains" : @"0", @"pic_ids" : pic_ids};
    
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
        [error showTimeoutAlert];
    }];
}

- (void)done
{
    if (self.picRoll.images.count > 0) {
        [self publishTxtAndPic];
    } else {
        [self publishTxtWithPicIDs:@""];
    }
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


- (void)textViewDidBeginEditing:(UITextView *)textView
{
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    return YES;
}


@end
