//
//  RequestManager.m
//  Restotube
//
//  Created by Maksim Kis on 04.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "RequestManager.h"

//static NSString * const AssetsBaseUrlString = @"http://restotube.ru/";
//static NSString * const AppBaseUrlString = @"http://restotube.ru/api/";

static NSString * const AssetsBaseUrlString = @"https://restotube.ru/";
static NSString * const AppBaseUrlString = @"https://restotube.ru/api/";


@implementation RequestManager

+ (instancetype)sharedManager {
    static RequestManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[RequestManager alloc] initWithBaseURL:[NSURL URLWithString:AppBaseUrlString]];
        _sharedManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedManager.securityPolicy.validatesCertificateChain = NO;
        _sharedManager.securityPolicy.allowInvalidCertificates = YES;
    });
    
    return _sharedManager;
}

- (NSURL *)assetsBaseUrl
{
    return [NSURL URLWithString:AssetsBaseUrlString];
}

@end
