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

	NSString *rotation = @"rotation";
	[self.layer removeAnimationForKey:rotation];


	if (newSuperview) {
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
		animation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
		animation.duration = 1.0f;
		animation.cumulative = YES;
		animation.repeatCount = CGFLOAT_MAX;
		[self.layer addAnimation:animation forKey:rotation];
	}
}

- (CGSize)intrinsicContentSize {
	return self.image.size;
}

@end
