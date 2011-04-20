//
//  SermonDetailsViewController.h
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/23/11.
//  Copyright 2011 SGUC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"

@interface SermonDetailsViewController : UITableViewController <UIWebViewDelegate> {
	Feed *sermon;

}

@property (nonatomic, retain) Feed *sermon;
@property (nonatomic, retain) UIWebView *playerView;

@end
