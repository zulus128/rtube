//
//  Balance.m
//  Restotube
//
//  Created by Victort on 04/09/15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "Balance.h"
#import "Profile.h"
#import "RequestManager.h"

@implementation Balance

+(NSURLSessionDataTask*) replenishBalanceRequest: (CGFloat)sum withCompletion:(void (^)(NSDictionary*, NSError *))block
{
    NSString *url  = @"addToBalance";
    NSString *hash = [Profile getInstance].m_hash;
    NSDictionary *params = @{
                             @"hash"    : hash,
                             @"sum"     : @(sum)
                             };
    return [[RequestManager sharedManager] GET:url parameters:params success:^(NSURLSessionDataTask * __unused task, id JSON)
            {
                if (block) block(JSON, nil);
            }
            failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                if (block) block(nil, error);
            }];

}

@end
