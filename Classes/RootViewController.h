//
//  RootViewController.h
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/21/11.
//  Copyright 2011 SGUC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MWFeedParser.h"
#import "PullRefreshTableViewController.h"

@interface RootViewController : PullRefreshTableViewController <NSFetchedResultsControllerDelegate, MWFeedParserDelegate> {
	// Parsing
	MWFeedParser *feedParser;
	NSMutableArray *parsedItems;
	
	// Displaying
	NSArray *itemsToDisplay;
	NSDateFormatter *formatter;
	NSDate *articleLastUpdated;
@private
    NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSArray *itemsToDisplay;
@property (nonatomic, retain) NSDate *articleLastUpdated;

- (NSDate *) articleLastUpdated;

@end