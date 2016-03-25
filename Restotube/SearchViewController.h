//
//  SearchViewController.h
//  Restotube
//
//  Created by Maksim Kis on 16.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UITableViewController < UITextFieldDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate > {
    __weak IBOutlet UISearchBar *sBar;
    UISearchDisplayController *searchDisplayController;
    NSString *searchTextAPI;
}

@end
