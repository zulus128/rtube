//
//  RequestManager.h
//  Restotube
//
//  Created by Maksim Kis on 04.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface RequestManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

- (NSURL *)assetsBaseUrl;

@end