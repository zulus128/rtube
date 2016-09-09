//
//  UIImage+MapsView.h
//  Restotube
//
//  Created by Maksim Kis on 13.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MapsView)

+ (UIImage *) restaurantTitleImageWithTitle:(NSString *)title isSale:(BOOL)isSale;
@end
