//
//  FootPubViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-4-13.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "FootPubViewController.h"
#import "FootDetailViewController.h"
#import "FileUploader.h"
#import "LocationManager.h"

@interface FootPubViewController ()

@end

@implementation FootPubViewController

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
    if (self.editCategary == FootPubEditCategaryPublish) {
        [self.isPublic setChecked:YES];
        [self.inputBar setOutsideInput:self.textView];
        self.textView.inputAccessoryView = self.inputBar;
        self.inputBar.delegate = self;
        [self.textView becomeFirstResponder];
    }
    else if (self.editCategary == FootPubEditCategaryWeather) {
        [self.isPublic setChecked:YES];
        self.isPublic.hidden = YES;
        [self.inputBar setOutsideInput:self.textView];
        self.textView.inputAccessoryView = self.inputBar;
        self.inputBar.delegate = self;
        [self.textView becomeFirstResponder];
    }
    else {
        self.isPublic.hidden = YES;
        self.addrLabel.hidden = YES;
        self.textView.inputAccessoryView = self.inputBar;
        [self.inputBar setOutsideInput:self.textView];
        [self.inputBar setSendStyle];
        self.inputBar.delegate = self;
        [self.textView becomeFirstResponder];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateAddrInfo:) userInfo:nil repeats:YES];
}

- (void)updateAddrInfo:(NSTimer *)timer
{
    self.addrLabel.text = ([[LocationManager shareInterface] addrInfo].strAddr == nil) ? (@"您的位置") : ([[LocationManager shareInterface] addrInfo].strAddr);
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

- (IBAction)btnBackTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDoneTap:(id)sender {
    if (self.textView.text.length > 0) {
        [self sendContent:self.textView.text];
    } else {
        [[NSError errorWithDomain:@"输入内容不能为空" code:100 userInfo:nil] showAlert];
    }
}

//发信息的总入口，判断发布、转发、回复
- (void)sendContent:(NSString *)txt
{
    if (self.editCategary == FootPubEditCategaryPublish) {
        [self publishTxtContent:txt];
    }
    if (self.editCategary == FootPubEditCategaryTransmit) {
        [self transmitTxtContent:txt];
    }
    if (self.editCategary == FootPubEditCategaryReply) {
        [self replyTxtContent:txt];
    }
    if (self.editCategary == FootPubEditCategaryWeather) {
        [self publishWeather:txt];
    }
    if (self.editCategary == FootPubEditCategaryReplyHuzhu || self.editCategary == FootPubEditCategaryReplySOS) {
        [self replyHuzhu:txt];
    }
    if (self.editCategary == FootPubEditCategaryTransmitHuzhu || self.editCategary == FootPubEditCategaryTransmitSOS) {
        [self transmitHuzhu:txt];
    }
}


//回复互助
- (void)replyHuzhu:(NSString *)txt
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *row_id = self.editCategary == FootPubEditCategaryReplySOS ? self.dataDic[@"sos_id"] : self.dataDic[@"id"];
    NSString *table_name = self.editCategary == FootPubEditCategaryReplySOS ? @"sos" : @"huzhu";
    NSString *app_name = self.editCategary == FootPubEditCategaryReplySOS ? @"sos" : @"huzhu";
    NSDictionary *dic = @{@"row_id" : row_id, @"app_name" : app_name, @"table_name" : table_name, @"content" : txt};
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_System act:Mod_System_comment Paras:dic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
            for (id vc in [self.navigationController viewControllers]) {
                if ([vc isKindOfClass:[FootDetailViewController class]]) {
                    [vc refresh];
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showTimeoutAlert];
    }];
}

//转发互助
- (void)transmitHuzhu:(NSString *)txt
{
    [SVProgressHUD show];
    NSString *row_id = self.editCategary == FootPubEditCategaryTransmitSOS ? self.dataDic[@"sos_id"] : self.dataDic[@"id"];
    NSString *table_name = self.editCategary == FootPubEditCategaryTransmitSOS ? @"sos" : @"huzhu";
    NSString *app_name = self.editCategary == FootPubEditCategaryTransmitSOS ? @"sos" : @"huzhu";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{@"sid" : row_id, @"type" : table_name, @"app_name" : app_name, @"body" : txt};
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_System act:Mod_System_share Paras:dic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

//足迹转发
- (void)transmitTxtContent:(NSString *)txt
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{@"sid" : self.dataDic[@"id"], @"type" : @"foot", @"app_name" : @"foot", @"body" : txt};
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_System act:@"share" Paras:dic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

//足迹评论
- (void)replyTxtContent:(NSString *)txt
{
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{@"row_id" : self.dataDic[@"id"], @"app_name" : @"foot", @"table_name" : @"foot", @"content" : txt};
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_System act:Mod_System_comment Paras:dic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject isOK]) {
//            for (id vc in [self.navigationController viewControllers]) {
//                if ([vc isKindOfClass:[FootDetailViewController class]]) {
//                    [vc refresh];
//                }
//            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [[responseObject error] showAlert];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [error showTimeoutAlert];
    }];
}

