//
//  Filters.m
//  Restotube
//
//  Created by Maksim Kis on 08.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "Filters.h"

static Filters* s_filters = nil;

@implementation FiltersSelected

@end


@implementation Filters {
    
}

-(id)init {
    if (self = [super init]) {
        self.selectedMetro =  [[NSMutableArray alloc] init];
        self.selectedTypes =  [[NSMutableArray alloc] init];
        self.selectedFeatures =  [[NSMutableArray alloc] init];
        self.selectedCuisines =  [[NSMutableArray alloc] init];
        self.selectedAverages =  [[NSMutableArray alloc] init];
        self.categoryId = @"";
        self.searchText = @"";
    }
    
    return self;
}


+ (Filters*)getInstance {
    if (s_filters == nil) {
        s_filters = [[Filters alloc] init];
    }
    
    return s_filters;
}

- (int)getFeatureIdByTag : (int) tag {
    if( tag > 11) {
        if(tag == 12) {
            return 15;
        }
        else if(tag == 13) {
            return 16;
        }
        else if(tag == 14) {
            return 13;
        }
        else if(tag == 15) {
            return 12;
        }
        else if (tag == 16){
            return 17;
        }
    }

    return tag;
    
}

@end
