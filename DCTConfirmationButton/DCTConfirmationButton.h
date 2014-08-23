//
//  DCTConfirmationButton.h
//  DCTConfirmationButton
//
//  Created by Daniel Tull on 08.08.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

@import UIKit;

//! Project version number and string for DCTConfirmationButton.
FOUNDATION_EXPORT double DCTConfirmationButtonVersionNumber;
FOUNDATION_EXPORT const unsigned char DCTConfirmationButtonVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <DCTConfirmationButton/PublicHeader.h>
#import <DCTConfirmationButton/DCTConfirmationButtonLoadingView.h>

typedef NS_ENUM(NSInteger, DCTConfirmationButtonState) {
	DCTConfirmationButtonStateNormal,
	DCTConfirmationButtonStateConfirmation,
	DCTConfirmationButtonStateLoading,
	DCTConfirmationButtonStateConfirmed
};

IB_DESIGNABLE
@interface DCTConfirmationButton : UIControl

- (NSString *)titleForButtonState:(DCTConfirmationButtonState)buttonState;
- (void)setTitle:(NSString *)title forButtonState:(DCTConfirmationButtonState)buttonState;

- (UIColor *)colorForButtonState:(DCTConfirmationButtonState)buttonState;
- (void)setColor:(UIColor *)color forButtonState:(DCTConfirmationButtonState)buttonState;

@property (nonatomic) DCTConfirmationButtonState buttonState;
- (void)setButtonState:(DCTConfirmationButtonState)buttonState animated:(BOOL)animated;

@end
