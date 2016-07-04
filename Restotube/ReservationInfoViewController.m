//
//  ReservationInfoViewController.m
//  Restotube
//
//  Created by Andrey Rebrik on 14.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "ReservationInfoViewController.h"
#import "AFNetworking.h"

@interface ReservationInfoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIImageView *smileImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smileImgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smileImgWidth;
@property (weak, nonatomic) IBOutlet UIButton *saveToCameraRoll;
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;

@end

@implementation ReservationInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSLog(@"--- %@", _reservation.status_id);
    int stat = _reservation.status_id.intValue;
    NSString *titleStr = @"";
    switch (stat) {
        case 1:
        case 3:
            self.smileImg.image = [UIImage imageNamed:@"smile_dots"];
            self.smileImgWidth.constant = 77/2;
            self.smileImgHeight.constant = 15/2;
            titleStr = @"Спасибо за бронирование, ожидайте смс подтверждения в ближайшее время!";
            self.warnLabel.hidden = YES;
            break;
        case 2:
            self.smileImg.image = [UIImage imageNamed:@"smile_good"];
            self.smileImgWidth.constant = 85/2;
            self.smileImgHeight.constant = 50/2;
            titleStr = [NSString stringWithFormat:@"%@", _reservation.resto];
            break;
        case 4:
            self.smileImg.image = [UIImage imageNamed:@"smile_bad"];
            self.smileImgWidth.constant = 85/2;
            self.smileImgHeight.constant = 51/2;
            titleStr = @"Извините, в данный момент все столы забронированы, выберите другой ресторан или зарезервируйте столик на другое время.";
            self.cancelButton.hidden = YES;
            self.saveToCameraRoll.hidden = YES;
            self.warnLabel.hidden = YES;
            break;
            
        default:
            break;
    }
    
    [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed: @"restotube-logo"]]];
    
    reservNumberLabel.text = [NSString stringWithFormat:@"ВАША БРОНЬ № %@", _reservation.reservation_id];
//    topLabel.text = [NSString stringWithFormat:@"%@\n%@", _reservation.resto, _nameString];
    topLabel.text = titleStr;

    
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
    
    _saveToCameraRoll.layer.cornerRadius = 4;
    _saveToCameraRoll.layer.borderColor = [UIColor whiteColor].CGColor;
    _saveToCameraRoll.layer.borderWidth = 1;
    
    returnButton.layer.cornerRadius = 4;
    returnButton.layer.borderWidth = 1;
    returnButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _cancelButton.layer.cornerRadius = 4;
    _cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _cancelButton.layer.borderWidth = 1;
   
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

- (IBAction)cancelButtonClicked:(id)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{   @"book_id"           : _reservation.reservation_id,
                                @"status"             : @4,
                                };
    NSLog(@"params to send :\n%@", params);
    [manager POST:@"http://restotube.ru/api/setBookStatus" parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"=== Success: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"=== Error: %@", error);
    }];
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