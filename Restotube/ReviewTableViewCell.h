//
//  ReviewTableViewCell.h
//  Restotube
//
//  Created by Andrey Rebrik on 08.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "Reports.h"
#import "RWLabel.h"

@class ReviewTableViewCell;
@protocol ReviewCellDelegate <NSObject>
@optional
- (void) reviewCellLikePressed:(ReviewTableViewCell *)cell;
- (void) reviewCellCommentsPressed:(ReviewTableViewCell *)cell;
- (void) reviewCellAddCommentPressed:(ReviewTableViewCell *)cell;
- (void) reviewCellReadMorePressed:(ReviewTableViewCell *)cell;
- (void) reviewCellUserPressed:(ReviewTableViewCell *)cell;
- (void) reviewCellPhotoPressed:(ReviewTableViewCell *)cell;
@end

@interface ReviewTableViewCell : UITableViewCell <TTTAttributedLabelDelegate>
{
    IBOutlet NSLayoutConstraint *pictureWidth;
}

@property (nonatomic, unsafe_unretained) id <ReviewCellDelegate> delegate;

@property (nonatomic, strong) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, strong) IBOutlet UIImageView *pictureImageView;
@property (nonatomic, strong) IBOutlet RWLabel *userLabel;
@property (nonatomic, strong) IBOutlet RWLabel *reviewLabel;

@property (nonatomic, strong) IBOutlet TTTAttributedLabel *likesLabel;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *commentsLabel;
@property (nonatomic, strong) IBOutlet TTTAttributedLabel *addCommentLabel;

@property (nonatomic, strong) IBOutlet TTTAttributedLabel *readMoreLabel;

- (void)fillWithObject:(Reports *)object atIndexPath:(NSIndexPath *)indexPath;
- (IBAction)userPressed:(id)sender;
- (IBAction)photoPressed:(id)sender;

@end
