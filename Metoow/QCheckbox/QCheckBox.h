//
//  EICheckBox.h
//  EInsure
//
//  Created by ivan on 13-7-9.
//  Copyright (c) 2013年 ivan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Q_CHECK_ICON_WH                    (15.0)
#define Q_ICON_TITLE_MARGIN                (3.0)

@protocol QCheckBoxDelegate;

@interface QCheckBox : UIButton {
    id<QCheckBoxDelegate> _delegate;
    BOOL _checked;
    id _userInfo;
}

@property(nonatomic, assign)id<QCheckBoxDelegate> delegate;
@property(nonatomic, assign)BOOL checked;
@property(nonatomic, retain)id userInfo;

- (id)initWithDelegate:(id)delegate;

- (void)initView;

@end

@protocol QCheckBoxDelegate <NSObject>

@optional

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked;

@end
