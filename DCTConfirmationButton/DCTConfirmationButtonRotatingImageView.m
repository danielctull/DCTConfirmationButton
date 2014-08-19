//
//  DCTConfirmationButtonRotatingImageView.m
//  DCTConfirmationButton
//
//  Created by Daniel Tull on 19/08/2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "DCTConfirmationButtonRotatingImageView.h"

@implementation DCTConfirmationButtonRotatingImageView

- (instancetype)init {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	UIImage *image = [UIImage imageNamed:@"DCTConfirmationButtonLoading" inBundle:bundle compatibleWithTraitCollection:nil];
	return [super initWithImage:image];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];

	NSString *rotation = @"rotation";
	[self.layer removeAnimationForKey:rotation];


	if (!newSuperview) {
		return;
	}
	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	animation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
	animation.duration = 1.0f;
	animation.cumulative = YES;
	animation.repeatCount = CGFLOAT_MAX;
	[self.layer addAnimation:animation forKey:rotation];

	CGSize size = [self intrinsicContentSize];
	CGRect frame = CGRectZero;
	frame.size = size;

	switch (self.contentMode) {

		case UIViewContentModeBottomLeft:
		case UIViewContentModeTopLeft:
		case UIViewContentModeLeft:
			frame.origin.x = 0.0f;
			break;

		case UIViewContentModeTopRight:
		case UIViewContentModeBottomRight:
		case UIViewContentModeRight:
			frame.origin.x = CGRectGetWidth(newSuperview.bounds) - size.width;
			break;

		case UIViewContentModeTop:
		case UIViewContentModeBottom:
		case UIViewContentModeScaleAspectFill:
		case UIViewContentModeScaleAspectFit:
		case UIViewContentModeCenter:
			frame.origin.x = (CGRectGetWidth(newSuperview.bounds) - size.width) / 2.0f;
			break;

		case UIViewContentModeRedraw:
		case UIViewContentModeScaleToFill:
			frame = newSuperview.bounds;
	}
	self.frame = frame;
}

- (CGSize)intrinsicContentSize {
	return self.image.size;
}

- (void)setContentMode:(UIViewContentMode)contentMode {
	[super setContentMode:contentMode];

	UIViewAutoresizing sizing = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	switch (contentMode) {

		case UIViewContentModeBottomLeft:
		case UIViewContentModeTopLeft:
		case UIViewContentModeLeft:
			sizing |= UIViewAutoresizingFlexibleRightMargin;
			break;

		case UIViewContentModeTopRight:
		case UIViewContentModeBottomRight:
		case UIViewContentModeRight:
			sizing |= UIViewAutoresizingFlexibleLeftMargin;
			break;

		case UIViewContentModeTop:
		case UIViewContentModeBottom:
		case UIViewContentModeScaleAspectFill:
		case UIViewContentModeScaleAspectFit:
		case UIViewContentModeCenter:
			sizing |= UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
			break;

		case UIViewContentModeRedraw:
		case UIViewContentModeScaleToFill:
			sizing = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	}

	self.autoresizingMask = sizing;
}

@end
