//
//  FilterButtonsViewCell.m
//  Restotube
//
//  Created by Maksim Kis on 09.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "FilterButtonsViewCell.h"
#import "filters.h"

@implementation FilterButtonsViewCell

- (void) awakeFromNib {
    [self.buttonContainer bringSubviewToFront:self.buttonAction];
    [self reset];

}
#define AppColorRed     [UIColor colorWithRed:255/255.0f green:35/255.0f blue:102/255.0f alpha:1.0f]
#define AppColorGray    [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f]
#define AppColorDarkGray [UIColor colorWithRed:101/255.0f green:101/255.0f blue:99/255.0f alpha:1.0f]

#define APPColorGrayBg [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0f]

#pragma mark - Class Methods
#pragma mark -

- (IBAction) buttonAction:(id)sender forEvent:(UIEvent *)event
{
    UITouch *touch = [[event touchesForView:self.buttonAction] anyObject];
    CGPoint location = [touch locationInView:self.buttonContainer];
    for (UIImageView *imageView in self.buttonContainer.subviews)
    {
        if ([imageView isMemberOfClass:[UIImageView class]] && imageView.tag >= 1 && imageView.tag <= 16)
        {
            if (imageView.frame.origin.x < location.x && imageView.frame.origin.y < location.y && imageView.frame.origin.x + imageView.frame.size.width > location.x && imageView.frame.origin.y + imageView.frame.size.height > location.y)
            {
                NSString *key = [NSString stringWithFormat:@"type%d", (int)imageView.tag];
                NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:key];
                [imageView setTintColor:!number.boolValue ? APPColorGrayBg : AppColorDarkGray];
                [imageView setBackgroundColor:!number.boolValue ? AppColorRed : APPColorGrayBg];
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:!number.boolValue] forKey:key];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                if(!number.boolValue == YES) {
                    NSNumber* feature_id = [NSNumber numberWithInt:[[Filters getInstance] getFeatureIdByTag:(int)imageView.tag]];
                    [[[Filters getInstance] selectedFeatures] addObject:feature_id];
                }
                else {
                    NSArray* selectedFeaturesIds = [[Filters getInstance] selectedFeatures];
                    NSUInteger selected_id = -1;
                    for (int i = 0; i < [selectedFeaturesIds count]; i++) {
                        NSNumber* selected_number = [selectedFeaturesIds objectAtIndex:(NSInteger)i];
                        
                        if([[Filters getInstance] getFeatureIdByTag:(int)imageView.tag] == selected_number.intValue){
                            selected_id = i;
                            break;
                        }
                    }
                    
                    if(selected_id != -1) {
                        [[[Filters getInstance] selectedFeatures] removeObjectAtIndex:selected_id];
                    }
                }

                break;
            }
        }
    }
}

- (void) reset
{
    for (UIImageView *imageView in self.buttonContainer.subviews)
    {
        if ([imageView isMemberOfClass:[UIImageView class]] && imageView.tag >= 1 && imageView.tag <= 16)
        {
            [imageView setTintColor:AppColorDarkGray];
            [imageView setBackgroundColor:APPColorGrayBg];
            [imageView setImage:[imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"type%d", (int)imageView.tag]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    [[[Filters getInstance] selectedFeatures] removeAllObjects];
    
}


@end
