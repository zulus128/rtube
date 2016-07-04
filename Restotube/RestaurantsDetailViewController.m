//
//  RestaurantsDetailViewController.m
//  Restotube
//
//  Created by Maksim Kis on 08.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "RestaurantsDetailViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GalleryCollectionViewCell.h"

#import "UIAlertView+AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "Profile.h"

#import "ReservationViewController.h"
#import "RepotListViewController.h"
#import "AddReportViewController.h"

#import "MainViewController.h"
#import "RequestManager.h"

#define TRY_ANIMATION_TIME 0.35

@interface RestaurantsDetailViewController()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tryImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tryImageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tryImageToTryText;
@property (weak, nonatomic) IBOutlet UIButton *likesButton;

@end

@implementation RestaurantsDetailViewController {
    __weak IBOutlet UIImageView *imageHead;
    BOOL isReviewsLoading;
    BOOL isInfoLoading;
    
    MWPhotoBrowser *galleryBrowser;
    MWPhotoBrowser *reviewBrowser;
    NSInteger reviewPhotoIndex;
    BOOL isLarge;
}

- (IBAction)tryImageClicked:(id)sender {
    if(!isLarge) {
        [self makeFull];
    } else {
        [self makeSmall];
    }
}

- (void)makeFull {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.tryImageWidth.constant = screenRect.size.width - 2 * 20;
    self.tryImageHeight.constant = screenRect.size.width - 2 * 20;
    self.tryImageToTryText.constant = -200;
    [UIView animateWithDuration:TRY_ANIMATION_TIME - 0.05
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         self->tryImageView.layer.cornerRadius = (screenRect.size.width - 2 * 20) / 2;
                         isLarge = YES;
                     }];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.duration = TRY_ANIMATION_TIME;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.toValue = @((screenRect.size.width - 2 * 20) / 2);
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    [self->tryImageView.layer addAnimation:animation forKey:@"setCornerRadius:"];
}

- (void)makeSmall {
    self.tryImageWidth.constant = 65;
    self.tryImageHeight.constant = 65;
    self.tryImageToTryText.constant = 0;
    [UIView animateWithDuration:TRY_ANIMATION_TIME - 0.05
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         self->tryImageView.layer.cornerRadius = 65 / 2;
                         isLarge = NO;
                     }];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.duration = TRY_ANIMATION_TIME;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.toValue = @(65 / 2);
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    [self->tryImageView.layer addAnimation:animation forKey:@"setCornerRadius1:"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 1.0f);
    TopBorder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"divider-pink"]].CGColor;
    [imageHead.layer addSublayer:TopBorder];
    
    CALayer *BotBorder = [CALayer layer];
    BotBorder.frame = CGRectMake(0.0f, imageHead.frame.size.height - 1.5f, self.view.frame.size.width, 1.5f);
    BotBorder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"divider-pink"]].CGColor;
    [imageHead.layer addSublayer:BotBorder];
  
    [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed: @"restotube-logo"]]];
    
    infoTitleLabel.text = _restaurants.name;
    likesLabel.text = [NSString stringWithFormat:@"%ld", (long)_restaurants.likes];
    viewsLabel.text = [NSString stringWithFormat:@"%ld", (long)_restaurants.views];
    _restaurants.sale = @"";
    
    //красивого решения не нашел, анимация для синхронизации
    [UIView animateWithDuration:0 animations:^{
        [infoTable reloadData];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0 animations:^{
            infoTableHeight.constant = infoTable.contentSize.height;
            [infoTable layoutIfNeeded];
        } completion:^(BOOL finished) {
            CGFloat constant =  bottomContainer.frame.size.height + bottomContainer.frame.origin.y;
            mainScroll.contentSize = CGSizeMake(mainScroll.frame.size.width, constant);
        }];
     }];
    
    isInfoLoading = NO;
    isReviewsLoading = NO;
    fadeView.hidden = NO;
    
