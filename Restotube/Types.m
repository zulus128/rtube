//
//  Types.m
//  Restotube
//
//  Created by Maksim Kis on 09.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "Types.h"
#import "RequestManager.h"
#import "ParseMethods.h"

@implementation Types

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.type_id = [attributes valueForKey:@"id"];
    self.name = [attributes valueForKey:@"name"];

    return self;
}

+ (NSURLSessionDataTask *)typesWithBlock: (void (^)(NSArray *types, NSError *error))block {
    NSString* urlrequest = [NSString stringWithFormat:@"getTypes"];
    
    return [[RequestManager sharedManager] GET:urlrequest parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *typesFromResponce = JSON;
        NSMutableArray *mulableTypes = [NSMutableArray arrayWithCapacity:[typesFromResponce count]];
        for (NSDictionary *attributes in typesFromResponce) {
            Types *type = [[Types alloc] initWithAttributes:attributes];
            [mulableTypes addObject:type];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mulableTypes], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}
@end
