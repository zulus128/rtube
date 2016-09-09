//
//  MapsViewController.m
//  Restotube
//
//  Created by Maksim Kis on 13.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "MapsViewController.h"
#import "MapsInstance.h"
#import "UIAlertView+AFNetworking.h"
#import "UIMapsMarker.h"
#import "UIImage+MapsView.h"
#import "RestaurantsDetailViewController.h"
#import "QuartzCore/QuartzCore.h"


@interface MapsViewController ()
@property (strong,nonatomic) GMSMapView* googleMapsView;
@end

@implementation MapsViewController 
@synthesize activityIndicatorObject;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"head-line"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTranslucent:false];
    [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed: @"restotube-logo"]]];

    _googleMapsView = [[GMSMapView alloc] initWithFrame:self.view.bounds];
    _googleMapsView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _googleMapsView.myLocationEnabled = true;
    _googleMapsView.delegate = self;
    _googleMapsView.settings.rotateGestures = false;
    _googleMapsView.settings.tiltGestures = false;

    [self.view addSubview:_googleMapsView];
    
    GMSCameraUpdate *cameraUpdate;
    if([[MapsInstance getInstance] myLocationLoaded] == YES)
    {
        cameraUpdate = [GMSCameraUpdate setTarget:[[MapsInstance getInstance] getMyLocation] zoom:13];
    }
    else
    {
        CLLocationCoordinate2D customLocation;
        customLocation.latitude = 55.755786000000001;
        customLocation.longitude = 37.617632999999998;
        cameraUpdate = [GMSCameraUpdate setTarget:customLocation zoom:13];
    }
    [_googleMapsView animateWithCameraUpdate:cameraUpdate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadData];
}

- (void)refresh
{
    [self.googleMapsView clear];

    CLLocationCoordinate2D myLocation = [[MapsInstance getInstance] getMyLocation];
    
    CLLocationDegrees maxX = myLocation.latitude;
    CLLocationDegrees minX = myLocation.latitude;
    CLLocationDegrees maxY = myLocation.longitude;
    CLLocationDegrees minY = myLocation.longitude;

    
    for(int i = 0 ; i < [self.restaurants count] ; i ++ ) {
        Restaurants* restaurant = [self.restaurants objectAtIndex:i];
        NSString* name =  restaurant.name;
        BOOL isSale = NO;
//        if(!restaurant.saleint) {
//            if (restaurant.presentDesc.length > 0) {
//                isSale = YES;
//            }
//        } else {
//            isSale = YES;
//        }
        
        for(int j = 0; j < [restaurant.addresses count]; j++) {
            Addresses* address = [restaurant.addresses objectAtIndex:j];
            
            CLLocationCoordinate2D coordinate;
            coordinate.latitude =  [address.lat floatValue];
            coordinate.longitude = [address.lon floatValue];
            UIMapsMarker *marker = [[UIMapsMarker alloc] init];
            
            [marker setId:i];
            [marker setIcon:[UIImage restaurantTitleImageWithTitle:name isSale:isSale]];
            [marker setPosition:coordinate];
            [marker setMap:_googleMapsView];
            
            if (maxX < coordinate.latitude)
            {
                maxX = coordinate.latitude;
            }
            if (maxY < coordinate.longitude)
            {
                maxY = coordinate.longitude;
            }
            if (minX > coordinate.latitude)
            {
                minX = coordinate.latitude;
            }
            if (minY > coordinate.longitude)
            {
                minY = coordinate.longitude;
            }

        }
    }
 
    if (myLocation.longitude == maxY || myLocation.longitude == minY || myLocation.latitude == minX || myLocation.latitude == maxX)
    {
        CLLocationCoordinate2D c1;
        c1.latitude = maxX;
        c1.longitude = maxY;
        
        CLLocationCoordinate2D c2;
        c2.latitude = minX;
        c2.longitude = minY;
        
        if([[MapsInstance getInstance] myLocationLoaded] == YES)
        {
            GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:c1 coordinate:c2];
            GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate fitBounds:bounds withEdgeInsets:UIEdgeInsetsMake(-2, -2, -2, -2)];
            
            [_googleMapsView animateWithCameraUpdate:cameraUpdate];
        }
    }
}

