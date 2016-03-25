//
//  UISearchBar+CustomBackGround.m
//  Restotube
//
//  Created by Maksim Kis on 16.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "UISearchBar+CustomBackGround.h"
#import <QuartzCore/QuartzCore.h>
@implementation UISearchBar (CustomBackGround)


- (id)init
{
    for ( UIView * subview in self.subviews )
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground") ] )
            subview.alpha = 0.0;
        
        if ([subview isKindOfClass:NSClassFromString(@"UISegmentedControl") ] )
            subview.alpha = 0.0;
    }
    
    return self;
}

+ (UIImage *) bgImagePortrait
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"head-line"] ;
    
    return image;
}

+ (UIImage *) bgImageLandscape
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"head-line"] ;
    
    return image;
}

- (void) drawLayer:(CALayer *)layer inContext:(CGContextRef)contenxt
{
    if ([self isMemberOfClass:[UISearchBar class]] == NO)
        return;
    
    UIImage * image = ( self.frame.size.width > 320 ) ? [UISearchBar bgImageLandscape ] : [UISearchBar bgImagePortrait ];
    
    for ( UIView * subview in self.subviews ) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground") ] )
            subview.alpha = 0.0;
        
        if ([subview isKindOfClass:NSClassFromString(@"UISegmentedControl") ] )
            subview.alpha = 0.0;
    }
    
    CGContextTranslateCTM( contenxt , 0 , image.size.height );
    CGContextScaleCTM( contenxt, 1.0, -1.0 );
    CGContextDrawImage( contenxt , CGRectMake( 0 , 0 , image.size.width , image.size.height ), image.CGImage );
}

@end
