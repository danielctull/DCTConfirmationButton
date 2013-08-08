//
//  DCTStoreButton.m
//  DCTStoreButton
//
//  Created by Daniel Tull on 08.08.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "DCTStoreButton.h"

typedef NS_ENUM(NSInteger, DCTStoreButtonState) {
    DCTStoreButtonInitial,
    DCTStoreButtonConfirm,
	DCTStoreButtonLoading
};

@interface DCTStoreButton ()
@property (nonatomic) DCTStoreButtonState storeState;
@end

@implementation DCTStoreButton

- (void)awakeFromNib {
	[super awakeFromNib];

	self.clipsToBounds = YES;
	self.tintColor = [UIColor orangeColor];

	UIImage *image = [[UIImage imageNamed:@"DCTStoreButtonBackground"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[self setBackgroundImage:image forState:UIControlStateNormal];

	image = [[UIImage imageNamed:@"DCTStoreButtonBackgroundSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[self setBackgroundImage:image forState:UIControlStateHighlighted];
	[self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

	[super touchesEnded:touches withEvent:event];

	if (self.storeState == DCTStoreButtonInitial) {
		self.tintColor = [UIColor colorWithRed:0.141f green:0.667f blue:0.169f alpha:1.0f];
		self.storeState = DCTStoreButtonConfirm;
		[self setTitle:@"Buy" forState:UIControlStateNormal];
		return;
	}

	if (self.storeState == DCTStoreButtonConfirm) {
		self.tintColor = [UIColor orangeColor];
		UIImage *image = [[UIImage imageNamed:@"DCTStoreButtonDownloadProgress"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		self.enabled = NO;
		UIImageView *iv = [[UIImageView alloc] initWithImage:image];
		[self setTitle:@"" forState:UIControlStateDisabled];
		
		CGRect frame = self.frame;
		CGFloat width = iv.bounds.size.width;
		CGFloat x = frame.origin.x + frame.size.width - width;
		frame.origin.x = x;
		frame.size.width = width;

		[UIView animateWithDuration:0.25f animations:^{
			self.frame = frame;
		} completion:^(BOOL finished) {

			[self setBackgroundImage:[UIImage new] forState:UIControlStateDisabled];

			iv.tintColor = self.tintColor;
			[self addSubview:iv];

			CABasicAnimation* rotationAnimation;
			rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
			rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
			rotationAnimation.duration = 1.0f;
			rotationAnimation.cumulative = YES;
			rotationAnimation.repeatCount = CGFLOAT_MAX;

			[iv.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
		}];



		return;
	}
}

@end
