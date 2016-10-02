//
//  ViewController.m
//  RichTest
//
//  Created by GK on 2016.10.02..
//  Copyright © 2016. GKSoftware. All rights reserved.
//

#import "ViewController.h"

@import UserNotifications;


@interface ViewController () <UNUserNotificationCenterDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted) {
            NSLog(@"Granted");
            
            [[UIApplication sharedApplication] registerForRemoteNotifications];
            
        } else {
            NSLog(@"Error registering: %@", error);
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
