//
//  AboutUsViewController.h
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/26/11.
//  Copyright 2011 SGUC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalViewControllerDelegate.h"


@interface AboutUsViewController : UIViewController <UIActionSheetDelegate, ModalViewControllerDelegate> {}

@property(nonatomic, retain) IBOutlet UITabBar* tabbar;
- (IBAction) openContactView;
- (IBAction) openTwoWaysView;
- (IBAction) openWhoWeAreView;
- (IBAction) openBeliefsView;

@end
