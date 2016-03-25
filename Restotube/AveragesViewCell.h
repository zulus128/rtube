//
//  TypesViewCell.h
//  Restotube
//
//  Created by Maksim Kis on 09.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Averages.h"

@interface AveragesViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageSelected;
@property (nonatomic, strong) Averages *average;
@end
