//
//  LocationManager.h
//  Metoow
//
//  Created by HalloWorld on 14-6-4.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationManager : NSObject
{
    BMKSearch *baiduSearch;
    BMKUserLocation *userLocation;
}

@property (strong, nonatomic) BMKAddrInfo *addrInfo;

+ (instancetype)shareInterface;

@end
