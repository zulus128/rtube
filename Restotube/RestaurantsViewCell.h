//
//  RestaurantsViewCell.h
//  Restotube
//
//  Created by Maksim Kis on 08.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurants.h"

@interface RestaurantsViewCell : UITableViewCell {
    
}

@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property (weak, nonatomic) IBOutlet UILabel *labelDiscount;
@property (weak, nonatomic) IBOutlet UIView *imageDiscount;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelAverage;
@property (weak, nonatomic) IBOutlet UILabel *labelLikes;
@property (weak, nonatomic) IBOutlet UILabel *labelDistance;

@property (assign, readwrite) NSInteger currentAddress;

@property (nonatomic, strong) Restaurants *restaurantInfo;
- (void) setRestaurant:(Restaurants *)restaurant;
@end
