//
//  ReplenishNavigationController.m
//  Restotube
//
//  Created by Victort on 15/09/15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "ReplenishNavigationController.h"

@interface ReplenishNavigationController ()

@end

@implementation ReplenishNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
