//
//  BookList.h
//  Restotube
//
//  Created by Maksim Kis on 15.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookList : NSObject

@property (nonatomic, strong) NSString *book_Id;
@property (nonatomic, strong) NSString *user_Id;
@property (nonatomic, strong) NSString *datetime;
@property (nonatomic, strong) NSString *book_datetime;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *sale;
@property (nonatomic, strong) NSString *sale_price;
@property (nonatomic, strong) NSString *sale_status;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *resto;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *status_id;
@property (nonatomic, strong) NSString *status_name;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
+ (NSURLSessionDataTask *)reservationsWithBlock :(void (^)(NSArray *reservations, NSError *error))block;

@end
