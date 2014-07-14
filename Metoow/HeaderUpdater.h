//
//  HeaderUpdater.h
//  Metoow
//
//  Created by HalloWorld on 14-7-14.
//  Copyright (c) 2014年 HalloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HeaderUpdaterProtocol <NSObject>

- (void)updateHeaderSuccess:(UIImage *)header;

@end

@interface HeaderUpdater : NSObject <UIActionSheetDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) id<HeaderUpdaterProtocol> delegate;

- (instancetype)initWithDelegate:(id<HeaderUpdaterProtocol>)dlgt;

- (void)chooseHeader;

@end
