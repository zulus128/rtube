//
//  MapsViewController.h
//  Restotube
//
//  Created by Maksim Kis on 13.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Restaurants.h"

@interface MapsViewController : UIViewController <GMSMapViewDelegate, UINavigationBarDelegate> {

}
//@property (weak, nonatomic) IBOutlet GMSMapView *googleMapsView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) NSArray *restaurants;
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;

@end
