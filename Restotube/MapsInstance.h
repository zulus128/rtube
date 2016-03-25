//
//  MapsInstance.h
//  Restotube
//
//  Created by Maksim Kis on 13.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

@interface MapsInstance : NSObject<CLLocationManagerDelegate>

@property (nonatomic, assign) BOOL myLocationLoaded;

-(id) init;
+ (MapsInstance*)getInstance;
-(double) distanceBetween: (double) latitude : (double) longitude;
-(void) getMyCoordinames: (double*) latitude : (double*) longitude;
-(CLLocationCoordinate2D) getMyLocation;
@end
