//
//  Restaurants.h
//  Restotube
//
//  Created by Maksim Kis on 08.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Addresses : NSObject
@property (nonatomic, strong) NSString *address_Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSDictionary *metro;
@property (nonatomic, strong) NSString *lon;
@property (nonatomic, strong) NSString *lat;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end


@interface Video : NSObject
@property (nonatomic) NSInteger dur;
@property (nonatomic, strong) NSString *file;
@property (nonatomic, strong) NSString *video_id;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end


@interface Restaurants : NSObject

@property (nonatomic, strong) NSString *restaurant_Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sale;
@property (nonatomic) NSInteger saleint;
@property (nonatomic, strong) NSString *work_time;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, assign) NSInteger likes;
@property (nonatomic, assign) NSInteger views;
@property (nonatomic, strong) NSString *desc;

@property (nonatomic, strong) NSString *try_;
@property (nonatomic, strong) NSString *try_cost;
@property (nonatomic, strong) NSString *try_image;
@property (nonatomic, strong) NSString *averages;
@property (nonatomic, strong) NSArray  *types;
@property (nonatomic, strong) NSArray  *features;
@property (nonatomic, strong) NSArray  *cuisines;
@property (nonatomic, strong) NSArray  *images;
@property (nonatomic, strong) NSArray  *video;
@property (nonatomic, strong) NSString* video_img;
@property (nonatomic, strong) NSString* vk_share;
@property (nonatomic, strong) NSString* fb_share;
@property (nonatomic, strong) NSArray* addresses;
@property (nonatomic, strong) NSArray *hiResPhotos;

@property (nonatomic, strong) NSString *presentDesc;
@property (nonatomic, strong) NSString *presentImg;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
+ (NSURLSessionDataTask *)restaurantsWithBlock:(float) cellWidth :(float) cellHeight :(int) offset : (int) limit :  (void (^)(NSArray *restaurants, NSError *error))block;
- (NSURLSessionDataTask *)getFullInfoWithBlock:(float) cellWidth :(float) cellHeight : (void (^)(NSError *error))block;
- (NSURLSessionDataTask *)getHiResPhotosWithBlock:(float) cellWidth :(float) cellHeight : (void (^)(NSError *error))block;
+ (NSURLSessionDataTask *)restaurantsSearchWithBlock:(void (^)(NSArray *restaurants, NSError *error))block;
- (NSURLSessionDataTask *)likeRestaurantForUser:(NSString *)userHash withCompletion:(void (^)(NSError *error))block;

- (NSString *)addressListToText;
- (NSAttributedString *)featuresText;

@end