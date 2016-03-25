//
//  ReservationViewController.h
//  Restotube
//
//  Created by Andrey Rebrik on 13.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurants.h"
#import "ReplenishBalanceViewController.h"
#import "WebViewVC.h"

typedef void(^CheckCompletionBlock)(NSString*, NSError*);

@interface ReservationViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, WebViewVCDelegate, ReplenishBalanceViewControllerDelegate>
{
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UIView *fadView;
    
    IBOutlet UILabel *addressLabel;
    
    IBOutletCollection(UIView) NSArray *textfields;
    
    IBOutlet UITextField *dateTextField;
    IBOutlet UITextField *timeTextField;
    
    IBOutlet UITextField *nameField;
    IBOutlet UITextField *surnameField;
    IBOutlet UITextField *phoneField;
    IBOutlet UITextField *peopleField;
    IBOutlet UITextView *commentTextView;
    IBOutlet UIView *dateBackground;
    IBOutlet UIView *timeBackground;
    IBOutlet UIView *addressBackground;
    
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *timeLabel;
    
    __weak IBOutlet UILabel *costPerPersonLabel;
    __weak IBOutlet UILabel *discountLabel;
    __weak IBOutlet UILabel *discountDescription;
    __weak IBOutlet UIImageView *bubblePresentImageView;
    
    IBOutlet UIButton *doneButtonAcessoryView;
    
    IBOutlet UIButton *resrveWithDiscountButton;
    IBOutlet UIButton *resrveButton;
    __weak IBOutlet NSLayoutConstraint *bottomConstrain;
}
@property (weak, nonatomic) IBOutlet UIImageView *presentImgView;
@property (weak, nonatomic) IBOutlet UILabel *presentDescLabel;

@property (strong, nonatomic) UIView *fadeView;

@property (nonatomic, strong) Restaurants *restaurant;

@property (assign, nonatomic) NSInteger productPrice;
@property (assign, nonatomic) NSInteger numberOfPeople;
@property (assign, nonatomic) CheckCompletionBlock checkCompletionBlock;

- (IBAction)datePressed:(id)sender;
- (IBAction)timePressed:(id)sender;

- (IBAction)addressPressed:(id)sender;

- (IBAction)reserveWithDiscountPressed:(id)sender;
- (IBAction)reservePressed:(id)sender;

- (IBAction)doneButtonPreesed:(id)sender;

@end