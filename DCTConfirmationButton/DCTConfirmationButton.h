//
//  DCTConfirmationButton.h
//  DCTConfirmationButton
//
//  Created by Daniel Tull on 08.08.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSInteger, DCTConfirmationButtonState) {
	DCTConfirmationButtonStateNormal,
	DCTConfirmationButtonStateConfirmation,
	DCTConfirmationButtonStateLoading,
	DCTConfirmationButtonStateConfirmed
};

@interface DCTConfirmationButton : UIControl

- (NSString *)titleForState:(DCTConfirmationButtonState)state;
- (void)setTitle:(NSString *)title forState:(DCTConfirmationButtonState)state;

- (UIColor *)colorForState:(DCTConfirmationButtonState)state;
- (void)setColor:(UIColor *)color forState:(DCTConfirmationButtonState)state;

@property (nonatomic) DCTConfirmationButtonState buttonState;
- (void)setButtonState:(DCTConfirmationButtonState)buttonState animated:(BOOL)animated;

@end
