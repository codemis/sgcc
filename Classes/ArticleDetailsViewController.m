    //
//  ArticleDetailsViewController.m
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/21/11.
//  Copyright 2011 SGUC. All rights reserved.
//

#import "ArticleDetailsViewController.h"

@implementation ArticleDetailsViewController
@synthesize item, myWebView;

- (void)dealloc {
	[item release];
	[myWebView release];
    [super dealloc];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//http://blog.costan.us/2009/01/auto-rotating-tab-bars-on-iphone.html
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	self.title = [dateFormatter stringFromDate:self.item.publishedOn];
	[dateFormatter release];
	NSString *html = [NSString stringWithFormat:@"<h2 style='text-align: center;padding:5px 0px 10px;'>%@</h2><div style='text-align: left;font-size: 16px;'>%@</div><div style='font-size: 9px; padding-top: 15px;'></div>", self.item.title, self.item.content]; 
	[self.myWebView loadHTMLString:html baseURL:[NSURL URLWithString:@"http://www.sgucandcs.org"]];
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
