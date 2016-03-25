//
//  Reports.h
//  Restotube
//
//  Created by Andrey Rebrik on 15.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Reports : NSObject

@property (nonatomic, strong) NSString *avatar;
@property (nonatomic) NSInteger childs_count;
@property (nonatomic) NSInteger created;
@property (nonatomic, strong) NSString *report_id;
@property (nonatomic, strong) NSString *img;
@property (nonatomic) NSInteger likes;
@property (nonatomic, strong) NSString *parent_id;
@property (nonatomic, strong) NSString *rest_id;
@property (nonatomic, strong) NSString *reportText;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *user_social_url;
@property (nonatomic, strong) NSString *hiRezPhoto;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
+ (NSURLSessionDataTask *)reportsForRestaurant:(NSString *)restaurantId parentId:(NSString *)parentIdOrNil photoSize:(CGSize)sizeOrZero withBlock:(void (^)(NSArray *restaurants, NSError *error))block;

- (NSURLSessionDataTask *)likeReportForUser:(NSString *)userHash withCompletion:(void (^)(NSError *error))block;

@end

