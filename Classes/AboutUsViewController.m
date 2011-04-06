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

@synthesize tabbar;

- (void)dealloc {
	[tabbar release];
    [super dealloc];
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
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://526-287-0486"]];
	}
	if ([buttonText isEqualToString:@"Directions"]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://maps.google.com/maps?q=117+N.+Pine+St.+San+Gabriel,+Ca+91775"]];
	}
	if ([buttonText isEqualToString:@"Email Us"]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:ghoover@sgucandcs.org"]];
	}
	[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
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
