//
//  IntroView.m
//  Restotube
//
//  Created by owel on 30/08/15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "IntroView.h"

@implementation IntroView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro3"]];
    _background.contentMode = UIViewContentModeScaleAspectFit;
    
    _firstLabel = [UILabel new];
//    _firstLabel.font = [UIFont systemFontOfSize:21 weight:UIFontWeightRegular];
    _firstLabel.font = [UIFont systemFontOfSize:21];
    _firstLabel.minimumScaleFactor = 0.5;
    _firstLabel.adjustsFontSizeToFitWidth = YES;
    _firstLabel.text = @"Быстрое он-лайн";
    
    _secondLabel = [UILabel new];
//    _secondLabel.font = [UIFont systemFontOfSize:21 weight:UIFontWeightBold];
    _secondLabel.font = [UIFont boldSystemFontOfSize:21];
    _secondLabel.backgroundColor = [UIColor colorWithRed:228.0 / 255.0 green:18.0 / 255.0 blue:84.0 / 255.0 alpha:1];
    _secondLabel.textColor = [UIColor whiteColor];
    _secondLabel.minimumScaleFactor = 0.5;
    _secondLabel.adjustsFontSizeToFitWidth = YES;
    _secondLabel.text = @" бронирование столиков ";
    
    _thirdLabel = [UILabel new];
//    _thirdLabel.font = [UIFont systemFontOfSize:21 weight:UIFontWeightRegular];
    _thirdLabel.font = [UIFont systemFontOfSize:21];
    _thirdLabel.minimumScaleFactor = 0.5;
    _thirdLabel.adjustsFontSizeToFitWidth = YES;
    _thirdLabel.text = @"c SMS подтверждением";
    
    _button = [UIButton new];
    [_button setBackgroundImage:[UIImage imageNamed:@"intro_button"] forState:UIControlStateNormal];
    [_button setTitle:@"Продолжить" forState:UIControlStateNormal];
//    _button.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    _button.titleLabel.font = [UIFont systemFontOfSize:18];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self addSubview:_background];
    [self addSubview:_firstLabel];
    [self addSubview:_secondLabel];
    [self addSubview:_thirdLabel];
    [self addSubview:_button];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _background.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width * _background.image.size.height / _background.image.size.width);
    
    [_firstLabel sizeToFit];
    _firstLabel.frame = CGRectMake(0, 0, self.frame.size.width / 10 * 4, _firstLabel.frame.size.height);
    _firstLabel.center = CGPointMake(self.frame.size.width / 2, _background.frame.origin.y + _background.frame.size.height + 30);
    
    [_secondLabel sizeToFit];
    _secondLabel.frame = CGRectMake(0, 0, self.frame.size.width / 10 * 6, _secondLabel.frame.size.height + 5);
    _secondLabel.center = CGPointMake(self.frame.size.width / 2, _firstLabel.frame.origin.y + _firstLabel.frame.size.height + 20);
    
    [_thirdLabel sizeToFit];
    _thirdLabel.frame = CGRectMake(0, 0, self.frame.size.width / 10 * 6, _thirdLabel.frame.size.height);
    _thirdLabel.center = CGPointMake(self.frame.size.width / 2, _secondLabel.frame.origin.y + _secondLabel.frame.size.height + 20);
    
    _button.frame = CGRectMake(0, 0, self.frame.size.width / 10 * 4.7, self.frame.size.width / 10 * 1.2);
    _button.center = CGPointMake(self.frame.size.width / 2, _thirdLabel.frame.origin.y + _thirdLabel.frame.size.height + 30);
}

@end
