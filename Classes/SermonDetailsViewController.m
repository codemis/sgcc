//
//  SermonDetailsViewController.m
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/23/11.
//  Copyright 2011 SGUC. All rights reserved.
//

#import "SermonDetailsViewController.h"

typedef enum { SectionHeader, SectionDetail } Sections;
typedef enum { SectionHeaderTitle, SectionHeaderAuthor, SectionHeaderSummary } HeaderRows;
typedef enum { SectionDetailAction } DetailRows;

@implementation SermonDetailsViewController

@synthesize sermon;
@synthesize authorString;
@synthesize summaryString;
@synthesize titleString;
@synthesize sermonLink;
@synthesize playerView;


- (void)dealloc {
	[sermon release];
	[authorString release];
	[summaryString release];
	[titleString release];
	[sermonLink release];
	[playerView release];
    [super dealloc];
}

- (void) playSermon{
	if (self.sermonLink) {
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: self.sermonLink] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 15.0];  
		[self.playerView loadRequest: request];  
		[request release]; 
	}else { 
		UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading sermon" message:@"Unable to find the sermon file." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];  
		[errorAlert show];
		[errorAlert release];
	}

}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	cell.textLabel.textColor = [UIColor blackColor];
	cell.textLabel.font = [UIFont systemFontOfSize:15];
	// Display
	switch (indexPath.section) {
		case SectionHeader: {
				
			// Header
			switch (indexPath.row) {
				case SectionHeaderTitle:
					cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
					cell.textLabel.text = self.titleString;
					break;
				case SectionHeaderAuthor:
					cell.textLabel.text = self.authorString;
					break;
				case SectionHeaderSummary:
					cell.textLabel.text = self.summaryString;
					break;
			}
			break;
				
		}
		case SectionDetail: {
				
			// content
			cell.textLabel.text = @"Play Sermon";
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			cell.textLabel.numberOfLines = 0; // Multiline
			break;
				
		}
	}
	
}

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:style])) {
		
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	UIWebView *webView = [[UIWebView alloc] initWithFrame: CGRectMake(0.0, 0.0, 1.0, 1.0)];  
	webView.delegate = self;  
	self.playerView = webView;  
	[webView release]; 
	
    [super viewDidLoad];
	if ([self.sermon objectForKey:@"author"]) {
		NSString *author = [[NSString alloc] initWithString:[self.sermon objectForKey:@"author"]];
		self.authorString = author;
		[author release];
	}else {
		self.authorString = @"[No Author]";
	}
	if ([self.sermon objectForKey:@"summary"]) {
		NSString *summary = [[NSString alloc] initWithString:[self.sermon objectForKey:@"summary"]];
		self.summaryString = summary;
		[summary release];
	}else {
		self.summaryString = @"[No Summary]";
	}
	if ([self.sermon objectForKey:@"title"]) {
		NSString *sermonTitle = [[NSString alloc] initWithString:[self.sermon objectForKey:@"title"]];
		self.titleString = sermonTitle;
		self.title = sermonTitle;
		[sermonTitle release];
	}else {
		self.titleString = @"[No Title]";
	}
	if ([self.sermon objectForKey:@"link"]) {
		NSString *linkUrl = [[NSString alloc] initWithString:[self.sermon objectForKey:@"link"]];
		self.sermonLink = linkUrl;
		[linkUrl release];
	}else {
		self.sermonLink = @"";
	}

}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // Return the number of rows in the section.
	switch (section) {
		case 0: return 3;
		default: return 1;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellA";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == SectionDetail) {
		[self playSermon];
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

@end

