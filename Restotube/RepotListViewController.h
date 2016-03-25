//
//  RepotListViewController.h
//  Restotube
//
//  Created by Andrey Rebrik on 15.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurants.h"
#import "ReviewTableViewCell.h"
#import "Reports.h"
#import <MWPhotoBrowser.h>

@interface RepotListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ReviewCellDelegate, MWPhotoBrowserDelegate>
{
    IBOutlet UITableView *reportsTable;
    
    IBOutlet UILabel *titleLabel;
    NSArray *reportsArray;
}

@property (nonatomic, strong) Restaurants *restaurant;

- (IBAction)sendReviewPressed:(id)sender;

@end
