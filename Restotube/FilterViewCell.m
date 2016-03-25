//
//  FilterViewCell.m
//  Restotube
//
//  Created by Maksim Kis on 09.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "FilterViewCell.h"
#import "Filters.h"

@implementation FilterViewCell


-(void) viewDidLoad {
}

- (void) awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(filterSelected:)
                                                 name:@"filterSelected"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(filterReset:)
                                                 name:@"filterReset"
                                               object:nil];
    self.labelSelected.text = @"";
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) filterReset:(NSNotification *) notification  {
    self.labelFilter.textColor = [UIColor blackColor];
    self.labelSelected.text = @"";
    
    if([self.labelFilter.text isEqualToString:@"Куда идем"]) {
        [[[Filters getInstance] selectedTypes] removeAllObjects];
    }
    if([self.labelFilter.text isEqualToString:@"Что едим"]) {
         [[[Filters getInstance] selectedCuisines] removeAllObjects];
    }
    if([self.labelFilter.text isEqualToString:@"Средний счет"]) {
         [[[Filters getInstance] selectedAverages] removeAllObjects];
    }
    if([self.labelFilter.text isEqualToString:@"Метро"]) {
         [[[Filters getInstance] selectedMetro] removeAllObjects];
    }
}

- (void) filterSelected:(NSNotification *) notification  {
    NSString* text = @"";
    if([self.labelFilter.text isEqualToString:@"Куда идем"]) {
        text= [[[[Filters getInstance] selectedTypes] valueForKey:@"selectedName"] componentsJoinedByString:@","];
        self.labelSelected.text = text;
    }
    if([self.labelFilter.text isEqualToString:@"Что едим"]) {
        text= [[[[Filters getInstance] selectedCuisines] valueForKey:@"selectedName"] componentsJoinedByString:@","];
        self.labelSelected.text = text;
    }
    if([self.labelFilter.text isEqualToString:@"Средний счет"]) {
        text= [[[[Filters getInstance] selectedAverages] valueForKey:@"selectedName"] componentsJoinedByString:@","];
        self.labelSelected.text = text;
    }
    if([self.labelFilter.text isEqualToString:@"Метро"]) {
        text= [[[[Filters getInstance] selectedMetro] valueForKey:@"selectedName"] componentsJoinedByString:@","];
        self.labelSelected.text = text;
    }
    
    if([text isEqualToString:@""])
        self.labelFilter.textColor = [UIColor blackColor];
    else
        self.labelFilter.textColor = [UIColor colorWithRed:251/255.0f green:0 blue:83/255.0f alpha:1];

}

@end
