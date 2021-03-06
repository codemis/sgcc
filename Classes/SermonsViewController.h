//
//  SermonsViewController.h
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/23/11.
//  Copyright 2011 SGUC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PullRefreshTableViewController.h"


@interface SermonsViewController : PullRefreshTableViewController <NSXMLParserDelegate, NSFetchedResultsControllerDelegate>{
	NSMutableData *responseData;  
	
    NSMutableDictionary *item;  
    NSString *currentElement; 
	NSMutableString *currentTitle, *currentAuthor, *currentLink, *currentSummary, *currentDateString;
	NSDate *podcastLastUpdated;
	
	NSXMLParser *myFeedParser;
@private
    NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;
}

@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSMutableString *currentTitle;
@property (nonatomic, retain) NSMutableString *currentDateString;
@property (nonatomic, retain) NSMutableString *currentAuthor;
@property (nonatomic, retain) NSMutableString *currentLink;
@property (nonatomic, retain) NSMutableString *currentSummary;
@property (nonatomic, retain) NSMutableString *currentPodcastGUID;
@property (nonatomic, retain) NSString *currentElement;
@property (nonatomic, retain) NSMutableDictionary *item;
@property (nonatomic, retain) NSXMLParser *myFeedParser;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSDate *podcastLastUpdated;

- (NSDate *) podcastLastUpdated;

@end
