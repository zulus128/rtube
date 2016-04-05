//
//  Profile.h
//  Restotube
//
//  Created by Maksim Kis on 13.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Profile : NSObject


@property (nonatomic, strong) NSString *m_hash;
@property (nonatomic, strong) NSString *m_id;
@property (nonatomic, strong) NSString *m_email;
@property (nonatomic, strong) NSString *m_status;
@property (nonatomic, strong) NSString *m_name;
@property (nonatomic, strong) NSString *m_surname;
@property (nonatomic, strong) NSString *m_patronymic;
@property (nonatomic, strong) NSString *m_phone;
@property (nonatomic, strong) NSString *m_socialUrl;
@property (nonatomic, assign) NSInteger m_balance;
@property (nonatomic, strong) NSString *m_image;
@property (nonatomic, assign) NSInteger m_news;
@property (nonatomic, assign) NSInteger m_sex;
@property (nonatomic, assign) BOOL isProfileLoaded;

@property (nonatomic, strong) NSString *pushToken;

+ (Profile*)getInstance;
- (void)initWithAttributes:(NSDictionary *)attributes;
- (NSURLSessionDataTask *)profileRecoveryWithBlock: (NSString *) phone : (void (^)(BOOL is_ok, NSError *error))block;
- (NSURLSessionDataTask *)profileAuthWithBlock: (NSString *) phone : (NSString *) code : (void (^)(BOOL is_ok, NSError *error))block;
- (NSURLSessionDataTask *)profileAuthByHashWithBlock: (NSString *) hash : (void (^)(BOOL is_ok, NSError *error))block;
@end
