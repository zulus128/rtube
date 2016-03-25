//
//  ReservationsViewCell.h
//  Restotube
//
//  Created by Maksim Kis on 15.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationsViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelDateCount;

@end
