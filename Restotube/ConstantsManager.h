//
//  ConstantsManager.h
//  Restotube
//
//  Created by Andrey Rebrik on 11.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cuisines.h"
#import "Metro.h"
#import "Averages.h"
#import "Features.h"
#import "Types.h"

@interface ConstantsManager : NSObject

@property (nonatomic, readonly) NSArray *cuisines;
@property (nonatomic, readonly) NSArray *metro;
@property (nonatomic, readonly) NSArray *averages;
@property (nonatomic, readonly) NSArray *types;
@property (nonatomic, readonly) NSArray *features;

+ (ConstantsManager*)getInstance;

@property (strong, nonatomic) NSString *city;
@end
