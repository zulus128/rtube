//
//  SearchViewController.m
//  Restotube
//
//  Created by Maksim Kis on 16.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "Restaurants.h"
#import <UIKit/UIKit.h>
#import "UIRefreshControl+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#import "RestaurantsDetailViewController.h"
#import "Filters.h"

@interface SearchViewController ()
@property (readwrite, nonatomic, strong) NSArray *searchResults;

@end

@implementation SearchViewController

- (void)reload:(__unused id)sender {
    [[Filters getInstance] setSearchText:searchTextAPI];
    NSURLSessionTask *task = [Restaurants restaurantsSearchWithBlock: ^(NSArray *restaurants, NSError *error) {
        if (!error) {
            self.searchResults = restaurants;
            [self.searchDisplayController.searchResultsTableView reloadData];
             [self.tableView reloadData];
        }
        
          [[Filters getInstance] setSearchText:@""];
    }];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    [self.refreshControl setRefreshingWithStateOfTask:task];
}

-(void) viewDidLoad {
    searchTextAPI = @"";
    self.searchResults = [[NSArray alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"head-line"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTranslucent:false];
    [self.tableView setAllowsSelection:YES];
    [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed: @"restotube-logo"]]];
    
    sBar.placeholder = @"Поиск";
    sBar.delegate = self;
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:sBar contentsController:self];
    
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self.tableView.dataSource;
    searchDisplayController.searchResultsDelegate = self.tableView.delegate;
    
    self.tableView.tableHeaderView = sBar;
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResults count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"searchTableViewCell";
    SearchTableViewCell *cell = nil;

    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Restaurants* rest = [self.searchResults objectAtIndex:indexPath.row];

    cell.textLabel.text =  rest.name;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-next"]];
    
    cell.accessoryView = imageView;

    return cell;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchTextAPI = searchText;
    [self reload:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Restaurants *category = [self.searchResults objectAtIndex:(NSUInteger)indexPath.row];
    [self performSegueWithIdentifier:@"restaurantsDetailSegue" sender:category];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"restaurantsDetailSegue"])
    {
        RestaurantsDetailViewController *controller = (RestaurantsDetailViewController *)segue.destinationViewController;
        controller.restaurants = (Restaurants *)sender;
    }
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    if (self.tableView != self.searchDisplayController.searchBar.superview) {
        [self.tableView insertSubview:self.searchDisplayController.searchBar aboveSubview:self.tableView];
    }
}




@end
/*restaurantsDetailSegue*/