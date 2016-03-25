//
//  Reservation.h
//  Restotube
//
//  Created by Andrey Rebrik on 15.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reservation : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *book_id;
@property (nonatomic, strong) NSString *col;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *reservation_hash;
@property (nonatomic, strong) NSString *reservation_id;
@property (nonatomic, strong) NSString *resto;
@property (nonatomic, strong) NSString *sale;
@property (nonatomic, strong) NSString *sale_url;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *presentDesc;
@property (strong, nonatomic) NSString *payment_id;
@property (strong, nonatomic) NSString *sum;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
+ (NSURLSessionDataTask *)sendReserveRequest:(NSDictionary *)params WithCompletion:(void (^)(Reservation *reservation, NSError *error))block;
+ (NSURLSessionDataTask *)sendReservedRequest:(NSDictionary *)params WithCompletion:(void (^)(NSDictionary *, NSError *))block;

+ (NSURLSessionDataTask *)reservationsWithBlock :(void (^)(NSArray *reservations, NSError *error))block;

+(NSURLSessionDataTask*)sendCheckReservationRequest:(NSString*)book_id WithCompletion:(void (^)(NSString *response, NSError *error))block;

@end
