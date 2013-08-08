//
//  DCTStoreButton.m
//  DCTStoreButton
//
//  Created by Daniel Tull on 08.08.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "DCTStoreButton.h"

@interface DCTStoreButton ()
@property (nonatomic) UIGestureRecognizer *tapOutsideGestureRecognizer;
@property (nonatomic) UIButton *button;
@property (nonatomic) UIButton *confirmationButton;
@property (nonatomic) UIImageView *loadingImageView;
@end

@implementation DCTStoreButton

- (void)dealloc {
	[self.tapOutsideGestureRecognizer.view removeGestureRecognizer:self.tapOutsideGestureRecognizer];
}

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

	[super setTitle:@"" forState:UIControlStateNormal];
	[super setImage:[UIImage new] forState:UIControlStateNormal];
	[self setShowsTouchWhenHighlighted:NO];

	self.confirmationTintColor = [UIColor colorWithRed:0.141f green:0.667f blue:0.169f alpha:1.0f];

	[self setTitleColor:self.tintColor forState:UIControlStateNormal];
	[self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	[self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
	[self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];

	[self setConfirmationTitleColor:self.confirmationTintColor forState:UIControlStateNormal];
	[self setConfirmationTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	[self setConfirmationTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
	[self setConfirmationTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];

	[self addSubview:self.button];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.button.frame = [self frameForButton];
}

- (CGRect)frameForConfirmationButton {
	CGSize size = [self.confirmationButton sizeThatFits:self.bounds.size];
	size.width += 12.0f;
	CGRect frame = self.button.frame;
	frame.size.width = size.width;
	frame.origin.x = self.bounds.size.width - size.width;
	return frame;
}

- (CGRect)frameForButton {
	CGSize size = [self.button sizeThatFits:self.bounds.size];
	size.width += 12.0f;
	CGRect frame = self.button.frame;
	frame.size.width = size.width;
	frame.origin.x = self.bounds.size.width - size.width;
	return frame;
}

- (void)willMoveToSuperview:(UIView *)superview {
	[super willMoveToSuperview:superview];
	[self.tapOutsideGestureRecognizer.view removeGestureRecognizer:self.tapOutsideGestureRecognizer];
}

- (void)willMoveToWindow:(UIWindow *)window {
	[super willMoveToWindow:window];
	[window addGestureRecognizer:self.tapOutsideGestureRecognizer];
}

- (void)buttonTapped:(id)sender {

	self.confirmationButton.alpha = 0.0f;
	self.confirmationButton.frame = self.button.frame;
	[self addSubview:self.confirmationButton];

	CGRect confirmationFrame = [self frameForConfirmationButton];

	[UIView animateWithDuration:0.25f animations:^{
		self.button.alpha = 0.0f;
		self.button.frame = confirmationFrame;
		self.confirmationButton.alpha = 1.0f;
		self.confirmationButton.frame = confirmationFrame;
	} completion:^(BOOL finished) {
		[self.button removeFromSuperview];
	}];
}

- (void)setEnabled:(BOOL)enabled {
	[super setEnabled:enabled];
	[self.button setEnabled:enabled];
	[self.confirmationButton setEnabled:enabled];
}

- (void)setLoading:(BOOL)loading {

	if (_loading == loading) return;

	_loading = loading;

	NSString *rotationKey = @"rotation";

	if (loading) {

		CGRect frame = self.loadingImageView.bounds;
		frame.origin.x = self.bounds.size.width - frame.size.width;

		self.loadingImageView.alpha = 0.0f;
		self.loadingImageView.frame = frame;
		[self addSubview:self.loadingImageView];

		CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
		rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
		rotationAnimation.duration = 1.0f;
		rotationAnimation.cumulative = YES;
		rotationAnimation.repeatCount = CGFLOAT_MAX;
		[self.loadingImageView.layer addAnimation:rotationAnimation forKey:rotationKey];

		[UIView animateWithDuration:0.25f animations:^{
			self.confirmationButton.frame = frame;
		}];

		[UIView animateWithDuration:0.1f delay:0.15f options:UIViewAnimationOptionCurveEaseInOut animations:^{

			self.confirmationButton.alpha = 0.0f;
			self.loadingImageView.alpha = 1.0f;

		} completion:^(BOOL finished) {
			[self.confirmationButton removeFromSuperview];
		}];

	} else {

		self.button.alpha = 0.0f;
		self.button.frame = self.loadingImageView.frame;
		[self addSubview:self.button];

		[UIView animateWithDuration:0.25f animations:^{
			self.button.frame = [self frameForButton];
		} completion:^(BOOL finished) {
			[self.loadingImageView.layer removeAnimationForKey:rotationKey];
			[self.loadingImageView removeFromSuperview];
		}];

		[UIView animateWithDuration:0.1f animations:^{
			self.button.alpha = 1.0f;
			self.loadingImageView.alpha = 0.0f;

		}];
	}
}

- (void)tappedOutside:(id)sender {

	if (!self.confirmationButton.superview) return;

	self.button.alpha = 0.0f;
	self.button.frame = self.confirmationButton.frame;
	[self addSubview:self.button];

	CGRect buttonFrame = [self frameForButton];

	[UIView animateWithDuration:0.25f animations:^{
		self.button.alpha = 1.0f;
		self.button.frame = buttonFrame;
		self.confirmationButton.alpha = 0.0f;
		self.confirmationButton.frame = buttonFrame;
	} completion:^(BOOL finished) {
		[self.confirmationButton removeFromSuperview];
	}];

}

- (UIGestureRecognizer *)tapOutsideGestureRecognizer {

	if (!_tapOutsideGestureRecognizer) _tapOutsideGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOutside:)];

	return _tapOutsideGestureRecognizer;
}

- (UIImageView *)loadingImageView {

	if (!_loadingImageView) {
		UIImage *image = [[UIImage imageNamed:@"DCTStoreButtonLoading"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		_loadingImageView = [[UIImageView alloc] initWithImage:image];
	}

	return _loadingImageView;
}

#pragma mark - Button setters/getters

- (UIButton *)button {

	if (!_button) {
		_button = [[UIButton alloc] initWithFrame:self.bounds];
		[_button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];

		UIImage *image = [[UIImage imageNamed:@"DCTStoreButtonBackground"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIImage *selectedImage = [[UIImage imageNamed:@"DCTStoreButtonBackgroundSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		[_button setBackgroundImage:image forState:UIControlStateNormal];
		[_button setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
		[_button setBackgroundImage:selectedImage forState:UIControlStateSelected];
	}

	return _button;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
	[self.button setTitle:title forState:state];
}

- (NSString *)titleForState:(UIControlState)state {
	return [self.button titleForState:state];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
	[self.button setTitleColor:color forState:state];
}

- (UIColor *)titleColorForState:(UIControlState)state {
	return [self.button titleColorForState:state];
}

- (void)setTintColor:(UIColor *)tintColor {
	self.button.tintColor = tintColor;
	self.loadingImageView.tintColor = tintColor;
}

- (UIColor *)tintColor {
	return self.button.tintColor;
}

#pragma mark - Confirmation button setters/getters

- (UIButton *)confirmationButton {

	if (!_confirmationButton) {
		_confirmationButton = [[UIButton alloc] initWithFrame:self.bounds];

		UIImage *image = [[UIImage imageNamed:@"DCTStoreButtonBackground"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIImage *selectedImage = [[UIImage imageNamed:@"DCTStoreButtonBackgroundSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		[_confirmationButton setBackgroundImage:image forState:UIControlStateNormal];
		[_confirmationButton setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
		[_confirmationButton setBackgroundImage:selectedImage forState:UIControlStateSelected];
	}

	return _confirmationButton;
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
