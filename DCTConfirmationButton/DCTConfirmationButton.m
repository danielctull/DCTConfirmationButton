//
//  DCTConfirmationButton.m
//  DCTConfirmationButton
//
//  Created by Daniel Tull on 08.08.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "DCTConfirmationButton.h"
#import "DCTConfirmationButtonInternal.h"
#import "DCTConfirmationButtonRotatingImageView.h"

@interface DCTConfirmationButton ()
@property (nonatomic) UIButton *button;
@property (nonatomic) UIButton *confirmationButton;
@property (nonatomic) UIButton *confirmedButton;
@property (nonatomic) UIImageView *loadingImageView;
@property (nonatomic) UIView *currentView;
@end

@implementation DCTConfirmationButton

- (id)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (!self) return nil;
	[self sharedInit];
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (!self) return nil;
	[self sharedInit];
	return self;
}

- (void)sharedInit {

	UIColor *greenColor = [UIColor colorWithRed:0.141f green:0.667f blue:0.169f alpha:1.0f];

	[self setColor:self.tintColor forState:DCTConfirmationButtonStateNormal];
	[self setColor:self.tintColor forState:DCTConfirmationButtonStateLoading];
	[self setColor:[UIColor lightGrayColor] forState:DCTConfirmationButtonStateConfirmed];
	[self setColor:greenColor forState:DCTConfirmationButtonStateConfirmation];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	UIView *view = [self viewForState:self.buttonState];
	view.frame = [self frameForView:view];
	[self addSubview:view];
	self.currentView = view;
}

- (CGRect)frameForView:(UIView *)view {
	CGSize size = [view intrinsicContentSize];
	CGRect frame = view.frame;
	frame.size.width = size.width;
	frame.origin.x = self.bounds.size.width - size.width;
	return frame;
}

- (void)buttonTapped:(id)sender {

	[self setButtonState:DCTConfirmationButtonStateConfirmation animated:YES];

	double delayInSeconds = 3.0f;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		[self tappedOutside:self];
	});
}

- (void)setEnabled:(BOOL)enabled {
	[super setEnabled:enabled];
	[self.button setEnabled:enabled];
	[self.confirmationButton setEnabled:enabled];
}

//- (void)setLoading:(BOOL)loading {
//
//	if (_loading == loading) return;
//
//	_loading = loading;
//
//	NSString *rotationKey = @"rotation";
//
//	if (loading) {
//
//		CGRect frame = self.loadingImageView.bounds;
//		frame.origin.x = self.bounds.size.width - frame.size.width;
//
//		self.loadingImageView.alpha = 0.0f;
//		self.loadingImageView.frame = frame;
//		[self addSubview:self.loadingImageView];
//
//		CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//		rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
//		rotationAnimation.duration = 1.0f;
//		rotationAnimation.cumulative = YES;
//		rotationAnimation.repeatCount = CGFLOAT_MAX;
//		[self.loadingImageView.layer addAnimation:rotationAnimation forKey:rotationKey];
//
//		self.confirmationButton.titleLabel.font = [UIFont systemFontOfSize:0.0f];
//
//		[self animate:^{
//			self.confirmationButton.frame = frame;
//		} completion:nil];
//
//		[UIView animateWithDuration:0.1f delay:0.15f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//
//			self.confirmationButton.alpha = 0.0f;
//			self.loadingImageView.alpha = 1.0f;
//
//		} completion:^(BOOL finished) {
//			[self.confirmationButton removeFromSuperview];
//			self.confirmationButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
//		}];
//
//	} else {
//
//		self.button.alpha = 0.0f;
//		self.button.frame = self.loadingImageView.frame;
//		[self addSubview:self.button];
//
//		[self animate:^{
//			self.button.frame = [self frameForButton];
//			self.button.alpha = 1.0f;
//			self.loadingImageView.alpha = 0.0f;
//		} completion:^(BOOL finished) {
//			[self.loadingImageView.layer removeAnimationForKey:rotationKey];
//			[self.loadingImageView removeFromSuperview];
//		}];
//
////		[self animate:^{
////			self.button.alpha = 1.0f;
////			self.loadingImageView.alpha = 0.0f;
////		} completion:nil];
//	}
//}

