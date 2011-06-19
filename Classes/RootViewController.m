//
//  RootViewController.m
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/21/11.
//  Copyright 2011 SGUC. All rights reserved.
//

#import "RootViewController.h"
#import "NSString+HTML.h"
#import "MWFeedParser.h"
#import "ArticleDetailsViewController.h"
#import "SermonsViewController.h"
#import "Feed.h"


@interface RootViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
-(void) parseArticles;
- (void)insertNewObject:(NSMutableDictionary *) itemToSave;
-(void) updateTextForPullToUpdate;
-(void) updateArticleLastUpdated;
-(void) prepareForUpdatingView;
@end


@implementation RootViewController

@synthesize fetchedResultsController=fetchedResultsController_, managedObjectContext=managedObjectContext_, activityIndicator, itemsToDisplay, articleLastUpdated;

- (void)dealloc {
	[activityIndicator release];
	[parsedItems release];
	[itemsToDisplay release];
	[feedParser release];
    [fetchedResultsController_ release];
    [managedObjectContext_ release];
	[articleLastUpdated release];
    [super dealloc];
}

#pragma mark -
#pragma mark Lazy Loaders
- (NSDate *) articleLastUpdated{
	if (articleLastUpdated == nil)
    {
        self.articleLastUpdated = [[NSUserDefaults standardUserDefaults] objectForKey:@"ArticleLastUpdated"];
    }
    return articleLastUpdated;	
}

#pragma mark -
#pragma mark Custom Methods

// Update the ArticleLastUpdated
-(void) updateArticleLastUpdated{
	NSDate *myDate = [NSDate date];
	[[NSUserDefaults standardUserDefaults] setObject:myDate forKey:@"ArticleLastUpdated"];
	self.articleLastUpdated = myDate;
}

-(void) prepareForUpdatingView {
	self.title = @"Loading...";
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];  
	indicator.hidesWhenStopped = YES;    
	self.activityIndicator = indicator;  
	[indicator release];
	
	self.tableView.userInteractionEnabled = NO;
	self.tableView.alpha = 0.3;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Feed *feed = (Feed *)[self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
	cell.textLabel.text = feed.title;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	NSString *subtitle = [NSString stringWithFormat:@"%@: %@", [dateFormatter stringFromDate:feed.publishedOn], feed.summary];
	[dateFormatter release];
	cell.detailTextLabel.text = subtitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;  
}

#pragma mark -
#pragma mark Respond to PullRefreshTableViewController
-(void) refresh{
	[self prepareForUpdatingView];
	[self parseArticles];
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
	// Setup
	parsedItems = [[NSMutableArray alloc] init];
	self.itemsToDisplay = [NSArray array];
	
	if (self.articleLastUpdated == nil) {
		[self prepareForUpdatingView];
		[self parseArticles];
	}else {
		self.title = @"Blog";
	}

}

// Implement viewWillAppear: to do additional setup before the view is presented.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -
#pragma mark Parsing

-(void) parseArticles {
	// Parse
	NSURL *feedURL = [NSURL URLWithString:@"http://www.sgucblog.com/feed/"];
	feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
	feedParser.delegate = self;
	feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
	feedParser.connectionType = ConnectionTypeAsynchronously;
	[feedParser parse];
}

-(void) updateTextForPullToUpdate{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM d @ h:mm a"];
	self.textPull = [NSString stringWithFormat:@"Pull to Update. Updated: %@", [dateFormatter stringFromDate:self.articleLastUpdated]];
	self.textLoading = @"Updating...";
	self.textRelease = @"Release to update!";
	
	[dateFormatter release];	
}
#pragma mark -
#pragma mark MWFFeed Parser Delegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	if (item){
		// If never updated, or if updated then only save new stuff
		if (self.articleLastUpdated == nil || (self.articleLastUpdated != nil && [self.articleLastUpdated compare:item.date] == NSOrderedAscending)) {
			NSMutableDictionary *itemToSave = [[NSMutableDictionary alloc] init];
			[parsedItems addObject:item];
			NSString *itemTitle = item.title ? [item.title stringByConvertingHTMLToPlainText] : @"[No Title]";
			NSString *itemSummary = item.summary ? [item.summary stringByConvertingHTMLToPlainText] : @"[No Summary]";
			NSString *itemContent = item.content ? [item.content stringByConvertingHTMLToPlainText] : @"[No Content]";
			NSString *itemLink = item.link ? item.link : @"[No Link]";
			[itemToSave setObject:itemTitle forKey:@"title"];
			[itemToSave setObject:@"article" forKey:@"feedType"];
			[itemToSave setObject:item.date forKey:@"publishedOn"];
			[itemToSave setObject:itemSummary forKey:@"summary"];
			[itemToSave setObject:itemLink forKey:@"feedLink"];
			[itemToSave setObject:itemContent forKey:@"content"];
			
			[self insertNewObject:itemToSave];
			[itemToSave release];			
		}
	}


}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
	//Set it to today
	[self updateArticleLastUpdated];
	[self updateTextForPullToUpdate];
	
	self.itemsToDisplay = [parsedItems sortedArrayUsingDescriptors:
						   [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"date" 
																				 ascending:NO] autorelease]]];
	self.tableView.userInteractionEnabled = YES;
	self.tableView.alpha = 1;
	[self.tableView reloadData];
	[activityIndicator stopAnimating];
	self.title = @"Blog";
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
	self.title = @"Blog";
	self.itemsToDisplay = [NSArray array];
	[parsedItems removeAllObjects];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error Parsing"
													message: @"We were unable to update the blog feed."
												   delegate: self
										  cancelButtonTitle: @"OK"
										  otherButtonTitles: nil];
    [alert show];
    [alert release];
	
	self.tableView.userInteractionEnabled = YES;
	self.tableView.alpha = 1;
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
	feed.publishedOn = [itemToSave objectForKey:@"publishedOn"];
	feed.content = [itemToSave objectForKey:@"content"];
	
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here -- for example, create and push another view controller.
	// Show detail
	ArticleDetailsViewController *detail = [[ArticleDetailsViewController alloc] init];
	Feed *feed = (Feed *)[self.fetchedResultsController objectAtIndexPath:indexPath];
	detail.item = feed;
	[self.navigationController pushViewController:detail animated:YES];
	[detail release];
	
	// Deselect
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
	NSString *attributeValue = @"article";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like %@",
							  attributeName, attributeValue];
	[fetchRequest setPredicate:predicate];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"publishedOn" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Articles"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![fetchedResultsController_ performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return fetchedResultsController_;
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
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


@end

