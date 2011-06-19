//
//  SermonsViewController.m
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/23/11.
//  Copyright 2011 SGUC. All rights reserved.
//

#import "SermonsViewController.h"
#import "SermonDetailsViewController.h"
#import "Feed.h"
#import "NSString+HTML.h"

@interface SermonsViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)insertNewObject:(NSMutableDictionary *) itemToSave;
- (void) initializeRssFeed;
- (void) updateTextForPullToUpdate;
- (void) prepareForUpdatingView;
- (void) updatePodcastLastUpdated;
- (Boolean) recordExists:(NSString *) podcastGUID;
- (void) displayError:(NSString *)messageText withTitle:(NSString *)titleText;

@end

@implementation SermonsViewController

@synthesize responseData;
@synthesize item;
@synthesize currentTitle;
@synthesize currentAuthor;
@synthesize currentLink;
@synthesize currentSummary;
@synthesize currentElement;
@synthesize activityIndicator;
@synthesize myFeedParser;
@synthesize fetchedResultsController=fetchedResultsController_;
@synthesize managedObjectContext=managedObjectContext_;
@synthesize podcastLastUpdated;
@synthesize currentDateString;
@synthesize currentPodcastGUID;

- (void)dealloc {
	[item release];
	[currentTitle release];
	[currentDateString release];
	[currentAuthor release];
	[currentLink release];
    [responseData release];
	[currentSummary release];
	[currentElement release];
	[activityIndicator release];
	[myFeedParser release];
    [fetchedResultsController_ release];
    [managedObjectContext_ release];
	[podcastLastUpdated release];
	[currentPodcastGUID release];
    [super dealloc];
}

#pragma mark -
#pragma mark Lazy Loaders
- (NSDate *) podcastLastUpdated{
	if (podcastLastUpdated == nil)
    {
        self.podcastLastUpdated = [[NSUserDefaults standardUserDefaults] objectForKey:@"SermonLastUpdated"];
    }
    return podcastLastUpdated;	
}

#pragma mark -
#pragma mark Custom Methods

//Display an error
- (void) displayError:(NSString *)messageText withTitle:(NSString*)titleText {
	self.title = @"Sermons";
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: titleText
													message: messageText
												   delegate: self
										  cancelButtonTitle: @"OK"
										  otherButtonTitles: nil];
    [alert show];
    [alert release];
	
	self.tableView.userInteractionEnabled = YES;
	self.tableView.alpha = 1;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	Feed *feed = (Feed *)[self.fetchedResultsController objectAtIndexPath:indexPath];
	
	if (feed) {
		
		// Set
		NSMutableString *subtitle = [NSMutableString string];
		[subtitle appendFormat:@"%@ ", feed.title];
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		NSString *detailTitle = [NSString stringWithFormat:@"%@: %@", [dateFormatter stringFromDate:feed.publishedOn], feed.summary];
		[dateFormatter release];
		
		cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
		cell.textLabel.text = subtitle;
		cell.detailTextLabel.text = detailTitle;
	}
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;  
}

-(void) prepareForUpdatingView {
	self.title = @"Loading...";
	
	//Inidicator
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];  
	indicator.hidesWhenStopped = YES;  
	[indicator stopAnimating];  
	self.activityIndicator = indicator;  
	[indicator release];	
	
	self.tableView.userInteractionEnabled = NO;
	self.tableView.alpha = 0.3;
}

// Update the podcastLastUpdated
-(void) updatePodcastLastUpdated{
	NSDate *myDate = [NSDate date];
	[[NSUserDefaults standardUserDefaults] setObject:myDate forKey:@"SermonLastUpdated"];
	self.podcastLastUpdated = myDate;
}

#pragma mark -
#pragma mark Respond to PullRefreshTableViewController
-(void) refresh{
	self.responseData = [[NSMutableData data] retain]; 
	[self prepareForUpdatingView];
	[self initializeRssFeed];	
	[self stopLoading];
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	//http://blog.costan.us/2009/01/auto-rotating-tab-bars-on-iphone.html
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	[self updateTextForPullToUpdate];
	
	if (self.podcastLastUpdated == nil) {		
		self.responseData = [[NSMutableData data] retain];  
		[self prepareForUpdatingView];
		[self initializeRssFeed];		
	}else {
		self.title = @"Sermons";
	}
}

