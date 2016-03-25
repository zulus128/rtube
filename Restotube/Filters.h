//
//  Filters.h
//  Restotube
//
//  Created by Maksim Kis on 08.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FiltersSelected : NSObject
    @property (strong,nonatomic) NSString* selectedId;
    @property (strong,nonatomic) NSString* selectedName;
@end


@interface Filters : NSObject

@property (strong,nonatomic) NSString* categoryId;
@property (strong,nonatomic) NSString* searchText;
@property (strong,nonatomic) NSMutableArray* selectedMetro;
@property (strong,nonatomic) NSMutableArray* selectedAverages;
@property (strong,nonatomic) NSMutableArray* selectedCuisines;
@property (strong,nonatomic) NSMutableArray* selectedTypes;
@property (strong,nonatomic) NSMutableArray* selectedFeatures;
+ (Filters*)getInstance;
- (int)getFeatureIdByTag : (int) tag;
@end
