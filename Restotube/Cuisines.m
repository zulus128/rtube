//
//  Cuisines.m
//  Restotube
//
//  Created by Maksim Kis on 09.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "Cuisines.h"
#import "RequestManager.h"
#import "ParseMethods.h"

@implementation Cuisines

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.type_id = [attributes valueForKey:@"id"];
    self.name = [attributes valueForKey:@"name"];
    
    return self;
}

- (NSComparisonResult)compare:(Cuisines *)otherObject {
    return [self.name compare:otherObject.name];
}

+ (NSURLSessionDataTask *)cuisinesWithBlock:(void (^)(NSArray *, NSError *))block {
    NSString* urlrequest = [NSString stringWithFormat:@"getCuisines"];
    
    return [[RequestManager sharedManager] GET:urlrequest parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *cuisinesFromResponce = JSON;
        NSMutableArray *mulableCuisines = [NSMutableArray arrayWithCapacity:[cuisinesFromResponce count]];
        for (NSDictionary *attributes in cuisinesFromResponce) {
            Cuisines *cuisine = [[Cuisines alloc] initWithAttributes:attributes];
            [mulableCuisines addObject:cuisine];
        }
        
        NSArray *sortedArray = [mulableCuisines sortedArrayUsingSelector:@selector(compare:)];

        if (block) {
            block([NSArray arrayWithArray:sortedArray], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}
@end
