//
//  TypesViewCell.h
//  Restotube
//
//  Created by Maksim Kis on 09.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cuisines.h"

@interface CuisinesViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageSelected;
@property (nonatomic, strong) Cuisines *cuisine;
@end
