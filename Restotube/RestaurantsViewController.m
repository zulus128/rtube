//
//  RestaurantsViewController.m
//  Restotube
//
//  Created by Maksim Kis on 08.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "RestaurantsViewController.h"
#import "RestaurantsDetailViewController.h"
#import "RequestManager.h"
#import <Availability.h>
#import <UIKit/UIKit.h>
//#import "UIRefreshControl+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#import "RestaurantsViewCell.h"
#import "MapsInstance.h"
#import "MapsViewController.h"
#import "CategoriesViewController.h"
#include <objc/runtime.h>
#import "Filters.h"
//#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import <QuartzCore/QuartzCore.h>

static int initialPage = 0;

@interface RestaurantsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (readwrite, nonatomic, strong) NSMutableArray *restaurants;
@property (weak, nonatomic) IBOutlet UIButton *buttonFilter;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) int currentPage;
@end

@implementation RestaurantsViewController {
    __weak IBOutlet UIImageView *imageHead;
}


- (void)reload:(__unused id)sender {
       [refreshControl beginRefreshing];
    
    CGFloat scaleFactor=[[UIScreen mainScreen] scale];
    
    float height = 154 * scaleFactor;
    float width  = [[UIScreen mainScreen] applicationFrame].size.width * scaleFactor;
    int offset = 0;
    int limit = 15;
    
//    if([self.restaurants count] == 0) {
//        limit = 15;
//    }
    
    [self.restaurants removeAllObjects];
//       [ self.tableView reloadData];
    self.currentPage = 1;
    NSURLSessionTask *task = [Restaurants restaurantsWithBlock:width: height: offset: limit : ^(NSArray *categories, NSError *error) {
        if (!error) {
            self.restaurants = [categories mutableCopy];
            [self.tableView reloadData];
            [refreshControl endRefreshing];
            self.tableView.showsInfiniteScrolling = YES;
            if ([self.restaurants count] == 0) {
                UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                                self.tableView.bounds.size.width,
                                                                                self.tableView.bounds.size.height)];
                messageLbl.text = @"Не найдено";
                messageLbl.textAlignment = NSTextAlignmentCenter;
                [messageLbl sizeToFit];
                self.tableView.backgroundView = messageLbl;
                self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            }
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
//    [refreshControl setRefreshingWithStateOfTask:task];
}


-(void) viewDidLoad {
    self.restaurants = [NSMutableArray array];
    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 1.0f);
    TopBorder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"divider-pink"]].CGColor;
    [imageHead.layer addSublayer:TopBorder];
    self.tableView.tableFooterView = [[UIView alloc] init];
    CALayer *BotBorder = [CALayer layer];
    BotBorder.frame = CGRectMake(0.0f, imageHead.frame.size.height - 1.5f, self.view.frame.size.width, 1.5f);
    BotBorder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"divider-pink"]].CGColor;
    [imageHead.layer addSublayer:BotBorder];
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"head-line"]]];
     [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed: @"restotube-logo"]]];
    [self.tableView setAllowsSelection:YES];
    [super viewDidLoad];
    self.labelName.text = self.category.title ;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin| UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
    
    
    refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:refreshControl];
        [refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self loadFromServer];
    __weak typeof(self) weakSelf = self;
//      [self reload:nil];
    // refresh new data when pull the table list
//    [self.tableView addPullToRefreshWithActionHandler:^{
//        weakSelf.currentPage = initialPage; // reset the page
//        [weakSelf.restaurants removeAllObjects]; // remove all data
//        [weakSelf.tableView reloadData]; // before load new content, clear the existing table list
//        [weakSelf loadFromServer]; // load new data
//        [weakSelf.tableView.pullToRefreshView stopAnimating]; // clear the animation
//        
//        // once refresh, allow the infinite scroll again
//        weakSelf.tableView.showsInfiniteScrolling = YES;
//    }];
    
    // load more content when scroll to the bottom most
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadFromServer];
    }];
}

