//
//  FilterViewController.m
//  Restotube
//
//  Created by Maksim Kis on 07.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterButtonsViewCell.h"
#import "FilterViewCell.h"
#import "Filters.h"

@interface FilterViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FilterButtonsViewCell *cellbuttons;
@end

@implementation FilterViewController

-(void) viewDidLoad {
    [self.navigationController.navigationBar setTranslucent:false];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"filterReset"
     object:self];
}

- (IBAction)onReset:(id)sender {
    [self.cellbuttons reset];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"filterReset"
     object:self];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(__unused NSInteger)section {
    return 5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            return 250;
        }
        default: {
            return 44;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            if (self.cellbuttons == nil) {
                [self setCellbuttons:(FilterButtonsViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"filterButtonsViewCell"]];
            }
            return self.cellbuttons;
        }break;
        case 1: {
            FilterViewCell* cell = (FilterViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"whereViewCell"];

            return cell;
            
        }break;
        case 2: {
            FilterViewCell* cell = (FilterViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"eatViewCell"];

            return cell;
        }break;
        case 3: {
            FilterViewCell* cell = (FilterViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"averageViewCell"];

            return cell;
        }break;
        case 4: {
            FilterViewCell* cell = (FilterViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"metroViewCell"];

            return cell;
        }break;
            
        default: {
            return nil;
        }
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1: {
            [self performSegueWithIdentifier:@"segueWhere" sender:nil];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }break;
        case 2: {
            [self performSegueWithIdentifier:@"segueEat" sender:nil];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }break;
        case 3: {
            [self performSegueWithIdentifier:@"segueAverage" sender:nil];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }break;
        case 4: {
            [self performSegueWithIdentifier:@"segueMetro" sender:nil];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }break;
            
            
        default:
            break;
    }

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end

