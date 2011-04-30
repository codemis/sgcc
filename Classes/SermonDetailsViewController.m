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
@synthesize avPlayer;


- (void)dealloc {
	[sermon release];
	[avPlayer release];
    [super dealloc];
}

- (void) processSermonPress{
	if (self.sermon.feedLink) {
		if (sermonPlaying == NO) {
			[self.avPlayer play];
			[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
			sermonPlaying = YES;
		}else {
			[self.avPlayer pause];
			sermonPlaying = NO;
		}
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
					cell.textLabel.text = self.sermon.title;
					break;
				case SectionHeaderAuthor:
					cell.textLabel.text = self.sermon.author;
					break;
				case SectionHeaderSummary:
					cell.textLabel.text = self.sermon.summary;
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
	//http://blog.costan.us/2009/01/auto-rotating-tab-bars-on-iphone.html
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	if (self.sermon.feedLink) {
		self.avPlayer = [AVPlayer playerWithURL:[NSURL URLWithString: self.sermon.feedLink]];
	}

	sermonPlaying = NO;
    [super viewDidLoad];

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
		[self processSermonPress];
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		if (sermonPlaying == NO) {
			cell.textLabel.text = @"Play Sermon";
		}else {
			cell.textLabel.text = @"Pause";
		}
	}
	
	// Deselect
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
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

