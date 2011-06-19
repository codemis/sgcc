//
//  EventsWebViewController.h
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/22/11.
//  Copyright 2011 SGUC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventsWebViewController : UIViewController <UIWebViewDelegate> {
}

@property(nonatomic,retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;

@end
