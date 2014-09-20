//
//  MainViewController.m
//  DeviceChkr
//
//  This demo is based on the following links:
//  http://stackoverflow.com/questions/448162/determine-device-iphone-ipod-touch-with-iphone-sdk

//  https://developer.apple.com/library/ios/documentation/System/Conceptual/ManPages_iPhoneOS/man3/sysctlbyname.3.html

//  http://stackoverflow.com/questions/20578741/sysctlbyname-error-implicit-declaration-of-function-sysctlbyname-is-invalid-in

//  results verified here:
//  http://www.everymac.com/ultimate-mac-lookup/
//  http://theiphonewiki.com/wiki/Models
//
//  Created by Jay Versluis on 24/04/2014.
//  Copyright (c) 2014 Pinkstone Pictures LLC. All rights reserved.
//

#import "MainViewController.h"
#import <sys/sysctl.h>

@interface MainViewController ()

@property (strong, nonatomic) IBOutlet UILabel *deviceTitle;
@property (strong, nonatomic) IBOutlet UILabel *deviceDescription;
@property (strong, nonatomic) IBOutlet UILabel *helloLabel;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self checkDevice];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
    
        [(FlipsideViewController *)segue.destinationViewController setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

- (void)checkDevice {
    
    // tweak hello label
    NSString *testString = [[self platformString]substringToIndex:3];
    if ([testString isEqualToString:@"Mac"]) {
        self.helloLabel.text = @"This device is a";
    }
    
    // determine current device (compile time)
    NSString *currentDevice = [UIDevice currentDevice].model;
    self.deviceDescription.text = [NSString stringWithFormat:@"Compile Time ID:\n%@\n\nPlatform ID:\n%@", currentDevice, [self platformIdentifier]];
    
    // ask for current device (runtime, see below)
    self.deviceTitle.text = [self platformString];
    
}


- (NSString *)platformIdentifier {
    
    // Gets a string with the device model
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    return platform;
}

- (NSString *) platformString {
    
    NSString *platform;
    platform = [self platformIdentifier];
    
    // iPhones
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"Original iPhone";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S (GSM)";
    
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM, Europe/Asia)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (US/Japan)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (Europe/Asia)";
    
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    
    // iPod Touchs
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    
    // iPads
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad 1 (WiFi or 3G)";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (Rev A, WiFi)";
    
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (Sprint/VRZN)";
    
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (GSM+CDMA)";
    
    if ([platform isEqualToString:@"i386"])         return @"Mac 32bit";
    if ([platform isEqualToString:@"x86_64"])       return @"Mac 64bit";
    
    return platform;
}

@end
