//
//  ReservationInfoViewController.m
//  Restotube
//
//  Created by Andrey Rebrik on 14.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "ReservationInfoViewController.h"

@interface ReservationInfoViewController ()

@end

@implementation ReservationInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed: @"restotube-logo"]]];
    
    reservNumberLabel.text = [NSString stringWithFormat:@"ВАША БРОНЬ № %@", _reservation.reservation_id];
//    topLabel.text = [NSString stringWithFormat:@"%@\n%@", _reservation.resto, _nameString];
    topLabel.text = [NSString stringWithFormat:@"%@", _reservation.resto];

    
    NSString *saleString = [NSString stringWithFormat:@"%@",_reservation.sale];
    if (![saleString isEqualToString:@""])
    {
        saleString = [NSString stringWithFormat:@"Скидка %@%%", saleString];
        
         if ([_reservation.sale intValue] == 0 && _reservation.presentDesc.length > 0)
        {
            saleString = @"Подарок";//_reservation.presentDesc;
        }
    }
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *date = [formatter dateFromString:_reservation.date];
//    
//    [formatter setDateFormat:@"dd MMMM"];
//    
//    NSString *dateString = [formatter stringFromDate:date];
    
    bottomLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@ %@\n\n%@", _reservation.date, _reservation.time, _reservation.col, StringForNumber(_reservation.col.intValue), saleString];
    
    [UIView animateWithDuration:0 animations:^{
        [roundView layoutIfNeeded];
    } completion:^(BOOL finished) {
        roundView.layer.masksToBounds = YES;
        roundView.layer.cornerRadius = roundView.frame.size.width/2;
    }];
    
    saveToCameraRoll.layer.cornerRadius = 4;
    saveToCameraRoll.layer.borderColor = [UIColor whiteColor].CGColor;
    saveToCameraRoll.layer.borderWidth = 1;
    
    returnButton.layer.cornerRadius = 4;
    returnButton.layer.borderWidth = 1;
    returnButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
   
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem =
    self.navigationItem.backBarButtonItem = nil;
}

- (IBAction)onSaveToCameraRoll:(id)sender
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*theImage=UIGraphicsGetImageFromCurrentImageContext();
    UIImageWriteToSavedPhotosAlbum(theImage,nil,NULL,NULL);
    UIGraphicsEndImageContext();
}

- (IBAction)onReturn:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

NSString * StringForNumber(int number)
{
    NSInteger iNumber = number % 100;
    NSString* res;
    if (iNumber >= 11 && iNumber <= 19)
    {
        res = @"гостей";
    }
    else
    {
        switch (number % 10)
        {
            case (1):
                res = @"гость";
                break;
                
            case (2):
            case (3):
            case (4):
                res = @"гостя";
                break;
                
            default:
                res = @"гостей";
        }
    }
    
    return res;
}

@end