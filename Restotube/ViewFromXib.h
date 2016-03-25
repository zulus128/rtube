//
//  ViewFromXib.h
//  Restotube
//
//  Created by owel on 29/08/15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewFromXib : UIView

@property (strong, nonatomic) UIView    *containerView;
@property (strong, nonatomic) UIColor   *defaultColor;

-(void) commonInit;

@end
