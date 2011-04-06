//
//  WhoWeAreViewController.h
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/30/11.
//  Copyright 2011 SGUC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalViewControllerDelegate.h"


@interface WhoWeAreViewController : UIViewController<ModalViewControllerDelegate> {}

@property (nonatomic, retain) id <ModalViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITextView *myTextView;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;

@end