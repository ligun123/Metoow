//
//  HPjbViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-5-22.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HPjbViewController.h"

@interface HPjbViewController ()

@end

@implementation HPjbViewController

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
    self.type = @"1";
    [self.myAccessaryView setOutsideInput:self.detailText];
    self.detailText.inputAccessoryView = self.myAccessaryView;
    // Do any additional setup after loading the view from its nib.
    self.contentView.contentSize = CGSizeMake(320, 555);
    self.detailText.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (void)publishTxtWithPicIDs:(NSString *)pic_ids
{
    [SVProgressHUD show];
    //super will pop
    NSString *title = self.placeFrom.text;
    NSString *parent_id = @"1";
    NSString *address = self.placeTo.text;
    NSString *method = [self tripMethods];
    NSString *planning_cycle = self.timeCost.text;
    NSString *Aggregation_date = [self.btnTimeSet titleForState:UIControlStateNormal];
    NSString *costExplains = self.moneyCost.text;
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *explain = self.detailText.text;
    NSString *lng = [NSString stringWithFormat:@"%f", self.addrInfo.geoPt.longitude];
    NSString *lat = [NSString stringWithFormat:@"%f", self.addrInfo.geoPt.latitude];
    NSString *pos = self.addrInfo.strAddr;
    if (pos == nil) {
        pos = @"我在这个位置";
    }
    NSDictionary *para = @{@"typeid" : self.type, @"title": title, @"parent_id" : parent_id, @"mudi_address" : address, @"fangshi" : method, @"planning_cycle" : planning_cycle, @"Aggregation_date" : Aggregation_date, @"costExplains" : costExplains, @"uid" : uid, @"explain" : explain, @"lng" : lng, @"lat" : lat, @"pos" : pos, @"pic_ids" : pic_ids};
    
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

- (void)done
{
    if (self.picRoll.images.count > 0) {
        [self publishTxtAndPic];
    } else {
        [self publishTxtWithPicIDs:@""];
    }
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.contentView.scrollEnabled = NO;
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.contentView.scrollEnabled = YES;
}



@end
