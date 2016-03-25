//
//  AuthViewController.h
//  Restotube
//
//  Created by Maksim Kis on 13.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHSPhoneLibrary.h"

@interface AuthViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet SHSPhoneTextField *textfieldPhone;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end
