//
//  RepotListViewController.m
//  Restotube
//
//  Created by Andrey Rebrik on 15.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "RepotListViewController.h"

#import "CommentListViewController.h"
#import "AddCommentViewController.h"
#import "AddReportViewController.h"
#import "Profile.h"
#import "RequestManager.h"

#define SYSTEM_VERSION                              ([[UIDevice currentDevice] systemVersion])
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS8_OR_ABOVE                            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))


@interface RepotListViewController ()
//@property (nonatomic, strong) ReviewTableViewCell *prototypeCell;
@end

@implementation RepotListViewController
{
    __weak IBOutlet UIImageView *imageHead;
    
    NSInteger photoIndex;
}

- (void) viewDidLoad
{
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
    
    titleLabel.text = _restaurant.name;
    
    reportsTable.estimatedRowHeight = 999;
    reportsTable.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Reports reportsForRestaurant:_restaurant.restaurant_Id parentId:nil photoSize:CGSizeZero withBlock:^(NSArray *reports, NSError *error)
     {
         if (!error)
         {
             reportsArray = [NSArray arrayWithArray:reports];
         }
         
         [reportsTable reloadData];
         
         [Reports reportsForRestaurant:_restaurant.restaurant_Id parentId:nil photoSize:CGSizeMake(self.view.frame.size.height, self.view.frame.size.width) withBlock:^(NSArray *hiRezreports, NSError *error)
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
          }];
     }];
}

- (IBAction)onButtonBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendReviewPressed:(id)sender
{
    if ([[Profile getInstance] isProfileLoaded])
        [self performSegueWithIdentifier:@"AddReportSegue" sender:nil];
    else
        [self performSegueWithIdentifier:@"AuthSegue" sender:nil];
}


#pragma mark - MWPhotoBrowser Delegate/DataSource


- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return 1;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    Reports *report = reportsArray[photoIndex];
    NSURL *assetsBaseUrl = [RequestManager sharedManager].assetsBaseUrl;
    NSURL *photoUrl = [NSURL URLWithString:report.hiRezPhoto relativeToURL:assetsBaseUrl];
    return [MWPhoto photoWithURL:photoUrl];

    return nil;
}



#pragma mark - TableView Delegate/DataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (reportsArray)
        return reportsArray.count;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifire = @"ReviewCell";
    ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire forIndexPath:indexPath];
    cell.delegate = self;
    [cell fillWithObject:reportsArray[indexPath.row] atIndexPath:indexPath];
    
    [cell layoutIfNeeded];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // (6)
    if (IS_IOS8_OR_ABOVE) {
        return UITableViewAutomaticDimension;
    }
    
//    // (7)
////    self.prototypeCell.bounds = CGRectMake(0, 0, CGRectGetWidth(reportsTable.bounds), CGRectGetHeight(self.prototypeCell.bounds));
//    
//    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
//    
//    // (8)
//    [self.prototypeCell updateConstraintsIfNeeded];
//    [self.prototypeCell layoutIfNeeded];
//    
//    // (9)
//    return [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;//self.prototypeCell.contentView.frame.size.height + 1;//
    return [self heightForBasicCellAtIndexPath:indexPath];
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static ReviewTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [reportsTable dequeueReusableCellWithIdentifier:@"ReviewCell"];
    });
    
    [self configureCell:sizingCell forRowAtIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(reportsTable.frame), CGRectGetHeight(sizingCell.bounds));
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

//- (ReviewTableViewCell *)prototypeCell
//{
//    if (!_prototypeCell) {
//        _prototypeCell = [reportsTable dequeueReusableCellWithIdentifier:@"PrototypeCell"];
//    }
//    
//    return _prototypeCell;
//}

- (void)configureCell:(ReviewTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell fillWithObject:reportsArray[indexPath.row] atIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *identifire = @"headerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)reviewCellAddCommentPressed:(ReviewTableViewCell *)cell
{
    NSIndexPath *indexPath = [reportsTable indexPathForCell:cell];
    Reports *report = reportsArray[indexPath.row];
    
    if ([[Profile getInstance] isProfileLoaded])
        [self performSegueWithIdentifier:@"AddCommentSegue" sender:report];
    else
        [self performSegueWithIdentifier:@"AuthSegue" sender:nil];
}

-(void)reviewCellCommentsPressed:(ReviewTableViewCell *)cell
{
    NSIndexPath *indexPath = [reportsTable indexPathForCell:cell];
    Reports *report = reportsArray[indexPath.row];
    
    [self performSegueWithIdentifier:@"CommentListSegue" sender:report];
}

- (void)reviewCellLikePressed:(ReviewTableViewCell *)cell
{
    NSIndexPath *indexPath = [reportsTable indexPathForCell:cell];
    Reports *report = reportsArray[indexPath.row];
    
    [report likeReportForUser:[Profile getInstance].m_hash withCompletion:^(NSError *error) {
        if (!error)
        {
            [reportsTable reloadData];
        }
    }];
}

- (void)reviewCellUserPressed:(ReviewTableViewCell *)cell
{
    NSIndexPath *indexPath = [reportsTable indexPathForCell:cell];
    Reports *report = reportsArray[indexPath.row];
    
    if (report.user_social_url && ![report.user_social_url isEqualToString:@""])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[report.user_social_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
}

- (void)reviewCellPhotoPressed:(ReviewTableViewCell *)cell
{
    NSIndexPath *indexPath = [reportsTable indexPathForCell:cell];
    photoIndex = indexPath.row;
    
    MWPhotoBrowser *reviewBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
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


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CommentListSegue"])
    {
        CommentListViewController *controller = (CommentListViewController *)segue.destinationViewController;
        controller.restaurant = _restaurant;
        controller.parentReport = (Reports *)sender;
    }
    else if ([segue.identifier isEqualToString:@"AddCommentSegue"])
    {
        AddCommentViewController *controller = (AddCommentViewController *)segue.destinationViewController;
        controller.restaurantId = _restaurant.restaurant_Id;
        controller.parentId = ((Reports *)sender).report_id;
    }
    else if ([segue.identifier isEqualToString:@"AddReportSegue"])
    {
        AddReportViewController *controller = (AddReportViewController *)segue.destinationViewController;
        controller.restaurantId = _restaurant.restaurant_Id;
    }
}

@end