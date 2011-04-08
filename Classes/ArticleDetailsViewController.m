    //
//  ArticleDetailsViewController.m
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/21/11.
//  Copyright 2011 SGUC. All rights reserved.
//

#import "ArticleDetailsViewController.h"
#import "NSString+HTML.h"
typedef enum { SectionHeader, SectionDetail } Sections;
typedef enum { SectionHeaderTitle, SectionHeaderDate, SectionHeaderURL } HeaderRows;
typedef enum { SectionDetailSummary } DetailRows;

@implementation ArticleDetailsViewController
@synthesize item, dateString, summaryString, contentString;

- (void)dealloc {
	[item release];
	[dateString release];
	[summaryString release];
	[contentString release];
    [super dealloc];
}

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:style])) {
		
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	// Date
	if (item.date) {
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		[formatter setTimeStyle:NSDateFormatterMediumStyle];
		self.dateString = [formatter stringFromDate:self.item.publishedOn];
		[formatter release];
	}
	
	// Summary
	if (item.summary) {
		self.summaryString = [self.item.summary stringByConvertingHTMLToPlainText];
	} else {
		self.summaryString = @"[No Summary]";
	}
	
	// Summary
	if (item.content) {
		self.contentString = [self.item.content stringByConvertingHTMLToPlainText];
	} else {
		self.contentString = @"";
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
	switch (section) {
		case 0: return 3;
		default: return 1;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    // Get cell
	static NSString *CellIdentifier = @"CellA";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	// Display
	cell.textLabel.textColor = [UIColor blackColor];
	cell.textLabel.font = [UIFont systemFontOfSize:15];
	if (item) {
		
		// Item Info
		NSString *itemTitle = self.item.title ? [self.item.title stringByConvertingHTMLToPlainText] : @"[No Title]";
		
		// Display
		switch (indexPath.section) {
			case SectionHeader: {
				
				// Header
				switch (indexPath.row) {
					case SectionHeaderTitle:
						cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
						cell.textLabel.text = itemTitle;
						break;
					case SectionHeaderDate:
						cell.textLabel.text = self.dateString ? self.dateString : @"[No Date]";
						break;
					case SectionHeaderURL:
						cell.textLabel.text = self.item.link ? self.item.link : @"[No Link]";
						cell.textLabel.textColor = [UIColor blueColor];
						cell.selectionStyle = UITableViewCellSelectionStyleBlue;
						break;
				}
				break;
				
			}
			case SectionDetail: {
				
				// content
				cell.textLabel.text = self.contentString;
				cell.textLabel.numberOfLines = 0; // Multiline
				break;
				
			}
		}
	}
    
    return cell;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == SectionHeader) {
		
		// Regular
		return 34;
		
	} else {
		
		// Get height of content
		NSString *content = @"";
		if (contentString) content = self.contentString;
		CGSize s = [content sizeWithFont:[UIFont systemFontOfSize:15] 
					   constrainedToSize:CGSizeMake(self.view.bounds.size.width - 40, MAXFLOAT)  // - 40 For cell padding
						   lineBreakMode:UILineBreakModeWordWrap];
		return s.height + 16; // Add padding
		
	}
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// Open URL
	if (indexPath.section == SectionHeader && indexPath.row == SectionHeaderURL) {
		if (item.link) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:item.link]];
		}
	}
	
	// Deselect
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
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
