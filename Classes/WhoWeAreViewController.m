//
//  WhoWeAreViewController.m
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/30/11.
//  Copyright 2011 SGUC. All rights reserved.
//

#import "WhoWeAreViewController.h"


@implementation WhoWeAreViewController

@synthesize delegate, myTextView, navBar;

- (void)dealloc {
	[delegate release];
	[myTextView release];
	[navBar release];
    [super dealloc];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.navBar.topItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
																						   target:self 
																						   action:@selector(dismissWhoWeAre)] autorelease];
	self.navBar.topItem.title = @"About Us";
	
}

- (void) dismissWhoWeAre {
	if ([self.delegate 
         respondsToSelector:@selector(modalViewReadyToDismiss)] ) {
        [self.delegate modalViewReadyToDismiss];
    }
}

#pragma mark -
#pragma mark Respond to ModalViewControllerDelegate
-(void) modalViewReadyToDismiss{
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