//    NSLog(@"----- %@ %@", _restaurants, [Profile getInstance].m_hash);
    NSURLSessionTask *task = [_restaurants getFullInfoWithBlock:galleryView.frame.size.width :galleryView.frame.size.height :^(NSError *error)
    {
        if (!error)
        {
            [galleryView reloadData];
            likesLabel.text = [NSString stringWithFormat:@"%ld", (long)_restaurants.likes];
            viewsLabel.text = [NSString stringWithFormat:@"%ld", (long)_restaurants.views];
            averageCheckLabel.text = _restaurants.averages;
            
            addressLabel.text = [_restaurants addressListToText];
            
            CGRect textRect = [addressLabel.text boundingRectWithSize:CGSizeMake(addressLabel.frame.size.width, 99999)
                                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                  attributes:@{NSFontAttributeName:addressLabel.font}
                                                     context:nil];
            
            if (textRect.size.height <= addressLabel.frame.size.height && _restaurants.addresses.count < 2)
            {
                addressArrow.hidden = YES;
                addressButton.enabled = NO;
                
                [self addressPressed:nil];
            }
            
            featuresLabel.attributedText = [_restaurants featuresText];
            if ([_restaurants.sale isEqualToString:@""])
            {
                [UIView animateWithDuration:0 animations:^{
                    discountHeighConstraint.constant = 0;
                    discountContainer.hidden = YES;
                    [discountContainer layoutIfNeeded];
                } completion:^(BOOL finished) {
                    CGFloat constant =  bottomContainer.frame.size.height + bottomContainer.frame.origin.y;
                    mainScroll.contentSize = CGSizeMake(mainScroll.frame.size.width, constant);
                }];
            }
            else
                discountLabel.text = _restaurants.sale;

            tryLabel.text = _restaurants.try_;
            tryCostLabel.text = [NSString stringWithFormat:@"%@ руб.", _restaurants.try_cost];
            tryImageView.layer.masksToBounds = YES;
            tryImageView.layer.cornerRadius = tryImageView.frame.size.width/2;
           
            __weak UIImageView *weakImageView = tryImageView;
            NSURL *assetsBaseUrl = [RequestManager sharedManager].assetsBaseUrl;
            NSURL *imageUrl = [[NSURL alloc] initWithString:_restaurants.try_image relativeToURL:assetsBaseUrl];
            NSURLRequest* req_bg = [NSURLRequest requestWithURL:imageUrl];
            [tryImageView setImageWithURLRequest:req_bg
                                placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
             {
                 UIImageView *strongImageView = weakImageView;
                 if (!strongImageView) return;
                 strongImageView.image = image;
             }
                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
             {
                 NSLog(@"error10: %@", error);
             }];
        }
        
        [_restaurants getHiResPhotosWithBlock:self.view.frame.size.height :self.view.frame.size.width :^(NSError *error)
        {
            isInfoLoading = NO;
            if (!isReviewsLoading)
                fadeView.hidden = YES;
        }];
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    
//    NSString* urlrequest = [NSString stringWithFormat:@"book"];
//    
//    return [[RequestManager sharedManager] GET:urlrequest parameters:params success:^(NSURLSessionDataTask * __unused task, id JSON)
//            {
//                // TODO: remove this, server must send non-200 response
//                if (JSON[@"errors"]) {
//                    if (block) block(nil, [NSError errorWithDomain:@"ApiError" code:0 userInfo:JSON]);
//                    return;
//                }
//                Reservation *reservation = [[Reservation alloc] initWithAttributes:(NSDictionary *)JSON];
//                
//                if (block) block(reservation, nil);
//            }
//                                       failure:^(NSURLSessionDataTask *__unused task, NSError *error)
//            {
//                if (block) block(nil, error);
//            }];
    
    [self setLikeColor];
}

- (void)setLikeColor {
    NSString* urlrequest = [NSString stringWithFormat:@"isUserSetRestLike?rest_id=%@&hash=%@", _restaurants.restaurant_Id, [Profile getInstance].m_hash ? [Profile getInstance].m_hash : @""];
    [[RequestManager sharedManager] GET:urlrequest parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON)
     {
//         NSLog(@"--- Success: %@", JSON);
         if ([JSON valueForKey:@"ok"] && [[JSON valueForKey:@"ok"] intValue]) {
             [self.likesButton setSelected:YES];
         }

     } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
//         NSLog(@"--- Error: %@", error);
     }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat constant =  bottomContainer.frame.size.height + bottomContainer.frame.origin.y;
    mainScroll.contentSize = CGSizeMake(mainScroll.frame.size.width, constant);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    MainViewController *rootController =(MainViewController*)[[[[UIApplication sharedApplication]delegate] window] rootViewController];
    rootController.backgroundImage = [UIImage imageNamed:@"background"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [Reports reportsForRestaurant:_restaurants.restaurant_Id parentId:nil photoSize:CGSizeZero withBlock:^(NSArray *restaurants, NSError *error)
     {
         if (!error)
         {
             reportsArray = [NSArray arrayWithArray:restaurants];
         }
         
         [UIView animateWithDuration:0 animations:^{
             [infoTable reloadData];
         } completion:^(BOOL finished) {
             
             [UIView animateWithDuration:0 animations:^{
                 infoTableHeight.constant = infoTable.contentSize.height;
                 [infoTable layoutIfNeeded];
             } completion:^(BOOL finished) {
                 CGFloat constant =  bottomContainer.frame.size.height + bottomContainer.frame.origin.y;
                 mainScroll.contentSize = CGSizeMake(mainScroll.frame.size.width, constant);
             }];
             
         }];
         
         [Reports reportsForRestaurant:_restaurants.restaurant_Id parentId:nil photoSize:CGSizeMake(self.view.frame.size.height, self.view.frame.size.width) withBlock:^(NSArray *hiRezreports, NSError *error)
          {
              if (!error)
              {
                  for (Reports * report in reportsArray)
                  {
                      for (Reports *hiRezReport in hiRezreports)
                      {
                          if ([report.report_id isEqualToString: hiRezReport.report_id])
                          {
                              report.hiRezPhoto = hiRezReport.img;
                              break;
                          }
                      }
                  }
              }
              
              isReviewsLoading = NO;
              if (!isInfoLoading)
                  fadeView.hidden = YES;
          }];
     }];
}


#pragma mark - MWPhotoBrowser Delegate/DataSource


- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    if (photoBrowser == galleryBrowser)
        return self.restaurants.hiResPhotos.count;
    else
        return 1;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    NSURL *assetsBaseUrl = [RequestManager sharedManager].assetsBaseUrl;
    if (photoBrowser == galleryBrowser)
    {
        if (index < self.restaurants.hiResPhotos.count)
            return  [MWPhoto photoWithURL:[NSURL URLWithString:[self.restaurants.hiResPhotos objectAtIndex:index] relativeToURL:assetsBaseUrl]];
    }
    else
    {
        Reports *report = reportsArray[reviewPhotoIndex];
        return  [MWPhoto photoWithURL:[NSURL URLWithString:report.hiRezPhoto relativeToURL:assetsBaseUrl]];
    }
    
    return nil;
}


