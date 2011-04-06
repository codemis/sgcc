//
//  ModalViewControllerDelegate.h
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalViewControllerDelegate <NSObject>
	-(void) modalViewReadyToDismiss;
@end
