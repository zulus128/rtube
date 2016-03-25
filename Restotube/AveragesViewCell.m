//
//  TypesViewCell.m
//  Restotube
//
//  Created by Maksim Kis on 09.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "AveragesViewCell.h"

@implementation AveragesViewCell


- (void) awakeFromNib {
     self.imageSelected.hidden = YES;
}

- (void) setAverage:(Averages *)average {
    _average = average;
    
    self.textLabel.text = average.name;
    [self setNeedsLayout];
}


@end
