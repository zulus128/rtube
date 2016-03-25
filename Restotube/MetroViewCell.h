//
//  TypesViewCell.h
//  Restotube
//
//  Created by Maksim Kis on 09.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Metro.h"

@interface MetroViewCell : UITableViewCell

@property (nonatomic, strong) Metro *metro;
@property (weak, nonatomic) IBOutlet UIImageView *imageSelected;

@end
