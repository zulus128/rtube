//
//  RestaurantsDetailViewController.h
//  Restotube
//
//  Created by Maksim Kis on 08.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Restaurants.h"
#import "Reports.h"
#import "ReviewTableViewCell.h"
#import "MWPhotoBrowser.h"

@interface RestaurantsDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, ReviewCellDelegate, MWPhotoBrowserDelegate>
{
    IBOutlet UIScrollView *mainScroll;
    
    IBOutlet UILabel *infoTitleLabel;
    IBOutlet UITableView *infoTable;
    IBOutlet NSLayoutConstraint *infoTableHeight;
    
    IBOutlet UIView *topContainer;
    IBOutlet NSLayoutConstraint *topContainerHeight;
    
    IBOutlet UICollectionView *galleryView;
    IBOutlet UIPageControl *galleryPager;
    
    IBOutlet UILabel *viewsLabel;
    IBOutlet UILabel *likesLabel;
    
    IBOutlet UILabel *discountLabel;
    IBOutlet NSLayoutConstraint *discountHeighConstraint;
    IBOutlet UIView *discountContainer;
    
    IBOutlet UILabel *averageCheckLabel;
    
    IBOutlet NSLayoutConstraint *workTimeHeightConstraint;
    IBOutlet UIView *workTimeContainer;
    IBOutlet NSLayoutConstraint *addressHeighConstraint;
    IBOutlet UIView *addressContainer;
    
    IBOutlet UILabel *tryLabel;
    IBOutlet UIImageView *tryImageView;
    IBOutlet UILabel *tryCostLabel;
    
    IBOutlet UILabel *addressLabel;
    IBOutlet UIImageView *addressArrow;

    IBOutlet UILabel *featuresLabel;
    IBOutlet UIImageView *featuresArrow;
    
    IBOutlet UILabel *reviewLabel;
    
    IBOutlet UIView *bottomContainer;
    
    IBOutlet UIButton *addressButton;
    
    NSArray *reportsArray;
    
    IBOutlet UIView *fadeView;
}

@property (nonatomic, readonly) MPMoviePlayerViewController *galleryPlayer;
@property (nonatomic, strong) Restaurants *restaurants;
@property (assign, readwrite) NSInteger currentAddress;

- (IBAction)sendReviewPressed:(id)sender;
- (IBAction)sendErrorPressed:(id)sender;
- (IBAction)phoneCallPressed:(id)sender;
- (IBAction)sharePressed:(id)sender;
- (IBAction)likePressed:(id)sender;
- (IBAction)playVideoPressed:(id)sender;

- (IBAction)addressPressed:(id)sender;
- (IBAction)featuresPressed:(id)sender;

@end
