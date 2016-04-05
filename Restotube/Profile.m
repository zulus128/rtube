//
//  Profile.m
//  Restotube
//
//  Created by Maksim Kis on 13.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "Profile.h"
#import "RequestManager.h"
#import <Foundation/Foundation.h>
#import "AppDelegate.h"

static Profile* s_Profile = nil;

@implementation Profile

+ (Profile*)getInstance {
    if (s_Profile == nil) {
        s_Profile = [[Profile alloc] init];
    }
    
    return s_Profile;
}

-(id)init {
    if (self = [super init]) {
        self.isProfileLoaded = NO;
    }
    
    return self;
}

- (void)initWithAttributes:(NSDictionary *)attributes {
    
    NSLog(@"--- %@", attributes);
    NSLog(@"+++ %@", self.pushToken);
    
    if ([attributes valueForKey:@"hash"] && [attributes valueForKey:@"hash"] != [NSNull null])
        self.m_hash = [attributes valueForKey:@"hash"];
    else
        self.m_hash = @"";
    
    if ([attributes valueForKey:@"id"] && [attributes valueForKey:@"id"] != [NSNull null])
        self.m_id = [attributes valueForKey:@"id"];
    else
        self.m_id = @"";
    
    if ([attributes valueForKey:@"email"] && [attributes valueForKey:@"email"] != [NSNull null])
        self.m_email = [attributes valueForKey:@"email"];
    else
        self.m_email = @"";
    
    if ([attributes valueForKey:@"status"] && [attributes valueForKey:@"status"] != [NSNull null])
        self.m_status = [attributes valueForKey:@"status"];
    else
        self.m_status = @"";
    
    if ([attributes valueForKey:@"name"] && [attributes valueForKey:@"name"] != [NSNull null])
        self.m_name = [attributes valueForKey:@"name"];
    else
        self.m_name = @"";
    
    if ([attributes valueForKey:@"surname"] && [attributes valueForKey:@"surname"] != [NSNull null])
        self.m_surname = [attributes valueForKey:@"surname"];
    else
        self.m_surname = @"";
    
    if ([attributes valueForKey:@"patronymic"] && [attributes valueForKey:@"patronymic"] != [NSNull null])
        self.m_patronymic = [attributes valueForKey:@"patronymic"];
    else
        self.m_patronymic = @"";
    
    if ([attributes valueForKey:@"phone"] && [attributes valueForKey:@"phone"] != [NSNull null])
        self.m_phone = [attributes valueForKey:@"phone"];
    else
        self.m_phone = @"";
    
    if ([attributes valueForKey:@"social_url"] && [attributes valueForKey:@"social_url"] != [NSNull null])
        self.m_socialUrl = [attributes valueForKey:@"social_url"];
    else
        self.m_socialUrl = @"";
    
    if ([attributes valueForKey:@"balance"] && [attributes valueForKey:@"balance"] != [NSNull null])
        self.m_balance = [[attributes valueForKey:@"balance"] integerValue];
    else
        self.m_balance = 0;
    
    if ([attributes valueForKey:@"image"] && [attributes valueForKey:@"image"] != [NSNull null])
        self.m_image = [attributes valueForKey:@"image"];
    else
        self.m_image = @"";
    
    if ([attributes valueForKey:@"news"] && [attributes valueForKey:@"news"] != [NSNull null])
        self.m_news = [[attributes valueForKey:@"news"] integerValue];
    else
        self.m_news = 0;
    
    if ([attributes valueForKey:@"social_sex"] && [attributes valueForKey:@"social_sex"] != [NSNull null])
        self.m_sex = [[attributes valueForKey:@"social_sex"] integerValue];
    else
        self.m_sex = 0;
    
    
    if(![self.m_hash  isEqual: @""]) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"LoggedIn"
         object:self];
        [[NSUserDefaults standardUserDefaults] setObject:self.m_hash forKey:@"lambda"];
        [[NSUserDefaults standardUserDefaults] synchronize];
         self.isProfileLoaded = YES;
    }
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate registerTokenOnServer];
}

- (NSURLSessionDataTask *)profileRecoveryWithBlock: (NSString *) phone : (void (^)(BOOL is_ok, NSError *error))block {
    phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"+7" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString* urlrequest = [NSString stringWithFormat:@"forget?phone=%@", phone];
    
    return [[RequestManager sharedManager] GET:urlrequest parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        BOOL is_ok = true;
        
        if ([JSON valueForKey:@"error"] && [JSON valueForKey:@"error"] != [NSNull null]) {
            is_ok = false;
            NSString * tmpTitle = [NSString stringWithUTF8String : "Restotube"];
            NSString * tmpMsg = [JSON valueForKey:@"error"];
            UIAlertView *alert = [[UIAlertView alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert setTitle:tmpTitle];
            [alert setMessage:tmpMsg];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
        if (block) {
            block(is_ok, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(false, error);
        }
    }];
}

- (NSURLSessionDataTask *)profileAuthWithBlock: (NSString *) phone : (NSString *) code : (void (^)(BOOL is_ok, NSError *error))block {
    phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"+7" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString* urlrequest = [NSString stringWithFormat:@"auth?phone=%@&password=%@", phone, code];
    
    return [[RequestManager sharedManager] GET:urlrequest parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        BOOL is_ok = true;
        
        if ([JSON valueForKey:@"error"] && [JSON valueForKey:@"error"] != [NSNull null]) {
            is_ok = false;
            NSString * tmpTitle = [NSString stringWithUTF8String : "Restotube"];
            NSString * tmpMsg = [JSON valueForKey:@"error"];
            UIAlertView *alert = [[UIAlertView alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert setTitle:tmpTitle];
            [alert setMessage:tmpMsg];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
        else {
            [self initWithAttributes:JSON];
        }
        
        if (block) {
            block(is_ok, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(false, error);
        }
    }];
}

- (NSURLSessionDataTask *)profileAuthByHashWithBlock: (NSString *) hash : (void (^)(BOOL is_ok, NSError *error))block {
    NSString* urlrequest = [NSString stringWithFormat:@"getUser?hash=%@", hash];
    
    return [[RequestManager sharedManager] GET:urlrequest parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        BOOL is_ok = true;
        
        if ([JSON valueForKey:@"error"] && [JSON valueForKey:@"error"] != [NSNull null]) {
            is_ok = false;
            NSString * tmpTitle = [NSString stringWithUTF8String : "Restotube"];
            NSString * tmpMsg = [JSON valueForKey:@"error"];
            UIAlertView *alert = [[UIAlertView alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert setTitle:tmpTitle];
            [alert setMessage:tmpMsg];
            [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
            [alert show];
        }
        else {
            [self initWithAttributes:JSON];
        }
        
        if (block) {
            block(is_ok, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(false, error);
        }
    }];
}

@end
