//
//  DCTStoreButton.h
//  DCTStoreButton
//
//  Created by Daniel Tull on 08.08.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCTStoreButton : UIButton

- (NSString *)confirmationTitleForState:(UIControlState)state;
- (void)setConfirmationTitle:(NSString *)title forState:(UIControlState)state;

@property (nonatomic, copy) UIColor *confirmationTint;

@end
