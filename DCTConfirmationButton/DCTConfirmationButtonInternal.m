//
//  DCTConfirmationButtonInternal.m
//  DCTConfirmationButton
//
//  Created by Daniel Tull on 19/08/2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import "DCTConfirmationButtonInternal.h"

@implementation DCTConfirmationButtonInternal

- (instancetype)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (!self) return nil;
	[self sharedInit];
	return self;

}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (!self) return nil;
	[self sharedInit];
	return self;
}

- (void)sharedInit {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];

	UIImage *image = [UIImage imageNamed:@"DCTConfirmationButtonBackground" inBundle:bundle compatibleWithTraitCollection:nil];
	UIImage *selectedImage = [UIImage imageNamed:@"DCTConfirmationButtonBackgroundSelected" inBundle:bundle compatibleWithTraitCollection:nil];
	[self setBackgroundImage:image forState:UIControlStateNormal];
	[self setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
	[self setBackgroundImage:selectedImage forState:UIControlStateSelected];
	self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
	self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	self.frame = newSuperview.bounds;
}

- (void)setHidden:(BOOL)hidden {
	[super setHidden:hidden];
	[self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize {

	if (self.hidden) {
		return CGSizeZero;
	}

	NSDictionary *attributes = @{NSFontAttributeName : self.titleLabel.font};
	CGSize paddingSize = [@"..." sizeWithAttributes:attributes];
	CGFloat paddingWidth = floorf(paddingSize.width);
	CGFloat paddingHeight = floorf(paddingSize.height / 2.0f);

	NSString *text = [self titleForState:self.state];
	CGSize textSize = [text sizeWithAttributes:attributes];

	CGSize size;
	size.width = floorf(textSize.width) + paddingWidth;
	size.height = floorf(textSize.height) + paddingHeight;

	if (size.height < 26.0f) {
		size.height = 26.0f;
	}

	return size;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p; title = %@>",
			NSStringFromClass([self class]),
			self,
			[self titleForState:UIControlStateNormal]];
}

@end
