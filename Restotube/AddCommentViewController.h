//
//  AddCommentViewController.h
//  Restotube
//
//  Created by Andrey Rebrik on 15.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCommentViewController : UIViewController <UITextViewDelegate>
{
    IBOutlet UITextView *commentTextView;
    IBOutlet UIScrollView *mainScroll;
    
    IBOutlet UIImageView *avatarImageView;
    IBOutlet UILabel *userLabel;
}

@property (nonatomic, strong) NSString *restaurantId;
@property (nonatomic, strong) NSString *parentId;

- (IBAction)sendPressed:(id)sender;

@end
