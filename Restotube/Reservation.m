//
//  Reservation.m
//  Restotube
//
//  Created by Andrey Rebrik on 15.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "Reservation.h"
#import "RequestManager.h"
#import "Profile.h"
#import "ParseMethods.h"


@implementation Reservation

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.book_id = [attributes valueForKey:@"id"];
    self.address = [attributes valueForKey:@"address"];
    self.book_id = [attributes valueForKey:@"book_id"];
    self.col = [attributes valueForKey:@"col"];
    self.date = [attributes valueForKey:@"date"];
    self.reservation_hash = [attributes valueForKey:@"hash"];
    self.reservation_id = [attributes valueForKey:@"id"];
    self.resto = [attributes valueForKey:@"resto"];
    self.sale = [attributes valueForKey:@"sale"];
    self.address = [attributes valueForKey:@"address"];
    self.sale_url = [attributes valueForKey:@"sale_url"];
    self.time = [attributes valueForKey:@"time"];
    self.presentDesc = stringValue(attributes[@"present"]);
    self.payment_id = [attributes valueForKey:@"payment_id"];
    self.sum = [attributes valueForKey:@"sum"];
    
    return self;
}
//55a7a04f9785d


+ (NSURLSessionDataTask *)sendReserveRequest:(NSDictionary *)params WithCompletion:(void (^)(Reservation *, NSError *))block
{
    NSString* urlrequest = [NSString stringWithFormat:@"book"];
    
    return [[RequestManager sharedManager] GET:urlrequest parameters:params success:^(NSURLSessionDataTask * __unused task, id JSON)
            {
                // TODO: remove this, server must send non-200 response
                if (JSON[@"errors"]) {
                    if (block) block(nil, [NSError errorWithDomain:@"ApiError" code:0 userInfo:JSON]);
                    return;
                }
                Reservation *reservation = [[Reservation alloc] initWithAttributes:(NSDictionary *)JSON];
                
                if (block) block(reservation, nil);
            }
                                       failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                if (block) block(nil, error);
            }];
}

+ (NSURLSessionDataTask *)sendReservedRequest:(NSDictionary *)params WithCompletion:(void (^)(NSDictionary *, NSError *))block
{
    NSString* urlrequest = [NSString stringWithFormat:@"BookPaid"];
    
    return [[RequestManager sharedManager] GET:urlrequest parameters:params success:^(NSURLSessionDataTask * __unused task, id JSON)
            {
                if (block) block(nil, nil);
            }
                                       failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                if (block) block(nil, error);
            }];
}


+ (NSURLSessionDataTask *)reservationsWithBlock:(void (^)(NSArray *reservations, NSError *error))block {
    NSString* urlrequest = [NSString stringWithFormat:@"getBookList?hash=%@&show=all",[[Profile getInstance] m_hash]];
    
    return [[RequestManager sharedManager] GET:urlrequest parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *reservatopmsFromResponce = JSON;
        NSMutableArray *mulableReservations = [NSMutableArray arrayWithCapacity:[reservatopmsFromResponce count]];
        for (NSDictionary *attributes in reservatopmsFromResponce) {
            Reservation *res = [[Reservation alloc] initWithAttributes:attributes];
            [mulableReservations addObject:res];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mulableReservations], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

+(NSURLSessionDataTask*)sendCheckReservationRequest:(NSString*)book_id WithCompletion:(void (^)(NSString *response, NSError *))block
{
//    NSString *urlrequest = @"getBookStatus";
//    NSDictionary *params = [NSDictionary dictionaryWithObject:reservation.book_id forKey:@"book_id"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@api/getBookStatus?book_id=%@", [RequestManager sharedManager].assetsBaseUrl, book_id];
    NSURL *url = [NSURL URLWithString:urlString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//    NSURLSessionDataTask *dataTask = [[RequestManager sharedManager] dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        ;
//    }];
//    [dataTask resume];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableData *muData = [[NSMutableData alloc] initWithData:data];
            const char nilChar = '\0';
            [muData appendBytes:&nilChar length:sizeof(nilChar)];
            
            NSString *dataString = [NSString stringWithUTF8String:[muData bytes]];
//            NSString *dataCString = [NSString stringWithCharacters:muData.bytes length:data.length];
//            NSString *dataHeyHo = [NSString stringWithCString:muData.bytes encoding:NSASCIIStringEncoding];
//            NSLog(@"data: %s", muData.bytes);
            block(dataString, connectionError);
        });
        
    }];
    return nil;
}

@end
