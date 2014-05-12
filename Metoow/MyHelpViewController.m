//
//  MyHelpViewController.m
//  Metoow
//
//  Created by HalloWorld on 14-4-13.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "MyHelpViewController.h"
#import "MessageView.h"

@interface MyHelpViewController ()

@end

@implementation MyHelpViewController

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
    MessageView *msgview = [[MessageView alloc] initWithFrame:CGRectMake(20, 74, 280, 80)];
    [self.view addSubview:msgview];
    msgview.backgroundColor = [UIColor clearColor];
    msgview.layer.borderWidth = 1.0;
    msgview.layer.borderColor = [UIColor blackColor].CGColor;
    [msgview showStringMessage:@"dal   h[aoman]daklsdjklasjdklasd[aoman][aoman]dasdakjsdakl"];
    CGRect f = msgview.frame;
    f.size = [msgview contentSize];
    msgview.frame = f;
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

@end
