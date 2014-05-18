//
//  SplashViewController.m
//  RoadCulture
//
//  Created by Petro Akzhygitov on 5/17/14.
//  Copyright (c) 2014 Petro Akzhygitov. All rights reserved.
//

#import "SplashViewController.h"

@implementation SplashViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(pushMainViewController) userInfo:nil repeats:YES];
}

- (void)pushMainViewController {
    [self performSegueWithIdentifier:@"pushMainViewControllerSegue" sender:nil];
}

@end
