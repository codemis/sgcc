//
//  SermonDetailsViewController.h
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/23/11.
//  Copyright 2011 SGUC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Feed.h"

@interface SermonDetailsViewController : UITableViewController{
	Feed *sermon;
	AVPlayer *avPlayer;
}

@property (nonatomic, retain) Feed *sermon;
@property (nonatomic, retain) AVPlayer *avPlayer;

@end