- (void)reloadData
{
    
    if(self.restaurants == nil) {
        activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicatorObject.backgroundColor = [UIColor clearColor];
        activityIndicatorObject.color = [UIColor colorWithRed:204/255.0 green:50/255.0 blue:101/255.0 alpha:1];
        activityIndicatorObject.alpha = 1.0;
        CGSize sizeOfScreen = [[UIScreen mainScreen] bounds].size;
        activityIndicatorObject.center = CGPointMake(sizeOfScreen.width / 2, sizeOfScreen.height / 2 - activityIndicatorObject.bounds.size.height);
        [self.view addSubview:activityIndicatorObject];
        [activityIndicatorObject  startAnimating];
        activityIndicatorObject.layer.zPosition = 2;
        NSURLSessionTask *task = [Restaurants restaurantsWithBlock:0: 0: 0: 0: ^(NSArray *categories, NSError *error) {
            if (!error) {
                self.restaurants = categories;
                [self refresh];
            }
            [activityIndicatorObject  stopAnimating];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
        
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    }
    
    else {
        [self refresh];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
}

- (BOOL) mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    int idx = [(UIMapsMarker *)marker Id];
    
    Restaurants *category = [self.restaurants objectAtIndex:(NSUInteger)idx];
    [self performSegueWithIdentifier:@"restaurantsDetailSegue" sender:category];
    return YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"restaurantsDetailSegue"])
    {
        RestaurantsDetailViewController *controller = (RestaurantsDetailViewController *)segue.destinationViewController;
        controller.restaurants = (Restaurants *)sender;
    }
}



@end

/*
-(void) viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"head-line"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTranslucent:false];
    [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed: @"restotube-logo"]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationUpdated:)
                                                 name:@"LocationUpdated"
                                               object:nil];
    GMSCameraPosition *camera = nil;
    
    if([[MapsInstance getInstance] myLocationLoaded] == YES) {
         camera = [GMSCameraPosition cameraWithTarget:[[MapsInstance getInstance] getMyLocation] zoom:13];
    }
    else {
        CLLocationCoordinate2D customLocation;
        customLocation.latitude = 55.755786000000001;
        customLocation.longitude = 37.617632999999998;
        camera = [GMSCameraPosition cameraWithTarget:customLocation zoom:13];
    }
   self.googleMapsView = [GMSMapView mapWithFrame:_containerView.bounds camera:camera];
    
    [self.googleMapsView setFrame:self.view.bounds];
   self.googleMapsView.myLocationEnabled = YES;
    self.googleMapsView.delegate = self;
    [self.view addSubview:self.googleMapsView];
    _googleMapsView.layer.zPosition = 1;
     [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    self.containerView.hidden = YES;
    
}

- (void)refresh
{
     [self.googleMapsView clear];
    for(int i = 0 ; i < [self.restaurants count] ; i ++ ) {
        Restaurants* restaurant = [self.restaurants objectAtIndex:i];
        NSString* name =  restaurant.name;
        
        for(int j = 0; j < [restaurant.addresses count]; j++) {
            Addresses* address = [restaurant.addresses objectAtIndex:j];
            
            CLLocationCoordinate2D coordinate;
            coordinate.latitude =  [address.lat floatValue];
            coordinate.longitude = [address.lon floatValue];
            UIMapsMarker *marker = [[UIMapsMarker alloc] init];
            [marker setId:i];
            [marker setIcon:[UIImage restaurantTitleImageWithTitle:name]];
            [marker setPosition:coordinate];
            [marker setMap:_googleMapsView];
        }
    }

}

- (void)reloadData
{
   
    if(self.restaurants == nil) {
        activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicatorObject.alpha = 1.0;
        CGSize sizeOfScreen = [[UIScreen mainScreen] bounds].size;
        activityIndicatorObject.center = CGPointMake(sizeOfScreen.width / 2, sizeOfScreen.height / 2 - activityIndicatorObject.bounds.size.height);
        [self.view addSubview:activityIndicatorObject];
        [activityIndicatorObject  startAnimating];
        activityIndicatorObject.layer.zPosition = 2;
        [activityIndicatorObject setBackgroundColor:[UIColor blackColor]];
        NSURLSessionTask *task = [Restaurants restaurantsWithBlock:0: 0: 0: 0: ^(NSArray *categories, NSError *error) {
            if (!error) {
                self.restaurants = categories;
                [self refresh];
            }
            [activityIndicatorObject  stopAnimating];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
        
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    }
    
    else {
        [self refresh];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self reloadData];
}

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.googleMapsView != nil ) {
        [self.googleMapsView removeFromSuperview];
    }

}


- (void) locationUpdated:(NSNotification *) notification  {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:[[MapsInstance getInstance] getMyLocation]  zoom:13];
    _googleMapsView = [GMSMapView  mapWithFrame:CGRectZero camera:camera];
    _googleMapsView.myLocationEnabled = YES;
    _googleMapsView.delegate = self;

    NSLog(@"!!%f -- %f",    _googleMapsView.myLocation.coordinate.latitude,     _googleMapsView.myLocation.coordinate.longitude);
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
//    [self refresh];
    NSLog(@"REFRESH");
}

- (BOOL) mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    int idx = [(UIMapsMarker *)marker Id];
    
    Restaurants *category = [self.restaurants objectAtIndex:(NSUInteger)idx];
    [self performSegueWithIdentifier:@"restaurantsDetailSegue" sender:category];
    return YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"restaurantsDetailSegue"])
    {
        RestaurantsDetailViewController *controller = (RestaurantsDetailViewController *)segue.destinationViewController;
        controller.restaurants = (Restaurants *)sender;
    }
}

@end
*/