-(void) updateTextForPullToUpdate{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM d @ h:mm a"];
	self.textPull = [NSString stringWithFormat:@"Pull to Update. Updated: %@", [dateFormatter stringFromDate:self.podcastLastUpdated]];
	self.textLoading = @"Updating...";
	self.textRelease = @"Release to update!";
	
	[dateFormatter release];	
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
	[self displayError:@"We were unable to handle your request.  Please check your internet connection, and try again." 
			 withTitle:@"Unable to Handle Request"];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection  {  

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
		self.currentDateString = [[NSMutableString alloc] init];
		self.currentPodcastGUID = [[NSMutableString alloc] init];
    }  
	
    // podcast url is an attribute of the element enclosure  
    if ([currentElement isEqualToString:@"enclosure"]) { 
		self.currentLink = [[NSMutableString alloc] init];
		[self.currentLink appendString:[[attributeDict objectForKey:@"url"] stringByRemovingNewLinesAndWhitespace]];
    } 

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{ 
	NSMutableString *content = [NSMutableString stringWithString:string];
    if ([currentElement isEqualToString:@"title"]) {  
		[self.currentTitle appendString:[content stringByRemovingNewLinesAndWhitespace]];
    } else if ([currentElement isEqualToString:@"itunes:author"]) {   
		[self.currentAuthor appendString:[content stringByRemovingNewLinesAndWhitespace]];
    } else if ([currentElement isEqualToString:@"itunes:summary"]) {   
		[self.currentSummary appendString:[content stringByRemovingNewLinesAndWhitespace]];
    } else if ([currentElement isEqualToString:@"pubDate"]) {  
		[self.currentDateString appendString:[content stringByRemovingNewLinesAndWhitespace]];
    } else if ([currentElement isEqualToString:@"guid"]) {  
		[self.currentPodcastGUID appendString:[[content stringByRemovingNewLinesAndWhitespace] stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	if ([elementName isEqualToString:@"item"]) {
		// If never updated, or if updated then only save new stuff
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"EEE, d MMM yyyy HH:mm:ss Z"];
		
		NSDate *currentDate = [dateFormat dateFromString:self.currentDateString];
		[currentDateString release];
		BOOL recordExists = [self recordExists:self.currentPodcastGUID];
		if (!recordExists) {
			[self.item setObject:self.currentTitle forKey:@"title"];
			[self.item setObject:self.currentAuthor forKey:@"author"];
			[self.item setObject:self.currentSummary forKey:@"summary"]; 
			[self.item setObject:self.currentLink forKey:@"feedLink"];
			[self.item setObject:self.currentPodcastGUID forKey:@"podcastGUID"];
			[self.item setObject:currentDate forKey:@"publishedOn"];
			[self.item setObject:@"podcast" forKey:@"feedType"]; 
			[self.item setObject:@"" forKey:@"content"];
			[self insertNewObject:self.item];
		}
		
		[dateFormat release];
		[currentTitle release];
		[currentAuthor release];
		[currentSummary release];
		[currentLink release];
		[currentPodcastGUID release];
		[item release];		
    }  
}  

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	//Set it to today
	[self updatePodcastLastUpdated];
	[self updateTextForPullToUpdate];
	self.tableView.userInteractionEnabled = YES;
	self.tableView.alpha = 1;
	[self.tableView reloadData];
	self.title = @"Sermons";
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	[self displayError:@"We were unable to handle your request.  Please check your internet connection, and try again." 
			 withTitle:@"Unable to Handle Request"];
}

#pragma mark -
#pragma mark Add a new object
- (void)insertNewObject:(NSMutableDictionary *) itemToSave {
    // Create a new instance of the entity managed by the fetched results controller.
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    Feed *feed = (Feed *)[NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
	
	feed.title = [itemToSave objectForKey:@"title"];
	feed.feedType = [itemToSave objectForKey:@"feedType"];
	feed.feedLink = [itemToSave objectForKey:@"feedLink"];
	feed.summary = [itemToSave objectForKey:@"summary"];
	feed.author = [itemToSave objectForKey:@"author"];
	feed.publishedOn = [itemToSave objectForKey:@"publishedOn"];
	feed.content = [itemToSave objectForKey:@"content"];
	feed.podcastGUID = [itemToSave objectForKey:@"podcastGUID"];
	
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
		[self displayError:@"We were unable to handle your request." 
				 withTitle:@"Unable to Handle Request"];
    }
}

#pragma mark -
#pragma mark Fetched results controller
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController_ != nil) {
        return fetchedResultsController_;
    }
    
    /*
     Set up the fetched results controller.
	 */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Feed" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:0];
	
	//Limit to only Podcast results
	NSString *attributeName = @"feedType";
	NSString *attributeValue = @"podcast";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like %@",
							  attributeName, attributeValue];
	[fetchRequest setPredicate:predicate];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"publishedOn" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Podcast"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![fetchedResultsController_ performFetch:&error]) {
		[self displayError:@"We were unable to handle your request." 
				 withTitle:@"Unable to Handle Request"];    }
    
    return fetchedResultsController_;
}    

- (Boolean) recordExists:(NSString *)podcastGUID{
	
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Feed" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:1];
	
	NSString *attributeName = @"podcastGUID";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@",
							  attributeName, podcastGUID];
	[fetchRequest setPredicate:predicate];
    
	// Save the context.
    NSError *error = nil;
	
    NSUInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
	
	[fetchRequest release]; 
	if (count == 0){
		return NO;
	} else {
		return YES;
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
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
	Feed *feed = (Feed *)[self.fetchedResultsController objectAtIndexPath:indexPath];
	
	sermonDetailsVC.sermon = feed;
	[self.navigationController pushViewController:sermonDetailsVC animated:YES];
	[sermonDetailsVC release];
	
	// Deselect
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Fetched results controller delegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
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

