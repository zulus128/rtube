//
//  MapsInstance.m
//  Restotube
//
//  Created by Maksim Kis on 13.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "MapsInstance.h"

static MapsInstance* s_MapsInstance = nil;

@implementation MapsInstance {
    CLLocationCoordinate2D _mylocation;
    CLLocationManager *locationManager;
}

+ (MapsInstance*)getInstance {
    if (s_MapsInstance == nil) {
        s_MapsInstance = [[MapsInstance alloc] init];
    }
    
    return s_MapsInstance;
}

-(id)init {
    if (self = [super init]) {
        self.myLocationLoaded= NO;
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _mylocation.longitude = 0;
        _mylocation.latitude = 0;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
            // Will open an confirm dialog to get user's approval
            [locationManager requestWhenInUseAuthorization];
            //[_locationManager requestAlwaysAuthorization];
        } else {
            [locationManager startUpdatingLocation]; //Will update location immediately
        }
    }
    
    return self;
}

-(CLLocationCoordinate2D) getMyLocation {
    return _mylocation;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation* location = [locations lastObject];
    _mylocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"LocationUpdated"
     object:self];
    if(self.myLocationLoaded == NO) {
        self.myLocationLoaded = YES;
    }
}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"User still thinking..");
        } break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"User hates you");
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [locationManager startUpdatingLocation]; //Will update location immediately
        } break;
        default:
            break;
    }
}

-(double) distanceBetween: (double) latitude : (double) longitude {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = latitude;
    coordinate.longitude =  longitude;
    return GMSGeometryDistance(_mylocation, coordinate);
}

-(void) getMyCoordinames: (double*) latitude : (double*) longitude {
    *latitude = _mylocation.latitude;
    *longitude = _mylocation.longitude;
}


@end
