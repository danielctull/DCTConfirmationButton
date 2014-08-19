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

- (NSString *)titleForButtonState:(DCTConfirmationButtonState)buttonState;
- (void)setTitle:(NSString *)title forButtonState:(DCTConfirmationButtonState)buttonState;

- (UIColor *)colorForButtonState:(DCTConfirmationButtonState)buttonState;
- (void)setColor:(UIColor *)color forButtonState:(DCTConfirmationButtonState)buttonState;

@property (nonatomic) DCTConfirmationButtonState buttonState;
- (void)setButtonState:(DCTConfirmationButtonState)buttonState animated:(BOOL)animated;

@end
