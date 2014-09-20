//
//  FlipsideViewController.m
//  DeviceChkr
//
//  Created by Jay Versluis on 24/04/2014.
//  Copyright (c) 2014 Pinkstone Pictures LLC. All rights reserved.
//

#import "FlipsideViewController.h"

@interface FlipsideViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation FlipsideViewController

- (void)awakeFromNib
{
    if ([self respondsToSelector:@selector(preferredContentSize)]) {
        self.preferredContentSize = CGSizeMake(320.0, 480.0);
    }
    
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self populateWebView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (void)populateWebView {
    
    NSURL *htmlurl = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"index" ofType:@"html"]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:htmlurl]];
    
}

@end
