//
//  ArticleDetailsViewController.h
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/21/11.
//  Copyright 2011 SGUC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"
@interface ArticleDetailsViewController : UIViewController {
	Feed *item;
}
@property (nonatomic, retain) Feed *item;
@property (nonatomic, retain) IBOutlet UIWebView *myWebView;
@end
