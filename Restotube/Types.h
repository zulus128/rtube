//
//  Types.h
//  Restotube
//
//  Created by Maksim Kis on 09.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Types : NSObject

@property (nonatomic, strong) NSString *type_id;
@property (nonatomic, strong) NSString *name;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
+ (NSURLSessionDataTask *)typesWithBlock :(void (^)(NSArray *types, NSError *error))block;

@end
