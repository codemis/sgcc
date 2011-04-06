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

@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate, MWFeedParserDelegate> {
	UIActivityIndicatorView *activityIndicator; 
	// Parsing
	MWFeedParser *feedParser;
	NSMutableArray *parsedItems;
	
	// Displaying
	NSArray *itemsToDisplay;
	NSDateFormatter *formatter;
@private
    NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) NSArray *itemsToDisplay;

@end