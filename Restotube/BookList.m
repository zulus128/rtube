//
//  BookList.m
//  Restotube
//
//  Created by Maksim Kis on 15.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "BookList.h"
#import "RequestManager.h"
#import "Profile.h"
#import "ParseMethods.h"


@implementation BookList

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if ([attributes valueForKey:@"id"] && [attributes valueForKey:@"id"] != [NSNull null])
        self.book_Id = [attributes valueForKey:@"id"];
    else
        self.book_Id = @"";
    
    if ([attributes valueForKey:@"user_Id"] && [attributes valueForKey:@"user_Id"] != [NSNull null])
        self.user_Id = [attributes valueForKey:@"user_Id"];
    else
        self.user_Id = @"";
    
    if ([attributes valueForKey:@"datetime"] && [attributes valueForKey:@"datetime"] != [NSNull null])
        self.datetime = [attributes valueForKey:@"datetime"];
    else
        self.datetime = @"";
    
    if ([attributes valueForKey:@"book_datetime"] && [attributes valueForKey:@"book_datetime"] != [NSNull null])
        self.book_datetime = [attributes valueForKey:@"book_datetime"];
    else
        self.book_datetime = @"";
    
    if ([attributes valueForKey:@"amount"] && [attributes valueForKey:@"amount"] != [NSNull null])
        self.amount = [attributes valueForKey:@"amount"];
    else
        self.amount = @"";
    
    if ([attributes valueForKey:@"sale"] && [attributes valueForKey:@"sale"] != [NSNull null])
        self.sale = [attributes valueForKey:@"sale"];
    else
        self.sale = @"";
    
    if ([attributes valueForKey:@"sale_price"] && [attributes valueForKey:@"sale_price"] != [NSNull null])
        self.sale_price = [attributes valueForKey:@"sale_price"];
    else
        self.sale_price = @"";
    
    if ([attributes valueForKey:@"sale_status"] && [attributes valueForKey:@"sale_status"] != [NSNull null])
        self.sale_status = [attributes valueForKey:@"sale_status"];
    else
        self.sale_status = @"";
    
    if ([attributes valueForKey:@"comment"] && [attributes valueForKey:@"comment"] != [NSNull null])
        self.comment = [attributes valueForKey:@"comment"];
    else
        self.comment = @"";
    
    if ([attributes valueForKey:@"name"] && [attributes valueForKey:@"name"] != [NSNull null])
        self.name = [attributes valueForKey:@"name"];
    else
        self.name = @"";
    
    if ([attributes valueForKey:@"phone"] && [attributes valueForKey:@"phone"] != [NSNull null])
        self.phone = [attributes valueForKey:@"phone"];
    else
        self.phone = @"";
    
    if ([attributes valueForKey:@"resto"] && [attributes valueForKey:@"resto"] != [NSNull null])
        self.resto = [attributes valueForKey:@"resto"];
    else
        self.resto = @"";
    
    if ([attributes valueForKey:@"address"] && [attributes valueForKey:@"address"] != [NSNull null])
        self.address = [attributes valueForKey:@"address"];
    else
        self.address = @"";
    
    if ([attributes valueForKey:@"status_id"] && [attributes valueForKey:@"status_id"] != [NSNull null])
        self.status_id = [attributes valueForKey:@"status_id"];
    else
        self.status_id = @"";
    
    if ([attributes valueForKey:@"status_name"] && [attributes valueForKey:@"status_name"] != [NSNull null])
        self.status_name = [attributes valueForKey:@"status_name"];
    else
        self.status_name = @"";

    
    return self;
}


+ (NSURLSessionDataTask *)reservationsWithBlock:(void (^)(NSArray *reservations, NSError *error))block {
    NSString* urlrequest = [NSString stringWithFormat:@"getBookList?hash=%@&show=all",[[Profile getInstance] m_hash]];
    
    return [[RequestManager sharedManager] GET:urlrequest parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *reservatopmsFromResponce = JSON;
        NSMutableArray *mulableReservations = [NSMutableArray arrayWithCapacity:[reservatopmsFromResponce count]];
        for (NSDictionary *attributes in reservatopmsFromResponce) {
            BookList *res = [[BookList alloc] initWithAttributes:attributes];
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
@end
