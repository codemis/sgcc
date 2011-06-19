//
//  TwoWaysViewController.m
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/28/11.
//  Copyright 2011 SGUC. All rights reserved.
//

#import "TwoWaysViewController.h"

@interface TwoWaysViewController ()
-(void) updatePage;
@end


@implementation TwoWaysViewController

@synthesize webView, navBar, delegate;

- (void)dealloc {
	[delegate release];
	[webView release];
	[navBar release];
    [super dealloc];
}

- (void) updatePage {
	self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.matthiasmedia.com.au/2wtl/2wtlonline.html"]]];
	
}

-(void) refresh {
	[self.webView reload];
}

- (void) dismissTwoWays {
	if ([self.delegate 
         respondsToSelector:@selector(modalViewReadyToDismiss)] ) {
        [self.delegate modalViewReadyToDismiss];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.webView.delegate = self;
	self.webView.scalesPageToFit = YES;
	// Refresh button
	self.navBar.topItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																							target:self 
																							action:@selector(refresh)] autorelease];
	
	self.navBar.topItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
																						   target:self 
																						   action:@selector(dismissTwoWays)] autorelease];
	
	[self updatePage];
	
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

#pragma mark -
#pragma mark Handle Web View Delegate
-(void)webViewDidStartLoad:(UIWebView *)wView{
	self.navBar.topItem.title = @"Loading...";
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Unable to Handle Request"
													message: @"Please check your internet connection."
												   delegate: self
										  cancelButtonTitle: @"OK"
										  otherButtonTitles: nil];
    [alert show];
    [alert release];
	
	self.navBar.topItem.title = @"Two Ways To Live";
	[UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	self.navBar.topItem.title = @"Two Ways To Live";
	[UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
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
