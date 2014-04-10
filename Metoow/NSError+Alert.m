//
//  NSError+Alert.m
//  ZHMS-PDA
//
//  Created by Jackson.He on 14-3-14.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "NSError+Alert.h"

@implementation NSError (Alert)


- (void)showAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.domain message:[self.userInfo description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
