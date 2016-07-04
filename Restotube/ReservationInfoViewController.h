//
//  ReservationInfoViewController.h
//  Restotube
//
//  Created by Andrey Rebrik on 14.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reservation.h"

@interface ReservationInfoViewController : UIViewController
{
    IBOutlet UIView *roundView;
    
    IBOutlet UILabel *reservNumberLabel;
    IBOutlet UILabel *topLabel;
    IBOutlet UILabel *bottomLabel;
    __weak IBOutlet UIButton *returnButton;
}

@property (nonatomic, strong) Reservation *reservation;
@property (nonatomic, strong) NSString *nameString;
@end