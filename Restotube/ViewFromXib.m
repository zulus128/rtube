//
//  ViewFromXib.m
//  Restotube
//
//  Created by owel on 29/08/15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "ViewFromXib.h"

@implementation ViewFromXib

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self commonInit];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    [self commonInit];
    
    return self;
}

-(void) commonInit
{
    _containerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    _containerView.backgroundColor = [UIColor clearColor];
    //
    _defaultColor = self.backgroundColor;
    
    [self addSubview:_containerView];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _containerView.frame = self.bounds;
}

@end
