//
//  TypesViewCell.m
//  Restotube
//
//  Created by Maksim Kis on 09.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "MetroViewCell.h"

@implementation MetroViewCell


- (void) awakeFromNib {
     self.imageSelected.hidden = YES;
}

- (void) setMetro:(Metro *)metro {
    _metro = metro;
    
    self.textLabel.text = metro.name;
    [self setNeedsLayout];
}


@end
