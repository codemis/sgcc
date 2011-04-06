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

@synthesize webView, activityIndicator, navBar, delegate;

- (void)dealloc {
	[delegate release];
	[activityIndicator release];
	[webView release];
	[navBar release];
    [super dealloc];
}

- (void) updatePage {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.matthiasmedia.com.au/2wtl/"]]];
	
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
	self.navBar.topItem.title = @"Loading...";
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];  
    indicator.hidesWhenStopped = YES;  
    self.activityIndicator = indicator;  
    [indicator release];
	
	[self updatePage];
	
}

#pragma mark -
#pragma mark Respond to ModalViewControllerDelegate
-(void) modalViewReadyToDismiss{
}

#pragma mark Handle Web View Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	self.navBar.topItem.title = @"Two Ways To Live";
	[self.activityIndicator stopAnimating];
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
