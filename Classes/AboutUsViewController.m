    //
//  AboutUsViewController.m
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/26/11.
//  Copyright 2011 SGUC. All rights reserved.
//

#import "AboutUsViewController.h"
#import "TwoWaysViewController.h"
#import "WhoWeAreViewController.h"
#import "BeliefsViewController.h"

@implementation AboutUsViewController

@synthesize tabbar, aboutUsButton, beliefButton, jesusButton, contactButton;

- (void)dealloc {
	[tabbar release];
	[aboutUsButton release];
	[beliefButton release];
	[jesusButton release];
	[contactButton release];
    [super dealloc];
}

//custom method for handling view rotation
- (void)rotateViewWithOrientation:(UIInterfaceOrientation) currentOrientation{
	if (currentOrientation == UIInterfaceOrientationLandscapeLeft ||
		currentOrientation == UIInterfaceOrientationLandscapeRight)
	{
		self.aboutUsButton.frame = CGRectMake(20, 137, 210, 37);
		self.beliefButton.frame = CGRectMake(250, 137, 210, 37);
		self.jesusButton.frame = CGRectMake(20, 182, 210, 37);
		self.contactButton.frame = CGRectMake(250, 182, 210, 37);
	}
	else
	{
		self.aboutUsButton.frame = CGRectMake(20, 155, 280, 37);
		self.beliefButton.frame = CGRectMake(20, 205, 280, 37);
		self.jesusButton.frame = CGRectMake(20, 255, 280, 37);
		self.contactButton.frame = CGRectMake(20, 305, 280, 37);	
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//http://blog.costan.us/2009/01/auto-rotating-tab-bars-on-iphone.html
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self rotateViewWithOrientation:[[UIDevice currentDevice] orientation]];
}

- (IBAction) openContactView {
	UIActionSheet *contactActionSheet = [[UIActionSheet alloc] initWithTitle:@"Contact Us" 
																	delegate:self 
														   cancelButtonTitle:@"Cancel" 
													  destructiveButtonTitle:nil 
														   otherButtonTitles:@"Call Us", @"Email Us", @"Directions", @"Visit Website", nil];
	contactActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[contactActionSheet showFromTabBar:self.tabbar];
	[contactActionSheet release];
}

- (IBAction) openWhoWeAreView{
	WhoWeAreViewController *whoWeAreViewController = [[WhoWeAreViewController alloc] initWithNibName:@"WhoWeAreView" bundle:[NSBundle mainBundle]];
	whoWeAreViewController.delegate = self;
	[self presentModalViewController:whoWeAreViewController animated:YES];
	[whoWeAreViewController release];
}

- (IBAction) openBeliefsView{
	BeliefsViewController *beliefsViewController = [[BeliefsViewController alloc] initWithNibName:@"BeliefsView" bundle:[NSBundle mainBundle]];
	beliefsViewController.delegate = self;
	[self presentModalViewController:beliefsViewController animated:YES];
	[beliefsViewController release];
}

- (IBAction) openTwoWaysView{
	TwoWaysViewController *twoWaysViewController = [[TwoWaysViewController alloc] initWithNibName:@"TwoWaysView" bundle:[NSBundle mainBundle]];
	twoWaysViewController.delegate = self;
	[self presentModalViewController:twoWaysViewController animated:YES];
	[twoWaysViewController release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSString *buttonText = [[NSString alloc] initWithFormat:@"%@", [actionSheet buttonTitleAtIndex:buttonIndex]];
	if ([buttonText isEqualToString:@"Visit Website"]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.sgucandcs.org"]];
	}
	if ([buttonText isEqualToString:@"Call Us"]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://626-287-0486"]];
	}
	if ([buttonText isEqualToString:@"Directions"]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://maps.google.com/maps?q=117+N.+Pine+St.+San+Gabriel,+Ca+91775"]];
	}
	if ([buttonText isEqualToString:@"Email Us"]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:ghoover@sgucandcs.org"]];
	}
	[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
	[buttonText release];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self rotateViewWithOrientation:toInterfaceOrientation];
}
	

#pragma mark -
#pragma mark Respond to ModalViewControllerDelegate
-(void) modalViewReadyToDismiss {
	[self dismissModalViewControllerAnimated:YES];
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
