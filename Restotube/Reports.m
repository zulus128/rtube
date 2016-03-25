//
//  Reports.m
//  Restotube
//
//  Created by Andrey Rebrik on 15.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "Reports.h"
#import "RequestManager.h"
#import "ParseMethods.h"

@implementation Reports

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if (self = [super init])
    {
        self.avatar = stringValue([attributes valueForKey:@"avatar"]);
        
        self.childs_count = [[attributes valueForKey:@"childs_count"] integerValue];
        self.created = [[attributes valueForKey:@"created"] integerValue];
        
        NSLog(@"Reports img: %@", [attributes objectForKey:@"img"]);
        
        self.img = stringValue([attributes objectForKey:@"img"]);
        
        self.likes = [[attributes valueForKey:@"likes"] integerValue];
        self.report_id = stringValue([attributes valueForKey:@"id"]);
        

        self.parent_id = stringValue([attributes valueForKey:@"parent_id"]);

        
        self.rest_id = [attributes valueForKey:@"rest"];
        self.reportText = [attributes valueForKey:@"text"];
        self.user_id = stringValue([attributes valueForKey:@"user_id"]);
        

        self.user_name = stringValue([attributes valueForKey:@"user_name"]);

        self.user_social_url = stringValue([attributes valueForKey:@"user_social_url"]);

    }

    return self;
}

+ (NSURLSessionDataTask *)reportsForRestaurant:(NSString *)restaurantId parentId:(NSString *)parentIdOrNil photoSize:(CGSize)sizeOrZero withBlock:(void (^)(NSArray *, NSError *))block
{
    NSString* urlrequest = [NSString stringWithFormat:@"getRestaurantReports?rest=%@", restaurantId];
    
    if (parentIdOrNil)
        urlrequest = [NSString stringWithFormat:@"%@&params[parent_id]=%@", urlrequest, parentIdOrNil];
    
    if (sizeOrZero.width != CGSizeZero.width || sizeOrZero.height != CGSizeZero.width)
    {
        CGFloat scaleFactor=[[UIScreen mainScreen] scale];
        urlrequest = [NSString stringWithFormat:@"%@&params[img][width]=%f&params[img][height]=%f", urlrequest, sizeOrZero.width*scaleFactor, sizeOrZero.height*scaleFactor];
    }
    
    return [[RequestManager sharedManager] GET:urlrequest parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON)
            {
                NSArray *restaurantsFromResponce = JSON;
                NSMutableArray *mulableRestaurants = [NSMutableArray arrayWithCapacity:[restaurantsFromResponce count]];
                
                for (NSDictionary *attributes in restaurantsFromResponce)
                {
                    Reports *res = [[Reports alloc] initWithAttributes:attributes];
                    [mulableRestaurants addObject:res];
                }
                
                if (block) {
                    block([NSArray arrayWithArray:mulableRestaurants], nil);
                }
            } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                if (block) {
                    block([NSArray array], error);
                }
            }];
}

- (NSURLSessionDataTask *)likeReportForUser:(NSString *)userHash withCompletion:(void (^)(NSError *error))block
{
    NSString* urlrequest = [NSString stringWithFormat:@"setReportLike"];
    
    if (!userHash)
        userHash = @"";
    
    NSDictionary *params = @{@"id" : self.report_id, @"hash" : userHash};
    
    return [[RequestManager sharedManager] GET:urlrequest parameters:params success:^(NSURLSessionDataTask * __unused task, id JSON)
            {
                NSNumber *likes = [(NSDictionary *)JSON objectForKey:@"likes"];
                if ([likes respondsToSelector:@selector(integerValue)])
                {
                    _likes = [likes integerValue];
                }
                else
                {
                    _likes = 0;
                }
                
                if (block) block(nil);
            }
                                       failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                if (block) block(error);
            }];
}

@end