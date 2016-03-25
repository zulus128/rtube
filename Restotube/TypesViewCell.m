//
//  TypesViewCell.m
//  Restotube
//
//  Created by Maksim Kis on 09.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "TypesViewCell.h"

@implementation TypesViewCell


- (void) awakeFromNib {
     self.imageSelected.hidden = YES;
}

- (void) setType:(Types *)type {
    _type = type;
    
    self.textLabel.text = type.name;
    [self setNeedsLayout];
}


@end
