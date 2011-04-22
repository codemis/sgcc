//
//  EventsWebViewController.m
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/22/11.
//  Copyright 2011 SGUC. All rights reserved.
//

#import "EventsWebViewController.h"
@interface EventsWebViewController ()
-(void) updatePage;
@end

@implementation EventsWebViewController
@synthesize webView, activityIndicator, navBar;


- (void)dealloc {
	[navBar release];
	[webView release];
	[activityIndicator release];
    [super dealloc];
}

- (void) updatePage {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.sgucandcs.org/calendar.php?pageID=39"]]];
	
}

-(void) refresh {
	[self.webView reload];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//http://blog.costan.us/2009/01/auto-rotating-tab-bars-on-iphone.html
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	self.webView.delegate = self;
	// Refresh button
	self.navBar.topItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																							target:self 
																							action:@selector(refresh)] autorelease];
	self.navBar.topItem.title = @"Loading...";
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];  
    indicator.hidesWhenStopped = YES;  
    self.activityIndicator = indicator;  
    [indicator release];
	
	[self updatePage];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}

#pragma mark -
#pragma mark Handle Web View Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	self.navBar.topItem.title = @"SGUC Events";
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
