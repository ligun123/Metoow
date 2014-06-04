//
//  LocationManager.m
//  Metoow
//
//  Created by HalloWorld on 14-6-4.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

static LocationManager *interface = nil;

+ (instancetype)shareInterface
{
    if (interface == nil) {
        interface = [[LocationManager alloc] init];
    }
    return interface;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self fatchMapLocation];
    }
    return self;
}

#pragma mark - Baidu Map

- (void)fatchMapLocation
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


@end
