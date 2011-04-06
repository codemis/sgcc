//
//  SermonsViewController.h
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/23/11.
//  Copyright 2011 SGUC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SermonsViewController : UITableViewController <NSXMLParserDelegate>{
	NSMutableData *responseData;  
    NSMutableArray *itemsToDisplay;	
	UIActivityIndicatorView *activityIndicator;
	
    NSMutableDictionary *item;  
    NSString *currentElement;  
    NSMutableString *currentTitle, *currentAuthor, *currentLink, *currentSummary;
	NSDate *currentDate;
	
	NSXMLParser *myFeedParser;
}

@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSMutableArray *itemsToDisplay;
@property (nonatomic, retain) NSMutableString *currentTitle;
@property (nonatomic, retain) NSDate *currentDate;
@property (nonatomic, retain) NSMutableString *currentAuthor;
@property (nonatomic, retain) NSMutableString *currentLink;
@property (nonatomic, retain) NSMutableString *currentSummary;
@property (nonatomic, retain) NSString *currentElement;
@property (nonatomic, retain) NSMutableDictionary *item;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) NSXMLParser *myFeedParser;

@end
