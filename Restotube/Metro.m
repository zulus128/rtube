//
//  Metro.m
//  Restotube
//
//  Created by Maksim Kis on 09.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "Metro.h"
#import "RequestManager.h"
#import "ParseMethods.h"


@implementation Metro

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

+ (NSURLSessionDataTask *)metroWithBlock:(void (^)(NSArray *, NSError *))block {
    NSString* urlrequest = [NSString stringWithFormat:@"getMetro"];
    
    return [[RequestManager sharedManager] GET:urlrequest parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *metroFromResponce = JSON;
        NSMutableArray *mulableMetro = [NSMutableArray arrayWithCapacity:[metroFromResponce count]];
        for (NSDictionary *attributes in metroFromResponce) {
            Metro *metro = [[Metro alloc] initWithAttributes:attributes];
            [mulableMetro addObject:metro];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mulableMetro], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}
@end
