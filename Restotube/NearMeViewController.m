//
//  NearMeViewController.m
//  Restotube
//
//  Created by user on 03.08.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "NearMeViewController.h"
#import "UIAlertView+AFNetworking.h"

#import "RestaurantsDetailViewController.h"

#import "RestaurantsViewCell.h"
#import "MapsInstance.h"
#import <CoreLocation/CoreLocation.h>


@interface NearMeViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
{
    CLLocation *_myLocation;
    BOOL _updated;
    
}
@property (nonatomic, strong) NSArray *restaurants;
@property (nonatomic, strong) NSMutableArray *sortedRestaurants;
@property (nonatomic, strong) NSMutableArray *sortedAddresses;
@property (nonatomic, strong) NSMutableArray *sortedDistanse;
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation NearMeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"head-line"]];
    _tableView.backgroundColor = [UIColor clearColor];
    _locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    _locationManager.delegate = self; // we set the delegate of locationManager to self.
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    
    [_locationManager startUpdatingLocation];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"head-line"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTranslucent:false];
    [self.tableView setAllowsSelection:YES];
    [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed: @"restotube-logo"]]];
    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 1.0f);
    TopBorder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"divider-pink"]].CGColor;
    [self.tableView.layer addSublayer:TopBorder];}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _myLocation = [locations lastObject];
    if (_myLocation) {
        [_locationManager stopUpdatingLocation];
    }
    if (!_updated)
    {
        [self prepeareSorted];
        _updated = YES;
        [_tableView reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)reloadData
{
    _activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorObject.alpha = 1.0;
    CGSize sizeOfScreen = [[UIScreen mainScreen] bounds].size;
    _activityIndicatorObject.center = CGPointMake(sizeOfScreen.width / 2, sizeOfScreen.height / 2 - _activityIndicatorObject.bounds.size.height);
    [self.view addSubview:_activityIndicatorObject];
    [_activityIndicatorObject  startAnimating];
    _activityIndicatorObject.layer.zPosition = 2;
    _activityIndicatorObject.backgroundColor = [UIColor clearColor];
    _activityIndicatorObject.color = [UIColor colorWithRed:204/255.0 green:50/255.0 blue:101/255.0 alpha:1];
     [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    
    CGFloat scaleFactor=[[UIScreen mainScreen] scale];
    float height = 154 * scaleFactor;
    float width  = [[UIScreen mainScreen] applicationFrame].size.width * scaleFactor;
    
    NSURLSessionTask *task = [Restaurants restaurantsWithBlock:width: height: 0: 100 : ^(NSArray *categories, NSError *error) {
        if (!error) {
            self.restaurants = categories;
            _updated = NO;
            if (_myLocation)
            {
                [self prepeareSorted];
                _updated = YES;
                [_tableView reloadData];
            }
        }
        [_activityIndicatorObject  stopAnimating];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

- (void)prepeareSorted
{
    NSMutableDictionary *locations = [NSMutableDictionary new];
    NSMutableDictionary *addresses = [NSMutableDictionary new];
    NSMutableArray *empty = [NSMutableArray array];
    NSMutableArray *emptyDist = [NSMutableArray array];
    NSMutableArray *emptyAddr = [NSMutableArray array];
    for(int i = 0 ; i < [self.restaurants count] ; i ++ ) {
        Restaurants* restaurant = [self.restaurants objectAtIndex:i];
        BOOL isGift = NO;
        BOOL isSale = NO;
//        NSLog(@"---1 %@", restaurant.name);
        if([restaurant.sale isEqualToString: @""]) {
            if (restaurant.presentDesc.length == 0) {
                //do nothing
            }
            else {
                isGift = YES;
            }
        } else {
            isSale = YES;
        }
        if(!isSale && self.needsSale) {
            continue;
        }
        if(!isGift && self.needsGift) {
            continue;
        }

        CLLocationDistance d = MAXFLOAT;
        for(int j = 0; j < [restaurant.addresses count]; j++) {
            Addresses* address = [restaurant.addresses objectAtIndex:j];
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [address.lat doubleValue];
            coordinate.longitude =  [address.lon doubleValue];

            CLLocationDistance distance = distance =  GMSGeometryDistance(_myLocation.coordinate,coordinate);
//            if (d > distance) {
                d = distance;
//            }
        if(!isGift && !isSale) {
            [empty addObject:restaurant];
            [emptyDist addObject:@(d / 1000)];
            [emptyAddr addObject:@(j + 1)];
            continue;
        }

        while ([locations objectForKey:@(d / 1000)]) {
            d += 5;
        }
            [locations setObject:restaurant forKey:@(d / 1000)];
            [addresses setObject:@(j + 1) forKey:@(d / 1000)];
//        NSLog(@"----- %@ %@", restaurant.name, @(d / 1000));
        }
    }
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray *sortedKeys = [[locations allKeys] sortedArrayUsingDescriptors:@[descriptor]];
    
    self.sortedDistanse = [NSMutableArray arrayWithArray: sortedKeys];
    _sortedRestaurants = [NSMutableArray new];
    _sortedAddresses = [NSMutableArray new];
    for (NSNumber *key in sortedKeys)
    {
        [_sortedRestaurants addObject:[locations objectForKey:key]];
        [_sortedAddresses addObject:[addresses objectForKey:key]];
    }
    [_sortedRestaurants addObjectsFromArray:empty];
    [self.sortedDistanse addObjectsFromArray:emptyDist];
    [self.sortedAddresses addObjectsFromArray:emptyAddr];
//    for(int i = 0; i < _sortedRestaurants.count; i++) {
//        Restaurants *r = _sortedRestaurants[i];
//        NSLog(@"----- %@ %@ %@", r.name, _sortedDistanse[i], _sortedAddresses[i]);
//    }
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortedRestaurants.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"restaurantsViewCell";
    
    RestaurantsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[RestaurantsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.imageViewBackground.image = nil;
    [cell setRestaurant:[_sortedRestaurants objectAtIndex:(NSUInteger) indexPath.row]];
    cell.currentAddress = [[_sortedAddresses objectAtIndex:indexPath.row] intValue];
    cell.labelDistance.text = @"";
    
    NSArray* addresses = cell.restaurantInfo.addresses;
    if([addresses count])
    {
        NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
        [fmt setPositiveFormat:@"0.#"];
        NSString* format = [ NSString stringWithFormat:@"%@ км", [fmt stringFromNumber:_sortedDistanse[indexPath.row]]];
        cell.labelDistance.text = format;
    }
    else {
        cell.labelDistance.text = @"...";
    }
    
//    Restaurants *r = _sortedRestaurants[indexPath.row];
//    NSLog(@"----- %@ %@", r.name, _sortedDistanse[indexPath.row]);

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    Restaurants *category = self.sortedRestaurants[indexPath.row];
    [self performSegueWithIdentifier:@"restaurantsDetailSegue" sender:category];
    self.currentAddress = [[_sortedAddresses objectAtIndex:indexPath.row] intValue];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"restaurantsDetailSegue"])
    {
        RestaurantsDetailViewController *controller = (RestaurantsDetailViewController *)segue.destinationViewController;
        controller.restaurants = (Restaurants *)sender;
        controller.currentAddress = self.currentAddress;
    }
}

@end
