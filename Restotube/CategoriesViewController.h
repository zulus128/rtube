//
//  CategoriesViewController.h
//  Restotube
//
//  Created by Maksim Kis on 04.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoriesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITextFieldDelegate> {
    UIRefreshControl *refreshControl;
    __weak IBOutlet UIButton *buttonMap;
//    UISearchBar *sBar;
//    UISearchDisplayController *searchDisplayController;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageHead;
@property (nonatomic, assign) BOOL needsAuthOpen;
@property (nonatomic, assign) BOOL needsFiltersOpen;
@property (nonatomic, assign) BOOL needsProfileOpen;
@property (nonatomic, assign) BOOL needsReservationsOpen;
@property (nonatomic, assign) BOOL needsNearOpen;
@property (nonatomic, assign) BOOL needsSale;
@property (nonatomic, assign) BOOL needsGift;
@property (nonatomic, assign) BOOL needsAboutOpen;

- (void)reload:(__unused id)sender;
@end
