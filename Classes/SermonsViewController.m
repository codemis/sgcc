//
//  SermonsViewController.m
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/23/11.
//  Copyright 2011 SGUC. All rights reserved.
//

#import "SermonsViewController.h"
#import "SermonDetailsViewController.h"
@interface SermonsViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
-(void) initializeRssFeed;
@end

@implementation SermonsViewController

@synthesize responseData;
@synthesize itemsToDisplay;
@synthesize item;
@synthesize currentTitle;
@synthesize currentDate;
@synthesize currentAuthor;
@synthesize currentLink;
@synthesize currentSummary;
@synthesize currentElement;
@synthesize activityIndicator;
@synthesize myFeedParser;


- (void)dealloc {
    [itemsToDisplay release];
	[item release];
	[currentTitle release];
	[currentDate release];
	[currentAuthor release];
	[currentLink release];
    [responseData release];
	[currentSummary release];
	[currentElement release];
	[activityIndicator release];
	[myFeedParser release];
    [super dealloc];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *feedItem = [self.itemsToDisplay objectAtIndex:indexPath.row];
	if (feedItem) {
		// Process
		NSString *itemTitle = [feedItem objectForKey:@"title"];
		NSString *itemAuthor = [feedItem objectForKey:@"author"];
		
		// Set
		NSMutableString *subtitle = [NSMutableString string];
		[subtitle appendFormat:@"%@ ", itemTitle];
		NSMutableString *detailTitle = [NSMutableString string];
		[detailTitle appendFormat:@"%@ ", itemAuthor];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
		cell.textLabel.text = subtitle;
		cell.detailTextLabel.text = detailTitle;
	}
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;  
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Loading...";
	// Refresh button
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																							target:self 
																							action:@selector(refresh)] autorelease];

	//Inidicator
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];  
    indicator.hidesWhenStopped = YES;  
    [indicator stopAnimating];  
    self.activityIndicator = indicator;  
    [indicator release];
	
	self.responseData = [[NSMutableData data] retain];  
	[self initializeRssFeed];
	self.tableView.userInteractionEnabled = NO;
	self.tableView.alpha = 0.3;  
	
}

// Reset and reparse
- (void)refresh {
	self.title = @"Refreshing...";
	//Indicator
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];  
    indicator.hidesWhenStopped = YES;  
    [indicator stopAnimating];  
    self.activityIndicator = indicator;  
    [indicator release];
	
	[self.responseData release];
	self.responseData = [[NSMutableData data] retain];  
	self.tableView.userInteractionEnabled = NO;
	self.tableView.alpha = 0.3;  
	[self initializeRssFeed];
}

-(void) initializeRssFeed{
	NSURL *baseURL = [NSURL URLWithString:@"http://sgucandcs.org/podcast.php?pageID=38"];  
    NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];  
    [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease]; 
}

#pragma mark -
#pragma mark XML Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {  
	[self.responseData setLength:0];  
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {  
    [self.responseData appendData:data];  
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {  
    NSString * errorString = [NSString stringWithFormat:@"Unable to download xml data (Error code %i )", [error code]];  
	
    UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];  
    [errorAlert show];
	[errorAlert release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection  { 
    self.itemsToDisplay = [[NSMutableArray alloc] init];  
	
    self.myFeedParser = [[NSXMLParser alloc] initWithData:self.responseData];  
	
	[responseData release];
	
    [myFeedParser setDelegate:self];  
	
    [myFeedParser parse];
} 

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{  
    self.currentElement = [[elementName copy] autorelease];  

    if ([elementName isEqualToString:@"item"]) {  
        self.item = [[NSMutableDictionary alloc] init];  
        self.currentTitle = [[NSMutableString alloc] init];  
        self.currentAuthor = [[NSMutableString alloc] init]; 
		self.currentSummary = [[NSMutableString alloc] init];
    }  
	
    // podcast url is an attribute of the element enclosure  
    if ([currentElement isEqualToString:@"enclosure"]) { 
		self.currentLink = [[NSMutableString alloc] init];
		[self.currentLink appendString:[attributeDict objectForKey:@"url"]];
    } 

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{  
    if ([currentElement isEqualToString:@"title"]) {  
        [self.currentTitle appendString:string];  
    } else if ([currentElement isEqualToString:@"itunes:author"]) {  
        [self.currentAuthor appendString:string];  
    } else if ([currentElement isEqualToString:@"itunes:summary"]) {  
        [self.currentSummary appendString:string];  
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	if ([elementName isEqualToString:@"item"]) { 
        [self.item setObject:self.currentTitle forKey:@"title"];
		[currentTitle release];
        [self.item setObject:self.currentAuthor forKey:@"author"];
		[currentAuthor release];
		[self.item setObject:self.currentSummary forKey:@"summary"];
		[currentSummary release]; 
		[self.item setObject:self.currentLink forKey:@"link"]; 
		[currentLink release];
		NSMutableDictionary *itemCopy = [self.item copy];
		[item release];
        [self.itemsToDisplay addObject:itemCopy];
		[itemCopy release];
    }  
}  

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	self.title = @"SGUC Sermons";
	self.tableView.userInteractionEnabled = YES;
	self.tableView.alpha = 1;
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.itemsToDisplay count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SermonDetailsViewController *sermonDetailsVC = [[SermonDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped];
	sermonDetailsVC.sermon = [self.itemsToDisplay objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:sermonDetailsVC animated:YES];
	[sermonDetailsVC release];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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

