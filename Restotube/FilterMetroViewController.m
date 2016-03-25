//
//  FilterMetroViewController.m
//  Restotube
//
//  Created by Maksim Kis on 09.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "FilterMetroViewController.h"
#import "RequestManager.h"
#import <Availability.h>
#import <UIKit/UIKit.h>
#import "UIRefreshControl+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#import "MetroViewCell.h"
#import "Filters.h"

@interface FilterMetroViewController ()
@property (readwrite, nonatomic, strong) NSArray *metro;

@end

@implementation FilterMetroViewController


- (void)reload:(__unused id)sender {
    NSURLSessionTask *task = [Metro metroWithBlock: ^(NSArray *metro, NSError *error) {
        if (!error) {
            self.metro = metro;
            [self.tableView reloadData];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    [self.refreshControl setRefreshingWithStateOfTask:task];
}

-(void) viewDidLoad {
    [self.tableView setAllowsSelection:YES];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed: @"restotube-logo"]]];
    [self reload:nil];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(__unused NSInteger)section {
    return (NSInteger)[self.metro count ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"metroViewCell";
    
    MetroViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MetroViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.metro = [self.metro objectAtIndex:(NSUInteger)indexPath.row];
    
    NSMutableArray* selectedMetroIds = [[Filters getInstance] selectedMetro];
    BOOL hidden = YES;
    for (int i = 0; i < [selectedMetroIds count]; i++) {
        FiltersSelected* selected = [selectedMetroIds objectAtIndex:(NSInteger)i];
        
        if([cell.metro.type_id isEqualToString:selected.selectedId]){
            hidden = NO;
            break;
        }
    }
    cell.imageSelected.hidden = hidden;
    if(hidden == YES)
        cell.textLabel.textColor = [UIColor blackColor];
    else {
        cell.textLabel.textColor = [UIColor colorWithRed:251/255.0f green:0 blue:83/255.0f alpha:1];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MetroViewCell* cel = (MetroViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cel.imageSelected.hidden = ! cel.imageSelected.hidden;
    
    
    if(cel.imageSelected.hidden == YES) {
        NSArray* selectedMetroIds = [[Filters getInstance] selectedMetro];
        NSUInteger selected_id = -1;
        for (int i = 0; i < [selectedMetroIds count]; i++) {
            FiltersSelected* array_selected = [selectedMetroIds objectAtIndex:(NSInteger)i];
            
            if([cel.metro.type_id isEqualToString:array_selected.selectedId]){
                selected_id = i;
                break;
            }
        }
        
        if(selected_id != -1) {
            [[[Filters getInstance] selectedMetro] removeObjectAtIndex:selected_id];
            cel.textLabel.textColor = [UIColor blackColor];
        }
    }
    else {
        FiltersSelected* selected = [[FiltersSelected alloc] init];
        selected.selectedId = cel.metro.type_id;
        selected.selectedName = cel.metro.name;
        [[[Filters getInstance] selectedMetro] addObject:selected];
         cel.textLabel.textColor = [UIColor colorWithRed:251/255.0f green:0 blue:83/255.0f alpha:1];
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"filterSelected"
     object:self];

    
}
@end