//发布一条足迹+图片
- (void)publishTxtContent:(NSString *)txt
{
    BMKAddrInfo *myaddrInfo = [LocationManager shareInterface].addrInfo;
    if (myaddrInfo == nil) {
        [[NSError errorWithDomain:@"正在解析位置信息，请稍后！" code:100 userInfo:nil] showAlert];
        return ;
    }
    if (self.picRoll.mImageArray.count > 0) {
        //图文并发
        [self publishTxtAndImagesContent:txt];
    } else {
        //仅发布文字
        [SVProgressHUD show];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        BOOL isPub = [self.isPublic checked];
        NSNumber *publ = [NSNumber numberWithBool:!isPub];
        NSString *lat = [NSString stringWithFormat:@"%lf", myaddrInfo.geoPt.latitude];
        NSString *lng = [NSString stringWithFormat:@"%lf", myaddrInfo.geoPt.longitude];
        [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Foot act:Mod_Foot_add_foot Paras:@{@"pos": self.addrLabel.text, @"desc" : txt, @"open" : publ, @"lng" : lng, @"lat" : lat, @"pic_ids" : @""}] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
}

- (void)publishTxtAndImagesContent:(NSString *)txt
{
    if ([LocationManager shareInterface].addrInfo == nil) {
        [[NSError errorWithDomain:@"正在解析位置信息，请稍后！" code:100 userInfo:nil] showAlert];
        return ;
    }
    [SVProgressHUD show];
    NSArray *imgArr = self.picRoll.mImageArray;
    __block AFHTTPRequestOperationManager *manager = [FileUploader uploadTo:UploadCategaryFoot images:imgArr finished:^(NSArray *resultList) {
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
            [SVProgressHUD show];
            BOOL isPub = [self.isPublic checked];
            NSNumber *publ = [NSNumber numberWithBool:!isPub];
            BMKAddrInfo *myaddrInfo = [LocationManager shareInterface].addrInfo;
            NSString *lat = [NSString stringWithFormat:@"%lf", myaddrInfo.geoPt.latitude];
            NSString *lng = [NSString stringWithFormat:@"%lf", myaddrInfo.geoPt.longitude];
            [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Foot act:Mod_Foot_add_foot Paras:@{@"pos": self.addrLabel.text, @"desc" : txt, @"open" : publ, @"lng" : lng, @"lat" : lat, @"pic_ids" : [picids componentsJoinedByString:@"|"]}] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        } else {
            [[NSError errorWithDomain:@"上传图片出错" code:101 userInfo:@{@"reason" : resultList}] showAlert];
        }
    }];
}

- (void)publishWeather:(NSString *)txt
{
    if ([[LocationManager shareInterface] addrInfo] == nil) {
        [[NSError errorWithDomain:@"正在解析位置信息，请稍后！" code:100 userInfo:nil] showAlert];
        return ;
    }
    [SVProgressHUD show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    BMKAddrInfo *myaddrinfo = [[LocationManager shareInterface] addrInfo];
    NSString *lat = [NSString stringWithFormat:@"%lf", myaddrinfo.geoPt.latitude];
    NSString *lng = [NSString stringWithFormat:@"%lf", myaddrinfo.geoPt.longitude];
    [manager GET:API_URL parameters:[APIHelper packageMod:Mod_Weather act:Mod_Weather_add_weather Paras:@{@"pos": [[LocationManager shareInterface] addrInfo].strAddr, @"desc" : txt, @"lng" : lng, @"lat" : lat, @"pic_ids" : @""}] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

#pragma mark - MSGInput View

/**
 *  发文字
 *
 *  @param inputView MSGInputView
 *  @param txt       文字内容包含表情的标示符字符串
 */
- (void)inputView:(MSGInputView *)inputView didSendCotent:(NSString *)txt
{
    [self sendContent:[txt copy]];
}

/**
 *  发图片
 *
 *  @param inputView MSGInputView
 *  @param img       发送的图片UIImage对象
 */
- (void)inputView:(MSGInputView *)inputView didSendPicture:(UIImage *)img
{
    [self showInputBarOnBottom];
    if (img == nil) {
        return ;
    }
    NSData *dat = UIImageJPEGRepresentation(img, 0.8);
    NSLog(@"%s -> %d    size(%f, %f)", __FUNCTION__, dat.length, img.size.width, img.size.height);
    [self.picRoll addImage:img];
}


- (void)showInputBarOnBottom
{
    UIView *sview = [[self inputBar] superview];
    if (!sview) {
        self.inputBar.frame = CGRectMake(0, self.view.frame.size.height - self.inputBar.frame.size.height, self.inputBar.frame.size.width, self.inputBar.frame.size.height);
        [self.view addSubview:self.inputBar];
    }
}


@end
