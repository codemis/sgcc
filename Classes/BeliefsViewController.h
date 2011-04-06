//
//  BeliefsViewController.h
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalViewControllerDelegate.h"

@interface BeliefsViewController : UIViewController <ModalViewControllerDelegate> {}

@property (nonatomic, retain) id <ModalViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIWebView *myWebView;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@end