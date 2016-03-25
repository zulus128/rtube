//
//  ReplenishBalanceViewController.h
//  Restotube
//
//  Created by Victort on 10/09/15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReplenishBalanceViewControllerDelegate <NSObject>

-(void) replenishWillReturn: (BOOL)success;

@end

@interface ReplenishBalanceViewController : UIViewController

@property (weak, nonatomic) id<ReplenishBalanceViewControllerDelegate> delegate;

@property (assign, nonatomic) BOOL      dontConfigureBackButton;
@property (assign, nonatomic) NSInteger minSum;
@property (assign, nonatomic) NSInteger requiredSum;

@end
