//
//  FlipsideViewController.h
//  DeviceChkr
//
//  Created by Jay Versluis on 24/04/2014.
//  Copyright (c) 2014 Pinkstone Pictures LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
