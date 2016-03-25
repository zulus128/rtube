//
//  Cuisines.h
//  Restotube
//
//  Created by Maksim Kis on 09.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cuisines : NSObject

@property (nonatomic, strong) NSString *type_id;
@property (nonatomic, strong) NSString *name;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
+ (NSURLSessionDataTask *)cuisinesWithBlock :(void (^)(NSArray *cuisines, NSError *error))block;

@end
