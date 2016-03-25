//
//  Categories.h
//  Restotube
//
//  Created by Maksim Kis on 06.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Categories : NSObject

@property (nonatomic, strong) NSString *category_Id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *icon;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
+ (NSURLSessionDataTask *)categoriesWithBlock:(float) cellWidth :(float) cellHeight : (void (^)(NSArray *categories, NSError *error))block;

@end
