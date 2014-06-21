//
//  HelpPubViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-4-13.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "HelpPubViewController.h"

@interface HelpPubViewController ()

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation HelpPubViewController

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
    self.view.backgroundColor = COLOR_RGB(244, 241, 246);
    [self fatchMapLocation];
    self.contentView.contentSize = CGSizeMake(320, 500);
    [self.picRoll enableScan];
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

- (MSGInputView *)myAccessaryView
{
    if (_myAccessaryView == nil) {
        _myAccessaryView = [[MSGInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, 320, 44)];
        _myAccessaryView.delegate = self;
        _myAccessaryView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    }
    return _myAccessaryView;
}

- (IBAction)btnBackTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)btnDoneTap:(id)sender {
    [self done];
}




- (void)done
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnMultiCheckTap:(QCheckBox *)sender        //复选框选择
{
}


- (IBAction)btnSignleCheckTap:(QCheckBox *)sender       //单选框选择
{
    for (QCheckBox *box in [[sender superview] subviews]) {
        if (box != sender) {
            [box setChecked:NO];
        }
    }
}


- (IBAction)btnTimeTap:(id)sender
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    //add picker
    UIDatePicker *picker = [self datePicker];
    [self.view addSubview:picker];
    //添加ToolBar
    UIView *toolbar = [self toolbar];
    [self.view addSubview:toolbar];
}

- (UIDatePicker *)datePicker
{
    if (_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc] init];
        [_datePicker setTimeZone:[NSTimeZone systemTimeZone]];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        _datePicker.frame = CGRectOffset(_datePicker.frame, 0, self.view.frame.size.height - _datePicker.frame.size.height);
    }
    return _datePicker;
}

- (UIToolbar *)toolbar
{
    if (_toolbar == nil) {
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *pickerDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnPickerDoneTap:)];
        [_toolbar setItems:@[space, pickerDone]];
        _toolbar.frame = CGRectOffset(_toolbar.frame, 0, self.view.frame.size.height - self.datePicker.frame.size.height - _toolbar.frame.size.height);
    }
    return _toolbar;
}


- (void)btnPickerDoneTap:(UIBarButtonItem *)item
{
    NSDate *date = [self.datePicker date];
    if ([date compare:[NSDate date]] == NSOrderedAscending) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请选择一个将来的时间" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return ;
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *title = [fmt stringFromDate:date];
    [self.btnTimeSet setTitle:title forState:UIControlStateNormal];
    [self.datePicker removeFromSuperview];
    [self.toolbar removeFromSuperview];
}

#pragma mark - Baidu Map

-(void)fatchMapLocation
{
    if (baiduSearch == nil)
    {
        userLocation = [[BMKUserLocation alloc] init];
        userLocation.delegate = self;
        [userLocation startUserLocationService];
        baiduSearch = [[BMKSearch alloc] init];
        baiduSearch.delegate = self;
    }
}


/**
 *返回地址信息搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKErrorCode
 */
- (void)onGetAddrResult:(BMKSearch*)searcher result:(BMKAddrInfo*)result errorCode:(int)error
{
    self.addrInfo = result;
}

- (void)viewDidGetLocatingUser:(CLLocationCoordinate2D)userLoc
{
    [baiduSearch reverseGeocode:userLoc];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    char c = [text UTF8String][0];
    if (c == '\t' || c == '\n') {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - MSG Input View

/**
 *  发文字
 *
 *  @param inputView MSGInputView
 *  @param txt       文字内容包含表情的标示符字符串
 */
- (void)inputView:(MSGInputView *)inputView didSendCotent:(NSString *)txt
{
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
    UIView *sview = [[self myAccessaryView] superview];
    if (!sview) {
        self.myAccessaryView.frame = CGRectMake(0, self.view.frame.size.height - self.myAccessaryView.frame.size.height, self.myAccessaryView.frame.size.width, self.myAccessaryView.frame.size.height);
        [self.view addSubview:self.myAccessaryView];
    }
}




@end
