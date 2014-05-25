//
//  PulldownButton.m
//  Metoow
//
//  Created by HalloWorld on 14-4-21.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "PulldownButton.h"

#define kWidthIndicator 18.f
#define kHeightCell 24.f

@implementation PulldownButton


+ (PulldownButton *)pulldownButtonWithTitles:(NSArray *)arr callback:(PulldownCallback)block
{
    PulldownButton *pld = [PulldownButton buttonWithType:UIButtonTypeCustom];
    pld.callbackBlock = block;
    [pld initFirst];
    [pld setTitles:arr];
    return pld;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initFirst];
}

- (UITableView *)pullListView
{
    if (pullListView == nil) {
        pullListView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.pullList.count * kHeightCell + 15.f) style:UITableViewStylePlain];   //加上header的高度
        pullListView.delegate = self;
        pullListView.dataSource = self;
        pullListView.backgroundColor = [UIColor clearColor];
        pullListView.scrollEnabled = NO;
        pullListView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return pullListView;
}

- (void)showDownList
{
    isSelect = YES;
    UITableView *table = [self pullListView];
    [[self superview] addSubview:table];
}

- (void)dismisDownList
{
    isSelect = NO;
    [[self pullListView] removeFromSuperview];
}

- (void)meTap
{
    isSelect = !isSelect;
    if (isSelect) {
        [self showDownList];
    } else {
        [self dismisDownList];
    }
}

- (void)initFirst
{
    labelFont = [UIFont boldSystemFontOfSize:18.f];
    [self.titleLabel setFont:labelFont];
    [self setImage:[UIImage imageNamed:@"pb_downlist_btn"] forState:UIControlStateNormal];
    [self addTarget:self action:@selector(meTap) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setTitles:(NSArray *)arr
{
    self.pullList = arr;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitle:arr[0] forState:UIControlStateNormal];
    self.titleLabel.textAlignment = UITextAlignmentCenter;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(CGRectGetWidth(contentRect) - kWidthIndicator, (CGRectGetHeight(contentRect) - kWidthIndicator) / 2, kWidthIndicator, kWidthIndicator);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, CGRectGetWidth(contentRect) - kWidthIndicator, CGRectGetHeight(contentRect));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark - UITableView Delegate & Datasource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14.f];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pb_downlist_bkg"]];
    }
    cell.textLabel.text = self.pullList[indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pullList.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismisDownList];
    [self setTitle:self.pullList[indexPath.row] forState:UIControlStateNormal];
    if (self.callbackBlock) {
        self.callbackBlock(self, indexPath.row);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 15.f)];
    view.image = [UIImage imageNamed:@"pb_downlistTop_bkg"];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeightCell;
}


@end
