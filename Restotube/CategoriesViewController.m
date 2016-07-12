//
//  CategoriesViewController.m
//  Restotube
//
//  Created by Maksim Kis on 04.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "CategoriesViewController.h"
#import "RequestManager.h"
#import "Categories.h"
#import <Availability.h>
#import <UIKit/UIKit.h>
#import "UIRefreshControl+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#import "CategoriesViewCell.h"
#import "RestaurantsViewController.h"
#import "Filters.h"
#import "UISearchBar+CustomBackGround.h"
#import "ConstantsManager.h"
#import "NearMeViewController.h"

@interface CategoriesViewController ()
@property (readwrite, nonatomic, strong) NSArray *categories;
@property (weak, nonatomic) IBOutlet UIButton *buttonFilter;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation CategoriesViewController

- (void)reload:(__unused id)sender {
    
    if ([[ConstantsManager getInstance].city isEqualToString:@"moscow"])
    {
        _topLabel.text = @"Рестораны Москвы";
    }
    else
    {
        _topLabel.text = @"Рестораны Сочи";
    }
    
    CGFloat scaleFactor=[[UIScreen mainScreen] scale];
    
    float height = 200 * scaleFactor;
    float width  = [[UIScreen mainScreen] applicationFrame].size.width * scaleFactor;

    NSURLSessionTask *task = [Categories categoriesWithBlock:width: height: ^(NSArray *categories, NSError *error) {
        if (!error) {
            self.categories = categories;
            [self.tableView reloadData];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    [refreshControl setRefreshingWithStateOfTask:task];
}

-(id)init {
    if (self = [super init]) {
        self.needsAuthOpen = NO;
        self.needsFiltersOpen = NO;
        self.needsProfileOpen = NO;
        self.needsReservationsOpen = NO;
    }
    
    return self;
}

-(void) viewDidLoad {
    [super viewDidLoad];

    refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"head-line"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTranslucent:false];
    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 1.0f);
    TopBorder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"divider-pink"]].CGColor;
    [self.imageHead.layer addSublayer:TopBorder];
    
    CALayer *BotBorder = [CALayer layer];
    BotBorder.frame = CGRectMake(0.0f, self.imageHead.frame.size.height - 1.5f, self.view.frame.size.width, 1.5f);
    BotBorder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"divider-pink"]].CGColor;
    [self.imageHead.layer addSublayer:BotBorder];
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"head-line"]]];
    [self.tableView setAllowsSelection:YES];
    [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed: @"restotube-logo"]]];
    [self reload:nil];
    
    [buttonMap setFrame: CGRectMake(buttonMap.bounds.origin.x, buttonMap.bounds.origin.y, 64, 64)];
//    self.needsNearOpen = YES;
}

-(void) viewDidAppear:(BOOL)animated {
    if(self.needsAuthOpen == YES) {
        [self performSegueWithIdentifier:@"authSegue" sender:nil];
        self.needsAuthOpen = NO;
    }
    if(self.needsFiltersOpen == YES) {
        [self performSegueWithIdentifier:@"filtersSegue" sender:nil];
        self.needsFiltersOpen = NO;
    }
    if(self.needsProfileOpen == YES) {
        [self performSegueWithIdentifier:@"ProfileSegue" sender:nil];
        self.needsProfileOpen = NO;
    }
    if(self.needsReservationsOpen == YES) {
        [self performSegueWithIdentifier:@"reservationsSegue" sender:nil];
        self.needsReservationsOpen = NO;
    }
    if(self.needsNearOpen == YES) {
        [self performSegueWithIdentifier:@"nearSegue" sender:nil];
        self.needsNearOpen = NO;
    }
    if(self.needsAboutOpen == YES) {
        [self performSegueWithIdentifier:@"aboutSegue" sender:nil];
        self.needsAboutOpen = NO;
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(__unused NSInteger)section {
    return (NSInteger)[self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CategoriesViewCell";
    
    CategoriesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[CategoriesViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.imageViewBackground.image = nil;
    cell.imageViewIcon.image = nil;
    cell.category = [self.categories objectAtIndex:(NSUInteger)indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Categories *category = [self.categories objectAtIndex:(NSUInteger)indexPath.row];
    [self performSegueWithIdentifier:@"SegueRestaurants" sender:category];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegueRestaurants"]) {
        Categories *category = (Categories *)sender;
        RestaurantsViewController *controller = (RestaurantsViewController *)segue.destinationViewController;
        controller.category = (Categories *)sender;
        
        [[Filters getInstance] setCategoryId:category.category_Id];
    }
    if ([segue.identifier isEqualToString:@"nearSegue"]) {
        NearMeViewController *controller = (NearMeViewController *)segue.destinationViewController;
        controller.needsGift = self.needsGift;
        controller.needsSale = self.needsSale;
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