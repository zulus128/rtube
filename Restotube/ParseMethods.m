//
//  ParseMethods.m
//  Restotube
//
//  Created by user on 03.08.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "ParseMethods.h"

@implementation ParseMethods

@end

NSString *stringValue(id value)
{
    if ([value isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    else
        if ([value isKindOfClass:[NSString class]])
        {
            return value;
        }
        else
            if ([value isKindOfClass:[NSNumber class]] && [value boolValue] == false)
            {
                return @"";
            }
            else
            {
                return [value stringValue];
            }
}