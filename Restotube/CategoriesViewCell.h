//
//  CategorieViewCell.h
//  Restotube
//
//  Created by Maksim Kis on 06.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Categories.h"

@interface CategoriesViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel        *labelTitle;
@property (nonatomic, weak) IBOutlet UIImageView    *imageViewBackground;
@property (nonatomic, weak) IBOutlet UIImageView    *imageViewIcon;
@property (nonatomic, strong) Categories *category;
@end
