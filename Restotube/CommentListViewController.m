//
//  CommentListViewController.m
//  Restotube
//
//  Created by Andrey Rebrik on 15.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "CommentListViewController.h"
#import "AddCommentViewController.h"
#import "ReviewTableViewCell.h"
#import "Profile.h"
#import "RequestManager.h"

#define SYSTEM_VERSION                              ([[UIDevice currentDevice] systemVersion])
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS8_OR_ABOVE                            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))

@interface CommentListViewController()
//@property (nonatomic, strong) IBOutlet ReviewTableViewCell *prototypeCell;
@end


@implementation CommentListViewController
{
    __weak IBOutlet UIImageView *imageHead;
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
    [Reports reportsForRestaurant:_restaurant.restaurant_Id parentId:_parentReport.report_id photoSize:CGSizeZero withBlock:^(NSArray *reports, NSError *error)
     {
         if (!error)
         {
             reportsArray = [NSArray arrayWithArray:reports];
         }
         
         [reportsTable reloadData];
     }];
}

- (IBAction)onButtonBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendReviewPressed:(id)sender
{
    if ([[Profile getInstance] isProfileLoaded])
        [self performSegueWithIdentifier:@"AddCommentSegue" sender:nil];
    else
        [self performSegueWithIdentifier:@"AuthSegue" sender:nil];
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
    [cell fillWithObject:reportsArray[indexPath.row] atIndexPath:indexPath];
    [cell layoutIfNeeded];
    return cell;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // (6)
    if (IS_IOS8_OR_ABOVE) {
        return UITableViewAutomaticDimension;
    }
    
//    // (7)
//        self.prototypeCell.bounds = CGRectMake(0, 0, CGRectGetWidth(reportsTable.bounds), CGRectGetHeight(self.prototypeCell.bounds));
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

- (void)reviewCellUserPressed:(ReviewTableViewCell *)cell
{
    NSIndexPath *indexPath = [reportsTable indexPathForCell:cell];
    Reports *report = reportsArray[indexPath.row];
    
    if (report.user_social_url && ![report.user_social_url isEqualToString:@""])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[report.user_social_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddCommentSegue"])
    {
        AddCommentViewController *controller = (AddCommentViewController *)segue.destinationViewController;
        controller.restaurantId = _restaurant.restaurant_Id;
        controller.parentId = _parentReport.report_id;
    }
}

@end