#pragma mark - TableView Delegate/DataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (reportsArray && reportsArray.count > 0)
        return reportsArray.count > 1 ? 2 : 1;
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifire;
    
    if (reportsArray && reportsArray.count > 0)
    {
        identifire = @"ReviewCell";
        Reports *report = reportsArray[indexPath.row];
        
        ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire forIndexPath:indexPath];
        
        if (report)
        {
            [cell fillWithObject:report atIndexPath:indexPath];
            cell.delegate = self;
        }
        
        return cell;
    }
    else
    {
        identifire = @"EmptyReviewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire forIndexPath:indexPath];
        
        return cell;
    }
}

- (void)reviewCellPhotoPressed:(ReviewTableViewCell *)cell
{
    NSIndexPath *indexPath = [infoTable indexPathForCell:cell];
    reviewPhotoIndex = indexPath.row;
    
    reviewBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    reviewBrowser.displayActionButton = NO; // Show action button to allow sharing, copying, etc (defaults to YES)
    reviewBrowser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    reviewBrowser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    reviewBrowser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    reviewBrowser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    reviewBrowser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    reviewBrowser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    // Present
    [self.navigationController pushViewController:reviewBrowser animated:YES];
}

- (void)reviewCellReadMorePressed:(ReviewTableViewCell *)cell
{
    [self performSegueWithIdentifier:@"ReportListSegue" sender:nil];
}

- (void)reviewCellUserPressed:(ReviewTableViewCell *)cell
{
    NSIndexPath *indexPath = [infoTable indexPathForCell:cell];
    Reports *report = reportsArray[indexPath.row];
    
    if (report.user_social_url && ![report.user_social_url isEqualToString:@""])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[report.user_social_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.frame.size;
}

//Галерея
#pragma mark - CollectionView Delegate/DataSource


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = _restaurants.images.count;
    if (_restaurants.video.count > 0)
        count++;
    
    galleryPager.numberOfPages = count;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifire = @"videoCVCell";
    GalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifire forIndexPath:indexPath];
    
    NSString *imgPath;
    
    if (_restaurants.video.count > 0)
    {
        if (indexPath.row == 0)
            imgPath = _restaurants.video_img;
        else
            imgPath =_restaurants.images[indexPath.row - 1];
    }
    else
        imgPath =_restaurants.images[indexPath.row];

    [cell fillWithImage:imgPath atIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0)
    {
        galleryBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        
        // Set options
        galleryBrowser.displayActionButton = NO; // Show action button to allow sharing, copying, etc (defaults to YES)
        galleryBrowser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
        galleryBrowser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
        galleryBrowser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
        galleryBrowser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
        galleryBrowser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
        galleryBrowser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
//        browser.wantsFullScreenLayout = YES; // iOS 5 & 6 only: Decide if you want the photo browser full screen, i.e. whether the status bar is affected (defaults to YES)
        
        // Optionally set the current visible photo before displaying
        [galleryBrowser setCurrentPhotoIndex:1];
        
        // Present
        [self.navigationController pushViewController:galleryBrowser animated:YES];
        
        // Manipulate
        [galleryBrowser showNextPhotoAnimated:NO];
        [galleryBrowser showPreviousPhotoAnimated:NO];
        [galleryBrowser setCurrentPhotoIndex:indexPath.row - 1];
    }
}

