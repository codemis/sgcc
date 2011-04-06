//
//  TwoWaysViewController.h
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/28/11.
//  Copyright 2011 SGUC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalViewControllerDelegate.h"


@interface TwoWaysViewController : UIViewController <UIWebViewDelegate, ModalViewControllerDelegate> {
	UIActivityIndicatorView *activityIndicator;
}

@property(nonatomic,retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) id <ModalViewControllerDelegate> delegate;
@end