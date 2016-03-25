//
//  TypesViewCell.m
//  Restotube
//
//  Created by Maksim Kis on 09.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "CuisinesViewCell.h"

@implementation CuisinesViewCell


- (void) awakeFromNib {
     self.imageSelected.hidden = YES;
}

- (void) setCuisine:(Cuisines *)cuisine {
    _cuisine = cuisine;
    
    self.textLabel.text = cuisine.name;
    [self setNeedsLayout];
}


@end
