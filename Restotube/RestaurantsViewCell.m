//
//  RestaurantsViewCell.m
//  Restotube
//
//  Created by Maksim Kis on 08.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "RestaurantsViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MapsInstance.h"
#import "RequestManager.h"

@interface RestaurantsViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageDiscountWidth;

@end

@implementation RestaurantsViewCell

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    [super dealloc];
}


- (void) awakeFromNib {
    
    _imageDiscount.layer.masksToBounds = YES;
    _imageDiscount.layer.cornerRadius = _imageDiscount.frame.size.height/2;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationUpdatedNotification:)
                                                 name:@"LocationUpdated"
                                               object:nil];
}


- (void) locationUpdatedNotification:(NSNotification *) notification {
    if([self.restaurantInfo.addresses count]) {
        CLLocationCoordinate2D _mylocation = [[MapsInstance getInstance] getMyLocation];
        CLLocationDistance d = MAXFLOAT;
        for(int j = 0; j < [self.restaurantInfo.addresses count]; j++) {
            Addresses* address = [self.restaurantInfo.addresses objectAtIndex:j];
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [address.lat doubleValue];
            coordinate.longitude =  [address.lon doubleValue];
            
            CLLocationDistance distance =  GMSGeometryDistance(_mylocation,coordinate);
            if (d > distance)
            {
                d = distance;
            }
        }
        d = d / 1000;
        NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
        [fmt setPositiveFormat:@"0.#"];
        NSString* format = [ NSString stringWithFormat:@"%@ км", [fmt stringFromNumber:[NSNumber numberWithFloat:d]]];
        self.labelDistance.text = format;
    }
    else {
        self.labelDistance.text = @"";
    }
}


- (void) setRestaurant:(Restaurants *)restaurant {
    self.restaurantInfo = restaurant;
    self.labelName.text = restaurant.name;
    self.labelLikes.text = [NSString stringWithFormat:@"%ld", (long)restaurant.likes];
    self.labelTime.text = restaurant.work_time;
    self.labelAverage.text = restaurant.averages;
    
    if([restaurant.sale isEqualToString:@""] == false) {
        self.labelDiscount.text = restaurant.sale;
        _imageDiscountWidth.constant = 88;
    }
    else if(restaurant.presentDesc && ![restaurant.presentDesc isEqualToString:@""]) {
        self.labelDiscount.text = restaurant.presentDesc;
        
        NSDictionary *attributes = @{NSFontAttributeName: self.labelDiscount.font};
        CGRect textRect = [restaurant.presentDesc boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        _imageDiscountWidth.constant = textRect.size.width + 20;
    } else {
        self.labelDiscount.hidden = true;
        self.imageDiscount.hidden = true;
    }

    NSURL *assetsBaseUrl = [RequestManager sharedManager].assetsBaseUrl;
    NSURL *imageUrl = [[NSURL alloc] initWithString:restaurant.img relativeToURL:assetsBaseUrl];
    NSURLRequest* req_bg = [NSURLRequest requestWithURL:imageUrl];

    __weak UIImageView *weakImageView = self.imageViewBackground;

    [self.imageViewBackground setImageWithURLRequest:req_bg placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        UIImageView *strongImageView = weakImageView;
        if (!strongImageView) return;
        
        [UIView transitionWithView:strongImageView
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            strongImageView.image = image;
                        }
                        completion:NULL];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"error11: %@", error);
    }];
    
    
    [self setNeedsLayout];
}

@end
