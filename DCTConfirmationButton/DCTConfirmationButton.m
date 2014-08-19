//
//  DCTConfirmationButton.m
//  DCTConfirmationButton
//
//  Created by Daniel Tull on 08.08.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "DCTConfirmationButton.h"
#import "DCTConfirmationButtonInternal.h"
#import "DCTConfirmationButtonLoadingView.h"

@interface DCTConfirmationButton ()
@property (nonatomic) UIButton *button;
@property (nonatomic) UIButton *confirmationButton;
@property (nonatomic) UIButton *confirmedButton;
@property (nonatomic) UIImageView *loadingImageView;

@property (nonatomic, readonly) NSDictionary *views;
@property (nonatomic) UIView *currentView;
@property (nonatomic) NSTimer *confirmationTimer;
@end

@implementation DCTConfirmationButton

#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (!self) return nil;
	[self setupDefaultColors];
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (!self) return nil;
	[self setupDefaultColors];
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	UIView *view = [self viewForButtonState:self.buttonState];
	[self addSubview:view];
	self.currentView = view;
}

- (CGSize)intrinsicContentSize {
	return [self.currentView intrinsicContentSize];
}

- (void)setContentMode:(UIViewContentMode)contentMode {
	[super setContentMode:contentMode];
	self.loadingImageView.contentMode = contentMode;
	[self setNeedsLayout];
}

#pragma mark - UIControl

- (void)setEnabled:(BOOL)enabled {
	[super setEnabled:enabled];
	[self.button setEnabled:enabled];
	[self.confirmationButton setEnabled:enabled];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
	[super addTarget:target action:action forControlEvents:controlEvents];
}

- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
	[super removeTarget:target action:action forControlEvents:controlEvents];
}

#pragma mark - DCTConfirmationButton

- (void)setButtonState:(DCTConfirmationButtonState)buttonState {
	[self setButtonState:buttonState animated:NO];
}

- (void)setButtonState:(DCTConfirmationButtonState)buttonState animated:(BOOL)animated {

	[self.confirmationTimer invalidate];
	self.confirmationTimer = nil;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdirect-ivar-access"

	if (_buttonState == buttonState) {
		return;
	}

	_buttonState = buttonState;

#pragma clang diagnostic pop

	UIView *oldView = self.currentView;
	UIView *newView = [self viewForButtonState:buttonState];
	newView.alpha = 0.0f;
	[self addSubview:newView];
	self.currentView = newView;

	NSTimeInterval duration = animated ? 0.5f : 0.0f;
	[UIView animateWithDuration:duration delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{

		[self.superview layoutIfNeeded];
		newView.alpha = 1.0f;
		oldView.alpha = 0.0f;

	} completion:^(BOOL finished) {
		[oldView removeFromSuperview];
	}];
}

- (void)setTitle:(NSString *)title forButtonState:(DCTConfirmationButtonState)buttonState {
	UIView *view = [self viewForButtonState:buttonState];
	if ([view isKindOfClass:[UIButton class]]) {
		UIButton *button = (UIButton *)view;
		[button setTitle:title forState:UIControlStateNormal];
	}
}
- (NSString *)titleForButtonState:(DCTConfirmationButtonState)buttonState {
	UIView *view = [self viewForButtonState:buttonState];
	if ([view isKindOfClass:[UIButton class]]) {
		UIButton *button = (UIButton *)view;
		return [button titleForState:UIControlStateNormal];
	}

	return nil;
}

- (void)setColor:(UIColor *)color forButtonState:(DCTConfirmationButtonState)buttonState {
	UIView *view = [self viewForButtonState:buttonState];
	view.tintColor = color;
	if ([view isKindOfClass:[UIButton class]]) {
		UIButton *button = (UIButton *)view;
		[button setTitleColor:color forState:UIControlStateNormal];
		[button setTitleColor:self.backgroundColor forState:UIControlStateHighlighted];
		[button setTitleColor:self.backgroundColor forState:UIControlStateSelected];
	}
}

- (UIColor *)colorForButtonState:(DCTConfirmationButtonState)buttonState {
	UIView *view = [self viewForButtonState:buttonState];
	return view.tintColor;
}

#pragma mark - Internal

- (void)setupDefaultColors {
	UIColor *greenColor = [UIColor colorWithRed:0.141f green:0.667f blue:0.169f alpha:1.0f];
	[self setColor:self.tintColor forButtonState:DCTConfirmationButtonStateNormal];
	[self setColor:self.tintColor forButtonState:DCTConfirmationButtonStateLoading];
	[self setColor:[UIColor lightGrayColor] forButtonState:DCTConfirmationButtonStateConfirmed];
	[self setColor:greenColor forButtonState:DCTConfirmationButtonStateConfirmation];
}

- (IBAction)buttonTapped:(id)sender {
	[self setButtonState:DCTConfirmationButtonStateConfirmation animated:YES];
	self.confirmationTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(reset:) userInfo:nil repeats:NO];
}

- (IBAction)confirmationButtonTapped:(id)sender {
	[self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)reset:(id)sender {
	[self setButtonState:DCTConfirmationButtonStateNormal animated:YES];
}

- (UIView *)viewForButtonState:(DCTConfirmationButtonState)state {
	UIView *view = [self.views objectForKey:@(state)];
	
	return view;
}

- (UIButton *)button {

	if (!_button) {
		_button = [[DCTConfirmationButtonInternal alloc] initWithFrame:self.bounds];
		[_button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
	}

	return _button;
}

- (UIButton *)confirmationButton {

	if (!_confirmationButton) {
		_confirmationButton = [[DCTConfirmationButtonInternal alloc] initWithFrame:self.bounds];
		[self.confirmationButton addTarget:self	action:@selector(confirmationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	}

	return _confirmationButton;
}

- (UIButton *)confirmedButton {

	if (!_confirmedButton) {
		_confirmedButton = [[DCTConfirmationButtonInternal alloc] initWithFrame:self.bounds];
		_confirmedButton.enabled = NO;
	}

	return _confirmedButton;
}

- (UIImageView *)loadingImageView {

	if (!_loadingImageView) {
		_loadingImageView = [DCTConfirmationButtonLoadingView new];
	}

	return _loadingImageView;
}

- (NSDictionary *)views {
	return @{
		@(DCTConfirmationButtonStateNormal) : self.button,
		@(DCTConfirmationButtonStateConfirmation) : self.confirmationButton,
		@(DCTConfirmationButtonStateConfirmed) : self.confirmedButton,
		@(DCTConfirmationButtonStateLoading) : self.loadingImageView
	};
}

- (void)setCurrentView:(UIView *)currentView {

	if ([currentView isEqual:self.currentView]) {
		return;
	}

	_currentView = currentView;
	[self invalidateIntrinsicContentSize];
}

@end
