//
//  Averages.m
//  Restotube
//
//  Created by Maksim Kis on 09.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "Averages.h"
#import "RequestManager.h"
#import "ParseMethods.h"


@implementation Averages


- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.type_id = [attributes valueForKey:@"id"];
    self.name = [attributes valueForKey:@"name"];
    
    return self;
}

+ (NSURLSessionDataTask *)averagesWithBlock:(void (^)(NSArray *, NSError *))block {
    NSString* urlrequest = [NSString stringWithFormat:@"getAverages"];
    
    return [[RequestManager sharedManager] GET:urlrequest parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *averagesFromResponce = JSON;
        NSMutableArray *mulableAverages = [NSMutableArray arrayWithCapacity:[averagesFromResponce count]];
        for (NSDictionary *attributes in averagesFromResponce) {
            Averages *average = [[Averages alloc] initWithAttributes:attributes];
            [mulableAverages addObject:average];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mulableAverages], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}
@end