- (void)loadFromServer {
    CGFloat scaleFactor=[[UIScreen mainScreen] scale];
    float height = 154 * scaleFactor;
    float width  = [[UIScreen mainScreen] applicationFrame].size.width * scaleFactor;
//    [refreshControl beginRefreshing];
    int offset = 0;
    if(self.currentPage > 0)
         offset = 15 * self.currentPage;
    int limit = 15 + offset;

    NSURLSessionTask *task = [Restaurants restaurantsWithBlock:width: height: offset: limit : ^(NSArray *categories, NSError *error) {
//         [refreshControl endRefreshing];
        if (!error) {
            if([categories count] == 0 && [self.restaurants count] == 0) {
                self.tableView.showsInfiniteScrolling = NO;

                    UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                                    self.tableView.bounds.size.width,
                                                                                    self.tableView.bounds.size.height)];
                    messageLbl.text = @"Не найдено";
                    messageLbl.textAlignment = NSTextAlignmentCenter;
                    messageLbl.textColor = [UIColor whiteColor];
                    [messageLbl sizeToFit];
                    self.tableView.backgroundView = messageLbl;
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            } else {

                if(self.tableView.backgroundView) {
                    [self.tableView.backgroundView  removeFromSuperview];
                    self.tableView.backgroundView  = nil;
                }
                
                _currentPage++;
                int currentRow = (int)[self.restaurants count];
                
                for(id obj in categories) {
                    [self.restaurants addObject:obj];
                }
                
                [self reloadTableView:currentRow];
//                [self.tableView.pullToRefreshView stopAnimating];
                [self.tableView.infiniteScrollingView stopAnimating];
            }
            
        }
        else {
             self.tableView.showsInfiniteScrolling = NO;
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
//    [refreshControl setRefreshingWithStateOfTask:task];
}

//- (void)loadFromServer
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:[NSString stringWithFormat:@"http://api.example.com/list/%d", _currentPage] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        // if no more result
//        if ([[responseObject objectForKey:@"items"] count] == 0) {
//            self.tableView.showsInfiniteScrolling = NO; // stop the infinite scroll
//            return;
//        }
//        
//        _currentPage++; // increase the page number
//        int currentRow = [_myList count]; // keep the the index of last row before add new items into the list
//        
//        // store the items into the existing list
//        for (id obj in [responseObject valueForKey:@"items"]) {
//            [_myList addObject:obj];
//        }
//        [self reloadTableView:currentRow];
//        
//        // clear the pull to refresh & infinite scroll, this 2 lines very important
//        [self.tableView.pullToRefreshView stopAnimating];
//        [self.tableView.infiniteScrollingView stopAnimating];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        self.tableView.showsInfiniteScrolling = NO;
//        NSLog(@"error %@", error);
//    }];
//}

- (void)reloadTableView:(int)startingRow;
{
    // the last row after added new items
    NSUInteger endingRow = [self.restaurants count];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (; startingRow < endingRow; startingRow++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:startingRow inSection:0]];
    }
    
    
    [UIView setAnimationsEnabled:NO];
    [self.tableView beginUpdates];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView endUpdates];
    [UIView setAnimationsEnabled:YES];
//    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}


- (IBAction)onButtonBack:(id)sender {
    NSUInteger numberOfViewControllersOnStack = [self.navigationController.viewControllers count];
    UIViewController *parentViewController = self.navigationController.viewControllers[numberOfViewControllersOnStack - 2];
    Class parentVCClass = [parentViewController class];
    NSString *className = NSStringFromClass(parentVCClass);
    
    if([className isEqualToString:@"CategoriesViewController" ]) {
        [[[Filters getInstance] selectedTypes] removeAllObjects];
        [[[Filters getInstance] selectedCuisines] removeAllObjects];
        [[[Filters getInstance] selectedAverages] removeAllObjects];
        [[[Filters getInstance] selectedMetro] removeAllObjects];
        [[[Filters getInstance] selectedFeatures] removeAllObjects];
        [[Filters getInstance]  setCategoryId:@""];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(__unused NSInteger)section {
    return (NSInteger)[self.restaurants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"restaurantsViewCell";
    
    RestaurantsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[RestaurantsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.imageViewBackground.image = nil;
    [cell setRestaurant:[self.restaurants objectAtIndex:(NSUInteger) indexPath.row]];
    cell.labelDistance.text = @"";
    
    
    NSArray* addresses = cell.restaurantInfo.addresses;
    if([addresses count]) {
        Addresses* address = [addresses objectAtIndex:0];
        CLLocationCoordinate2D _mylocation = [[MapsInstance getInstance] getMyLocation];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [address.lat doubleValue];
        coordinate.longitude =  [address.lon doubleValue];
        CLLocationDistance distance =  GMSGeometryDistance(_mylocation, coordinate);
        distance = distance / 1000;
        NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
        [fmt setPositiveFormat:@"0.#"];
        NSString* format = [ NSString stringWithFormat:@"%@ км", [fmt stringFromNumber:[NSNumber numberWithFloat:distance]]];
        cell.labelDistance.text = format;
    }
    else {
        cell.labelDistance.text = @"...";
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Restaurants *category = [self.restaurants objectAtIndex:(NSUInteger)indexPath.row];
    [self performSegueWithIdentifier:@"SegueRestaurantsDetail" sender:category];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SegueRestaurantsDetail"])
    {
        RestaurantsDetailViewController *controller = segue.destinationViewController;
        controller.restaurants = (Restaurants *)sender;
    }
    else if([segue.identifier isEqualToString:@"MapsSegue"]) {
        MapsViewController *controller = segue.destinationViewController;
        controller.restaurants = self.restaurants;
    }

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
