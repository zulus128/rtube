//
//  NearMeViewController.h
//  Restotube
//
//  Created by user on 03.08.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearMeViewController : UIViewController
@property (nonatomic, assign) BOOL needsSale;
@property (nonatomic, assign) BOOL needsGift;
@property (assign, readwrite) NSInteger currentAddress;
@end