#pragma mark - ScrollView Delegate


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == galleryView)
        galleryPager.currentPage = galleryView.contentOffset.x / galleryView.frame.size.width;;
}


#pragma mark - Actions


- (void)sendReviewPressed:(id)sender
{
    if ([[Profile getInstance] isProfileLoaded])
        [self performSegueWithIdentifier:@"AddReportSegue" sender:nil];
    else
        [self performSegueWithIdentifier:@"AuthSegue" sender:nil];
}

- (void)sendErrorPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://info@restotube.ru"]];
}

- (void)phoneCallPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://84955170343"]];
}

- (void)sharePressed:(UIButton *)sender
{
    NSString *shareString;
    if (sender.tag == 0)// facebook
        shareString =[_restaurants.fb_share stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    else //vk
        shareString =[_restaurants.vk_share stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:shareString]];
}

- (void)playVideoPressed:(UIButton *)sender
{
    NSString *path;
    
    for (Video *video in _restaurants.video)
    {
        if (video.dur == 720)
        {
            path = video.file;
            break;
        }
        
        path = video.file;
    }
    
    if (!path || [path isEqualToString:@""])
        return;

    NSURL *assetsBaseUrl = [RequestManager sharedManager].assetsBaseUrl;
    NSURL *movieURL = [[NSURL alloc] initWithString:path relativeToURL:assetsBaseUrl];
    
    _galleryPlayer = [[MPMoviePlayerViewController alloc] init];
    _galleryPlayer.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    _galleryPlayer.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    _galleryPlayer.moviePlayer.shouldAutoplay = YES;
    [_galleryPlayer.moviePlayer setContentURL:movieURL];
    
    MainViewController *rootController =(MainViewController*)[[[[UIApplication sharedApplication]delegate] window] rootViewController];
    rootController.backgroundImage = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    [self presentMoviePlayerViewControllerAnimated:_galleryPlayer];
}

- (void)moviePlayBackDidFinish:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
    
    [self dismissMoviePlayerViewControllerAnimated];
}

- (void)addressPressed:(id)sender
{
    addressLabel.numberOfLines = addressLabel.numberOfLines == 0 ? 1 : 0;
    
    [UIView animateWithDuration:0 animations:^{
        [addressLabel layoutIfNeeded];
    } completion:^(BOOL finished) {
        CGFloat constant =  bottomContainer.frame.size.height + bottomContainer.frame.origin.y;
        mainScroll.contentSize = CGSizeMake(mainScroll.frame.size.width, constant);
    }];
    
    [UIView animateWithDuration:0.3f animations:^{
        
        if (addressLabel.numberOfLines == 0)
            addressArrow.transform = CGAffineTransformMakeRotation(M_PI/2);
        else
            addressArrow.transform = CGAffineTransformMakeRotation(0);
    } completion:nil];
}

- (void)featuresPressed:(id)sender
{
    featuresLabel.numberOfLines = featuresLabel.numberOfLines == 0 ? 1 : 0;
    
    [UIView animateWithDuration:0 animations:^{
    [featuresLabel layoutIfNeeded];
    } completion:^(BOOL finished) {
        CGFloat constant =  bottomContainer.frame.size.height + bottomContainer.frame.origin.y;
        mainScroll.contentSize = CGSizeMake(mainScroll.frame.size.width, constant);
    }];

    [UIView animateWithDuration:0.3f animations:^{
        if (featuresLabel.numberOfLines == 0)
            featuresArrow.transform = CGAffineTransformMakeRotation(M_PI/2);
        else
            featuresArrow.transform = CGAffineTransformMakeRotation(0);
    } completion:nil];
}

- (void)likePressed:(id)sender
{
    [self.restaurants likeRestaurantForUser:[Profile getInstance].m_hash withCompletion:^(NSError *error) {
        likesLabel.text = [NSString stringWithFormat:@"%ld", (long)_restaurants.likes];
        [self.likesButton setSelected:YES];
    }];
}

- (IBAction)onButtonBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ReservationSegue"])
    {
        ReservationViewController *controller = (ReservationViewController *)segue.destinationViewController;
        controller.restaurant = _restaurants;
    }
    else if ([segue.identifier isEqualToString:@"ReportListSegue"])
    {
        RepotListViewController *controller = (RepotListViewController *)segue.destinationViewController;
        controller.restaurant = _restaurants;
    }
    else if ([segue.identifier isEqualToString:@"AddReportSegue"])
    {
        AddReportViewController *controller = (AddReportViewController *)segue.destinationViewController;
        controller.restaurantId = _restaurants.restaurant_Id;
    }
}

@end