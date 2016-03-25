//
//  AddReportViewController.h
//  Restotube
//
//  Created by Andrey Rebrik on 15.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSImagePickerViewController.h"

@interface AddReportViewController : UIViewController <UITextViewDelegate, JSImagePickerViewControllerDelegate>
{
    IBOutlet UITextView *commentTextView;
    IBOutlet UIScrollView *mainScroll;
    
    IBOutlet UIView *photoView;
    IBOutlet UIImageView *photoImageView;
    
    IBOutlet UIImageView *avatarImageView;
    IBOutlet UILabel *userLabel;
    
    IBOutlet UIButton *addPhotoButton;
}

@property (nonatomic, strong) NSString *restaurantId;

- (IBAction)addPhotoPressed:(id)sender;
- (IBAction)sendPressed:(id)sender;
- (IBAction)deletePhotoPressed:(id)sender;

@end