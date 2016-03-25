//
//  ConstantsManager.m
//  Restotube
//
//  Created by Andrey Rebrik on 11.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "ConstantsManager.h"

static ConstantsManager* instance = nil;

@implementation ConstantsManager

+ (ConstantsManager *)getInstance
{
    if (!instance) {
        instance = [[ConstantsManager alloc] init];
    }
    
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        [Averages averagesWithBlock:^(NSArray *averages, NSError *error)
        {
            if (!error)
                _averages = [NSArray arrayWithArray:averages];
            else
                _averages = [NSArray array];
        }];
        
        [Cuisines cuisinesWithBlock:^(NSArray *cuisines, NSError *error)
        {
            if (!error)
                _cuisines = [NSArray arrayWithArray:cuisines];
            else
                _cuisines = [NSArray array];
        }];
        
        [Metro metroWithBlock:^(NSArray *metro, NSError *error)
        {
            if (!error)
                _metro = [NSArray arrayWithArray:metro];
            else
                _metro = [NSArray array];
        }];
        
        [Features featuresWithBlock:^(NSArray *features, NSError *error)
         {
             if (!error)
                 _features = [NSArray arrayWithArray:features];
             else
                 _features = [NSArray array];
         }];
        
        [Types typesWithBlock:^(NSArray *types, NSError *error)
         {
             if (!error)
                 _types = [NSArray arrayWithArray:types];
             else
                 _types = [NSArray array];
         }];
    }
    
    return self;
}

- (NSString *)city
{
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:@"kCity"];
    if (city == nil)
    {
        self.city = @"moscow";
        return @"moscow";
    }
    return city;
}

- (void)setCity:(NSString *)city
{
    [[NSUserDefaults standardUserDefaults] setObject:city forKey:@"kCity"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end