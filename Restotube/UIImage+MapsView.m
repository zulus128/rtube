//
//  UIImage+MapsView.m
//  Restotube
//
//  Created by Maksim Kis on 13.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "UIImage+MapsView.h"

@implementation UIImage (MapsView)

+ (UIImage *)restaurantTitleImageWithTitle:(NSString *)title isSale:(BOOL)isSale
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 2000, 50)];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]];
    [label setTextColor: isSale ? [UIColor whiteColor] : [UIColor blackColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:title];
    [label sizeToFit];
    CGRect labelFrame = CGRectMake(0, 0, label.frame.size.width + 20.0f, 23.0f);
    CGRect imageViewFrame = CGRectMake(0, 0, label.frame.size.width + 20.0f, 27.0f);
    UIImage *imageBackground = [[UIImage imageNamed:isSale ? @"map_restaurant_label_pink.png" : @"map_restaurant_label.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    [label setFrame:labelFrame];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:imageBackground];
    [imageView setFrame:imageViewFrame];
    UIImageView *imageViewMid = [[UIImageView alloc] initWithFrame:imageViewFrame];
    [imageViewMid setContentMode:UIViewContentModeCenter];
    [imageViewMid setImage:[UIImage imageNamed:isSale ? @"map_restaurant_label_mid_pink.png" : @"map_restaurant_label_mid.png"]];
    [imageView addSubview:imageViewMid];
    [imageView addSubview:label];
//    imageViewMid.backgroundColor = [UIColor redColor];
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, imageView.opaque, [[UIScreen mainScreen] scale]);
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
