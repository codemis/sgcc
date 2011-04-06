//
//  ArticleDetailsViewController.h
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/21/11.
//  Copyright 2011 SGUC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedItem.h"


@interface ArticleDetailsViewController : UITableViewController {
	MWFeedItem *item;
	NSString *dateString, *summaryString, *contentString;
}
@property (nonatomic, retain) MWFeedItem *item;
@property (nonatomic, retain) NSString *dateString, *summaryString, *contentString;

@end