- (void)tappedOutside:(id)sender {

	if (self.buttonState == DCTConfirmationButtonStateConfirmed) return;

	[self setButtonState:DCTConfirmationButtonStateNormal animated:YES];
}

#pragma mark - DCTConfirmationButton

- (void)setButtonState:(DCTConfirmationButtonState)buttonState {
	[self setButtonState:buttonState animated:NO];
}

- (void)setButtonState:(DCTConfirmationButtonState)buttonState animated:(BOOL)animated {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdirect-ivar-access"
	_buttonState = buttonState;
#pragma clang diagnostic pop

	UIView *oldView = self.currentView;
	UIView *newView = [self viewForState:buttonState];
	newView.frame = oldView.frame;
	newView.alpha = 0.0f;
	self.currentView = newView;
	CGRect frame = [self frameForView:newView];

	NSTimeInterval duration = animated ? 0.3f : 0.0f;
	[UIView animateWithDuration:duration delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{

		newView.alpha = 1.0f;
		oldView.alpha = 0.0f;
		newView.frame = frame;
		oldView.frame = frame;

	} completion:^(BOOL finished) {
		[oldView removeFromSuperview];
	}];
}

- (UIView *)viewForState:(DCTConfirmationButtonState)state {

	switch (state) {

		case DCTConfirmationButtonStateNormal:
			return self.button;

		case DCTConfirmationButtonStateConfirmation:
			return self.confirmationButton;

		case DCTConfirmationButtonStateConfirmed:
			return self.confirmedButton;

		case DCTConfirmationButtonStateLoading:
			return self.loadingImageView;
	}
}

- (void)setTitle:(NSString *)title forState:(DCTConfirmationButtonState)state {
	UIView *view = [self viewForState:state];
	if ([view isKindOfClass:[UIButton class]]) {
		UIButton *button = (UIButton *)view;
		[button setTitle:title forState:UIControlStateNormal];
	}
}

- (NSString *)titleForState:(DCTConfirmationButtonState)state {
	UIView *view = [self viewForState:state];
	if ([view isKindOfClass:[UIButton class]]) {
		UIButton *button = (UIButton *)view;
		return [button titleForState:UIControlStateNormal];
	}

	return nil;
}

- (void)setColor:(UIColor *)color forState:(DCTConfirmationButtonState)state {
	UIView *view = [self viewForState:state];
	view.tintColor = color;
	if ([view isKindOfClass:[UIButton class]]) {
		UIButton *button = (UIButton *)view;
		[button setTitleColor:color forState:UIControlStateNormal];
	}
}

- (UIColor *)colorForState:(DCTConfirmationButtonState)state {
	UIView *view = [self viewForState:state];
	return view.tintColor;
}

#pragma mark - Lazy Getters

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
		_loadingImageView = [DCTConfirmationButtonRotatingImageView new];
	}

	return _loadingImageView;
}







- (void)setConfirmationTitle:(NSString *)title forState:(UIControlState)state {
	[self.confirmationButton setTitle:title forState:state];
}

- (NSString *)confirmationTitleForState:(UIControlState)state {
	return [self.confirmationButton titleForState:state];
}

- (void)setConfirmationTitleColor:(UIColor *)color forState:(UIControlState)state {
	[self.confirmationButton setTitleColor:color forState:state];
}

- (UIColor *)confirmationTitleColorForState:(UIControlState)state {
	return [self.confirmationButton titleColorForState:state];
}

- (void)setConfirmationTintColor:(UIColor *)confirmationTintColor {
	self.confirmationButton.tintColor = confirmationTintColor;
}

- (UIColor *)confirmationTintColor {
	return self.confirmationButton.tintColor;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
	[self.confirmationButton addTarget:target action:action forControlEvents:controlEvents];
}

- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
	[self.confirmationButton removeTarget:target action:action forControlEvents:controlEvents];
}

@end
