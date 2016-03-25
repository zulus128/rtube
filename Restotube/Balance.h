//
//  Balance.h
//  Restotube
//
//  Created by Victort on 04/09/15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface Balance : NSObject

+(NSURLSessionDataTask*) replenishBalanceRequest: (CGFloat)sum withCompletion:(void (^)(NSDictionary* responce, NSError* error))block;

@end
