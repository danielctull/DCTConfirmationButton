//
//  DCTConfirmationButtonInternal.m
//  DCTConfirmationButton
//
//  Created by Daniel Tull on 19/08/2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "DCTConfirmationButtonInternal.h"

@implementation DCTConfirmationButtonInternal

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (!self) return nil;

	NSBundle *bundle = [NSBundle bundleForClass:[self class]];

	UIImage *image = [UIImage imageNamed:@"DCTConfirmationButtonBackground" inBundle:bundle compatibleWithTraitCollection:nil];
	UIImage *selectedImage = [UIImage imageNamed:@"DCTConfirmationButtonBackgroundSelected" inBundle:bundle compatibleWithTraitCollection:nil];
	[self setBackgroundImage:image forState:UIControlStateNormal];
	[self setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
	[self setBackgroundImage:selectedImage forState:UIControlStateSelected];
	self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
	return self;
}

- (CGSize)intrinsicContentSize {
	CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
	
	size.width += 12.0f;
	return size;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p; title = %@>",
			NSStringFromClass([self class]),
			self,
			[self titleForState:UIControlStateNormal]];
}

@end
