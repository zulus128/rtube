//
//  Features.m
//  Restotube
//
//  Created by Maksim Kis on 09.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "Features.h"
#import "RequestManager.h"
#import "ParseMethods.h"


@implementation Features

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.type_id = [attributes valueForKey:@"id"];
    self.name = [attributes valueForKey:@"name"];
    
    return self;
}

+ (NSURLSessionDataTask *)featuresWithBlock:(void (^)(NSArray *, NSError *))block {
    NSString* urlrequest = [NSString stringWithFormat:@"getFeatures"];
    
    return [[RequestManager sharedManager] GET:urlrequest parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *featuresFromResponce = JSON;
        NSMutableArray *mulableFeatures = [NSMutableArray arrayWithCapacity:[featuresFromResponce count]];
        for (NSDictionary *attributes in featuresFromResponce) {
            Features *feature = [[Features alloc] initWithAttributes:attributes];
            [mulableFeatures addObject:feature];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mulableFeatures], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}


@end
