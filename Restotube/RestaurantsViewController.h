//
//  RestaurantsViewController.h
//  Restotube
//
//  Created by Maksim Kis on 08.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Categories.h"

@interface RestaurantsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UIRefreshControl *refreshControl;
}

@property (nonatomic, strong) Categories *category;
@end
