//
//  NSDictionary+Huzhu.m
//  Metoow
//
//  Created by HalloWorld on 14-5-26.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "NSDictionary+Huzhu.h"
#import "HWDevice.h"

@implementation NSDictionary (Huzhu)

- (NSString *)huzhuTitle
{
    NSDictionary *dic = self;
    int type = [dic[@"type"] intValue];
    if (type == 1) {
        NSString *datestr = [dic[@"Aggregation_date"] apiDateCn];
        NSString *string = [NSString stringWithFormat:@"【结伴】%@，%@出发，%@去%@。预计费用：%@元，计划周期：%@天。", datestr, dic[@"title"], dic[@"fangshi"], dic[@"address"], dic[@"costExplains"], dic[@"planning_cycle"]];
        return string;
    }
    if (type == 2) {
        NSString *datestr = [dic[@"Aggregation_date"] apiDateCn];
        NSString *string = [NSString stringWithFormat:@"【顺风车】%@，%@出发，%@去%@。", datestr, dic[@"title"], dic[@"fangshi"], dic[@"address"]];
        return string;
    }
    if (type == 3) {
        NSString *datestr = [dic[@"Aggregation_date"] apiDateCn];
        NSString *string = [NSString stringWithFormat:@"【拼车】%@，%@出发，%@去%@。预计费用：%@元，计划周期：%@天。", datestr, dic[@"title"], dic[@"fangshi"], dic[@"address"], dic[@"costExplains"], dic[@"planning_cycle"]];
        return string;
    }
    if (type == 4) {
        NSString *datestr = [dic[@"Aggregation_date"] apiDateCn];
        NSString *string = [NSString stringWithFormat:@"【沙发客】%@%@附近%@至%@", dic[@"title"], dic[@"address"], dic[@"fangshi"], datestr];
        return string;
    }
    return @"";
}

@end
