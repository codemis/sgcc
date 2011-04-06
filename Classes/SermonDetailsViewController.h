//
//  SermonDetailsViewController.h
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/23/11.
//  Copyright 2011 SGUC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SermonDetailsViewController : UITableViewController <UIWebViewDelegate> {
	NSDictionary *sermon;
	NSString *authorString, *summaryString, *titleString, *sermonLink;

}

@property (nonatomic, retain) NSDictionary *sermon;
@property (nonatomic, retain) NSString *authorString, *summaryString, *titleString, *sermonLink;
@property (nonatomic, retain) UIWebView *playerView;

@end
