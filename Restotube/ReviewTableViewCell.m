//
//  ReviewTableViewCell.m
//  Restotube
//
//  Created by Andrey Rebrik on 08.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "ReviewTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "RequestManager.h"

@implementation ReviewTableViewCell

- (void)createLinkToLAbel:(TTTAttributedLabel *)label fromWord:(NSString*)word withColor:(UIColor*)color atRange:(NSRange)range
{
   // NSMutableAttributedString* newTextWithLinks = [label.attributedText mutableCopy];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.%@", word]];
    
    NSArray *keys = [[NSArray alloc] initWithObjects:(id)kCTForegroundColorAttributeName,(id)kCTUnderlineStyleAttributeName
                     , nil];
    NSArray *objects = [[NSArray alloc] initWithObjects:color, [NSNumber numberWithInt:NSUnderlineStyleSingle], nil];
    NSDictionary *linkAttributes = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    label.linkAttributes = linkAttributes;
    
    [label addLinkToURL:url withRange:range];
}

- (void)fillWithObject:(Reports *)object atIndexPath:(NSIndexPath *)indexPath
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:object.created];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMMM yyyy"];
    self.userLabel.text = [NSString stringWithFormat:@"%@\n%@", object.user_name, [formatter stringFromDate:date]];
    self.reviewLabel.text = object.reportText;
    
    if (self.likesLabel)
    {
        NSString *likesString = [NSString stringWithFormat:@"%ld Нравится", (long)object.likes];
        [self.likesLabel setText:likesString
                         afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
         {
             return mutableAttributedString;
         }];
        NSRange strikeRange = [likesString rangeOfString:@"Нравится" options:NSCaseInsensitiveSearch];
        [self createLinkToLAbel:self.likesLabel fromWord:@"Нравится" withColor:[UIColor colorWithRed:204.0f/255.0f green:50.0f/255.0f blue:101.0f/255.0f alpha:1.0f] atRange:strikeRange];
        self.likesLabel.delegate = self;
    }
    
    if (self.commentsLabel)
    {
        NSString *commentsString = [NSString stringWithFormat:@"%ld Комментариев", (long)object.childs_count];
        [self.commentsLabel setText:commentsString
            afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
         {
             return mutableAttributedString;
         }];
        NSRange strikeRange = [commentsString rangeOfString:@"Комментариев" options:NSCaseInsensitiveSearch];
        [self createLinkToLAbel:self.commentsLabel fromWord:@"Комментариев" withColor:[UIColor colorWithRed:204.0f/255.0f green:50.0f/255.0f blue:101.0f/255.0f alpha:1.0f] atRange:strikeRange];
        self.commentsLabel.delegate = self;
    }
    
    if (self.addCommentLabel)
    {
        NSString *addCommentString = @"Комментировать";
        [self.addCommentLabel setText:addCommentString
                              afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
         {
             return mutableAttributedString;
         }];
        NSRange strikeRange = [addCommentString rangeOfString:addCommentString options:NSCaseInsensitiveSearch];
        [self createLinkToLAbel:self.addCommentLabel fromWord:addCommentString withColor:[UIColor colorWithRed:204.0f/255.0f green:50.0f/255.0f blue:101.0f/255.0f alpha:1.0f] atRange:strikeRange];
        self.addCommentLabel.delegate = self;
    }
    
    if (self.readMoreLabel)
    {
        NSString *readMoreString = @"Читать далее...";
        [self.readMoreLabel setText:readMoreString
            afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
         {
             return mutableAttributedString;
         }];
        NSRange strikeRange = [readMoreString rangeOfString:readMoreString options:NSCaseInsensitiveSearch];
        [self createLinkToLAbel:self.readMoreLabel fromWord:readMoreString withColor:[UIColor colorWithRed:204.0f/255.0f green:50.0f/255.0f blue:101.0f/255.0f alpha:1.0f] atRange:strikeRange];
        self.readMoreLabel.delegate = self;
    }

    if (object.avatar && ![object.avatar isEqualToString:@""])
    {
        self.avatarImageView.image = nil;
        self.avatarImageView.layer.masksToBounds = YES;
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width/2;

        NSURL *assetsBaseUrl = [RequestManager sharedManager].assetsBaseUrl;
        NSURL *avatarUrl = [[NSURL alloc] initWithString:object.avatar relativeToURL:assetsBaseUrl];
        NSURLRequest* avatarRequest = [NSURLRequest requestWithURL:avatarUrl];

        __weak UIImageView *weakAvatarImageView = self.avatarImageView;
        
        [self.avatarImageView setImageWithURLRequest:avatarRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
         {
             UIImageView *strongImageView = weakAvatarImageView;
             if (!strongImageView) return;
             
             [UIView transitionWithView:strongImageView
                               duration:0.3
                                options:UIViewAnimationOptionTransitionCrossDissolve
                             animations:^{
                                 strongImageView.image = image;
                             }
                             completion:NULL];
         }
                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
         {
             NSLog(@"error: %@", error);
         }];
    }
    
    if (self.pictureImageView)
    {
        if (object.img && ![object.img isEqualToString:@""])
        {
            self.pictureImageView.image = nil;

            NSURL *assetsBaseUrl = [RequestManager sharedManager].assetsBaseUrl;
            NSURL *pictureUrl = [[NSURL alloc] initWithString:object.img relativeToURL:assetsBaseUrl];
            NSURLRequest* pictureRequest = [NSURLRequest requestWithURL:pictureUrl];
            
            __weak UIImageView *weakPictureImageView = self.pictureImageView;
            
            [self.pictureImageView setImageWithURLRequest:pictureRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
             {
                 UIImageView *strongImageView = weakPictureImageView;
                 if (!strongImageView) return;
                 
                 [UIView transitionWithView:strongImageView
                                   duration:0.3
                                    options:UIViewAnimationOptionTransitionCrossDissolve
                                 animations:^{
                                     strongImageView.image = image;
                                 }
                                 completion:NULL];
             }
                                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
             {
                 NSLog(@"error: %@", error);
             }];
        }
        else
        {
            pictureWidth.constant = 0;
            [self.pictureImageView layoutIfNeeded];
        }
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    if (label == self.commentsLabel)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(reviewCellCommentsPressed:)])
            [_delegate reviewCellCommentsPressed:self];
    }
    else if (label == self.likesLabel)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(reviewCellLikePressed:)])
            [_delegate reviewCellLikePressed:self];
    }
    else if (label == self.addCommentLabel)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(reviewCellAddCommentPressed:)])
            [_delegate reviewCellAddCommentPressed:self];
    }
    else if (label == self.readMoreLabel)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(reviewCellReadMorePressed:)])
            [_delegate reviewCellReadMorePressed:self];
    }
}

- (void)userPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(reviewCellUserPressed:)])
        [_delegate reviewCellUserPressed:self];
}

- (void)photoPressed:(id)sender
{
    if (pictureWidth.constant != 0 && _delegate && [_delegate respondsToSelector:@selector(reviewCellPhotoPressed:)])
        [_delegate reviewCellPhotoPressed:self];
}

//- (void)setBounds:(CGRect)bounds
//{
//    [super setBounds:bounds];
//    
//    self.contentView.frame = self.bounds;
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // (2)
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    
    // (3)
    self.reviewLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.reviewLabel.frame);
}

@end