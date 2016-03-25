//
//  Categories.m
//  Restotube
//
//  Created by Maksim Kis on 06.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "Categories.h"
#import "RequestManager.h"
#import "ParseMethods.h"

@implementation Categories

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.category_Id = [attributes valueForKeyPath:@"id"];
    self.title = [attributes valueForKeyPath:@"title"];
    self.img = stringValue([attributes valueForKeyPath:@"img"]);
    self.icon = stringValue([attributes valueForKeyPath:@"icon"]);
    
    return self;
}

+ (NSURLSessionDataTask *)categoriesWithBlock:(float) cellWidth : (float) cellHeight : (void (^)(NSArray *categories, NSError *error))block {
    NSString* urlrequest = [NSString stringWithFormat:@"getCategoryList?params[img][width]=%f&params[img][height]=%f&params[img][method]=crop", cellWidth, cellHeight];
    
    return [[RequestManager sharedManager] GET:urlrequest parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *categoriesFromResponce = JSON;
        NSMutableArray *mulableCategories = [NSMutableArray arrayWithCapacity:[categoriesFromResponce count]];
        for (NSDictionary *attributes in categoriesFromResponce) {
            Categories *cat = [[Categories alloc] initWithAttributes:attributes];
            [mulableCategories addObject:cat];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mulableCategories], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}
@end
