//
//  ViewController.m
//  DCTConfirmationButton
//
//  Created by Daniel Tull on 08.08.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

@import DCTConfirmationButton;
#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet DCTConfirmationButton *storeButton;
@property (nonatomic, weak) IBOutlet DCTConfirmationButton *storeButton2;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.storeButton setTitle:@"£4.99" forButtonState:DCTConfirmationButtonStateNormal];
	[self.storeButton setTitle:@"Purchased" forButtonState:DCTConfirmationButtonStateConfirmed];
	[self.storeButton setTitle:@"Buy" forButtonState:DCTConfirmationButtonStateConfirmation];

	[self.storeButton2 setTitle:@"£44.99" forButtonState:DCTConfirmationButtonStateNormal];
	[self.storeButton2 setTitle:@"Bought" forButtonState:DCTConfirmationButtonStateConfirmed];
	[self.storeButton2 setTitle:@"Purchase" forButtonState:DCTConfirmationButtonStateConfirmation];
}

- (IBAction)reset:(id)sender {
	[self.storeButton setButtonState:DCTConfirmationButtonStateNormal];
	[self.storeButton2 setButtonState:DCTConfirmationButtonStateNormal];
}

- (IBAction)action:(id)sender {

	[self.storeButton setButtonState:DCTConfirmationButtonStateLoading animated:YES];

	double delayInSeconds = 2.0;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		[self.storeButton setButtonState:DCTConfirmationButtonStateConfirmed animated:YES];
	});
}

@end
