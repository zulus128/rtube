//
//  Restaurants.m
//  Restotube
//
//  Created by Maksim Kis on 08.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "Restaurants.h"
#import "RequestManager.h"
#import "ConstantsManager.h"
#import "Filters.h"
#import "MapsInstance.h"
#import "ParseMethods.h"

@implementation Addresses

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    if (attributes[@"email"] && attributes[@"email"] != [NSNull null])
        self.email = attributes[@"email"];
    else
        self.email = @"";
    
    if (attributes[@"id"] && attributes[@"id"] != [NSNull null])
        self.address_Id = attributes[@"id"];
    else
        self.address_Id = @"";
    
    if (attributes[@"lat"] && attributes[@"lat"] != [NSNull null])
        self.lat = attributes[@"lat"];
    else
        self.lat = @"";
    
    if (attributes[@"lon"] && attributes[@"lon"] != [NSNull null])
        self.lon = attributes[@"lon"];
    else
        self.lon = @"";
    
    if (attributes[@"name"] && attributes[@"name"] != [NSNull null])
        self.name = attributes[@"name"];
    else
        self.name = @"";
    
    if (attributes[@"phone"] && attributes[@"phone"] != [NSNull null])
        self.phone = attributes[@"phone"];
    else
        self.phone = @"";
    
    return self;
}

@end


@implementation Video

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        if (attributes[@"dur"] && attributes[@"dur"] != [NSNull null])
            self.dur = [attributes[@"dur"] integerValue];
        else
            self.dur = 0;
        
        if (attributes[@"id"] && attributes[@"id"] != [NSNull null])
            self.video_id = attributes[@"id"];
        else
            self.video_id = @"";
        
        if (attributes[@"file"] && attributes[@"file"] != [NSNull null])
            self.file = attributes[@"file"];
        else
            self.file = @"";
    }
    
    return self;
}
@end


@implementation Restaurants

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }

    self.restaurant_Id = [attributes valueForKey:@"id"];
    self.sale = [attributes valueForKey:@"sale"];
    self.work_time = [attributes valueForKey:@"work_time"];
    self.img = [attributes valueForKey:@"img"];
    self.likes = [[attributes valueForKey:@"likes"] integerValue];
    self.views = [[attributes valueForKey:@"view"] integerValue];
    self.name = [attributes valueForKey:@"name"];

    if (![attributes valueForKey:@"averages"] || [attributes valueForKey:@"averages"] == [NSNull null])
        self.averages = @"";
    else
        self.averages = [NSString stringWithFormat:@"Средний счет %@", [attributes valueForKey:@"averages"]];


    if((NSNull *)self.sale == [NSNull null]) {
        self.sale = @"";
        self.saleint = 0;
    }
    else {
        self.saleint = [self.sale integerValue];
        self.sale = [NSString stringWithFormat:@"Скидка %@ %%", self.sale];
    }
    
    
    if ([attributes valueForKey:@"addresses"] && [attributes valueForKey:@"addresses"] != [NSNull null])
    {
        NSMutableArray *tempAdr = [NSMutableArray array];
        for (NSDictionary *dictionary in [attributes valueForKey:@"addresses"])
        {
            Addresses *address = [[Addresses alloc] initWithAttributes:dictionary];
            [tempAdr addObject:address];
        }
        self.addresses = [NSArray arrayWithArray:tempAdr];
    }
    else
        self.addresses = [NSArray array];
    
    NSDictionary *present = attributes[@"present"];
    if (present != nil) {
        self.presentDesc = stringValue(present[@"desc"]);
        self.presentImg = stringValue(present[@"img"]);
    }
    
    return self;
}

- (void) updateInfoWithAttributes:(NSDictionary *)attributes
{    
    self.likes = [[attributes valueForKey:@"likes"] integerValue];
    self.views = [[attributes valueForKey:@"view"] integerValue];
    
    if (![attributes valueForKey:@"work_time"] || [attributes valueForKey:@"work_time"] == [NSNull null])
        self.work_time = @"";
    else
        self.work_time = [NSString stringWithFormat:@"%@", [attributes valueForKey:@"work_time"]];
    
    
    if (![attributes valueForKey:@"sale"] || [attributes valueForKey:@"sale"] == [NSNull null]) {
        self.sale = @"";
        self.saleint = 0;
    }
    else {
        self.saleint = [[attributes valueForKey:@"sale"] integerValue];
        self.sale = [NSString stringWithFormat:@"Скидка %@ %%", [attributes valueForKey:@"sale"]];
    }
    
    
    if (![attributes valueForKey:@"averages"] || [attributes valueForKey:@"averages"] == [NSNull null])
        self.averages = @"";
    else
        self.averages = [NSString stringWithFormat:@"Средний счет %@", [attributes valueForKey:@"averages"]];
    
    if (attributes[@"cuisines"] && attributes[@"cuisines"] != [NSNull null])
        self.cuisines = [NSArray arrayWithArray:[attributes valueForKey:@"cuisines"]];
    else
        self.cuisines = [NSArray array];
    
    if (attributes[@"desc"] && attributes[@"desc"] != [NSNull null])
        self.desc = attributes[@"desc"];
    else
        self.desc = @"";
    
    if ([attributes valueForKey:@"fb_share"] && [attributes valueForKey:@"fb_share"] != [NSNull null])
        self.fb_share = [attributes valueForKey:@"fb_share"];
    else
        self.fb_share = @"";
    
    if ([attributes valueForKey:@"features"] && [attributes valueForKey:@"features"] != [NSNull null])
        self.features = [NSArray arrayWithArray:[attributes valueForKey:@"features"]];
    else
        self.features = [NSArray array];
    
    if ([attributes valueForKey:@"images"] && [attributes valueForKey:@"images"] != [NSNull null])
        self.images = [NSArray arrayWithArray:[attributes valueForKey:@"images"]];
    else
        self.images = [NSArray array];
    
    if ([attributes valueForKey:@"try"] && [attributes valueForKey:@"try"] != [NSNull null])
        self.try_ = [attributes valueForKey:@"try"];
    else
        self.try_ = @"";
    
    if ([attributes valueForKey:@"try_cost"] && [attributes valueForKey:@"try_cost"] != [NSNull null])
        self.try_cost = [attributes valueForKey:@"try_cost"];
    else
        self.try_cost = @"";
    
    if ([attributes valueForKey:@"try_image"] && [attributes valueForKey:@"try_image"] != [NSNull null])
        self.try_image = [attributes valueForKey:@"try_image"];
    else
        self.try_image = @"";
    
    if ([attributes valueForKey:@"types"] && [attributes valueForKey:@"types"] != [NSNull null])
        self.types = [NSArray arrayWithArray:[attributes valueForKey:@"types"]];
    else
        self.types = [NSArray array];
    
    if ([attributes valueForKey:@"video_img"] && [attributes valueForKey:@"video_img"] != [NSNull null])
        self.video_img = [attributes valueForKey:@"video_img"];
    else
        self.video_img = @"";
    
    if ([attributes valueForKey:@"vk_share"] && [attributes valueForKey:@"vk_share"] != [NSNull null])
        self.vk_share = [attributes valueForKey:@"vk_share"];
    else
        self.vk_share = @"";
    
    if ([attributes valueForKey:@"addresses"] && [attributes valueForKey:@"addresses"] != [NSNull null])
    {
        NSMutableArray *tempAdr = [NSMutableArray array];
        for (NSDictionary *dictionary in [attributes valueForKey:@"addresses"])
        {
            Addresses *address = [[Addresses alloc] initWithAttributes:dictionary];
            [tempAdr addObject:address];
        }
        self.addresses = [NSArray arrayWithArray:tempAdr];
    }
    else
        self.addresses = [NSArray array];
    
    if ([attributes valueForKey:@"video"] && [attributes valueForKey:@"video"] != [NSNull null])
    {
        NSMutableArray *tmpvideo = [NSMutableArray array];
        for (NSDictionary *dictionary in [attributes valueForKey:@"video"])
        {
            Video *video = [[Video alloc] initWithAttributes:dictionary];
            [tmpvideo addObject:video];
        }
        self.video = [NSArray arrayWithArray:tmpvideo];
    }
    else
        self.video = [NSArray array];
    
    NSDictionary *present = attributes[@"present"];
    if (present != nil)
    {
        self.presentDesc = stringValue(present[@"desc"]);
        self.presentImg = stringValue(present[@"img"]);
    }
}

- (void)addHiResPhotos:(NSDictionary *)attributes
{
    if ([attributes valueForKey:@"images"] && [attributes valueForKey:@"images"] != [NSNull null])
        self.hiResPhotos = [NSArray arrayWithArray:[attributes valueForKey:@"images"]];
    else
        self.hiResPhotos = [NSArray array];
}

- (NSString *)addressListToText
{
    NSString *fullAddressString = @"";
    
    for (Addresses *address in _addresses)
    {
        if ([fullAddressString isEqualToString:@""])
            fullAddressString = [NSString stringWithString:address.name];
        else
            fullAddressString = [NSString stringWithFormat:@"%@\n%@", fullAddressString, address.name];
    }
    
    return fullAddressString;
}

- (NSAttributedString *)featuresText
{
    NSString *allText = @"Время работы, кухня, особенности";
    NSRange titleRange = NSMakeRange(0, allText.length);
    UIFont *font = [UIFont systemFontOfSize:12];
    
    NSString *cuisinesString = @"", *featuresString = @"";
    
    for (NSNumber *number in _features)
    {
        for (Features *feature in [ConstantsManager getInstance].features)
        {
            if (feature.type_id.integerValue == number.integerValue)
            {
                if ([featuresString isEqualToString:@""])
                    featuresString = [NSString stringWithString:feature.name];
                else
                    featuresString = [NSString stringWithFormat:@"%@, %@", featuresString, feature.name];
                break;
            }
        }
    }
    
    for (NSNumber *number in _cuisines)
    {
        for (Cuisines *cuisine in [ConstantsManager getInstance].cuisines)
        {
            if (cuisine.type_id.integerValue == number.integerValue)
            {
                if ([cuisinesString isEqualToString:@""])
                    cuisinesString = [NSString stringWithString:cuisine.name];
                else
                    cuisinesString = [NSString stringWithFormat:@"%@, %@", cuisinesString, cuisine.name];
                break;
            }
        }
    }
    
    if (![_work_time isEqualToString:@""])
        allText = [NSString stringWithFormat:@"%@\n\0Время работы: %@", allText, _work_time];
    if (![cuisinesString isEqualToString:@""])
        allText = [NSString stringWithFormat:@"%@\n\0Кухня: %@", allText, cuisinesString];
    if (![featuresString isEqualToString:@""])
        allText = [NSString stringWithFormat:@"%@\n\0Особенности: %@", allText, featuresString];
    
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:allText];
    
    [resultString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(titleRange.length, 2)];//костыль для отступа, лайнспэйсинг обрезает текст
    [resultString addAttribute:NSFontAttributeName value:font range:NSMakeRange(titleRange.length + 2, allText.length - titleRange.length - 2)];
    
    return resultString;
}

+ (NSURLSessionDataTask *)restaurantsWithBlock:(float) cellWidth : (float) cellHeight : (int) offset : (int) limit : (void (^)(NSArray *restaurants, NSError *error))block {
    
    NSString* urlrequest = [NSString stringWithFormat:@"getRestaurants?params[img][width]=%f&params[img][height]=%f&params[img][method]=crop", cellWidth, cellHeight];
    
    if(![[[Filters getInstance] categoryId] isEqualToString:@""]) {
        urlrequest = [NSString stringWithFormat:@"%@&params[category]=%@", urlrequest, [[Filters getInstance] categoryId]];
    }
    
    if([[MapsInstance getInstance] myLocationLoaded] == YES) {
        double latitude = 0;
        double longitude = 0;
        [[MapsInstance getInstance] getMyCoordinames:&latitude :&longitude];
        urlrequest = [NSString stringWithFormat:@"%@&params[lat]=%f&params[lon]=%f", urlrequest, latitude, longitude];
    }
    
    if([[[Filters getInstance] selectedFeatures] count]) {
        
        for( NSUInteger i = 0; i < [[[Filters getInstance] selectedFeatures] count] ; i++) {
            NSNumber* selected_id = [[[Filters getInstance] selectedFeatures] objectAtIndex:i];
            urlrequest = [NSString stringWithFormat:@"%@&params[filter][f][]=%ld", urlrequest, (long)[selected_id integerValue] ];
        }
    }
    
    if([[[Filters getInstance] selectedMetro] count]) {
        for( NSUInteger i = 0; i < [[[Filters getInstance] selectedMetro] count] ; i++) {
            FiltersSelected* selected_id = [[[Filters getInstance] selectedMetro] objectAtIndex:i];
            urlrequest = [NSString stringWithFormat:@"%@&params[filter][m][]=%@", urlrequest, selected_id.selectedId ];
        }
    }
    
    if([[[Filters getInstance] selectedTypes] count]) {
        for( NSUInteger i = 0; i < [[[Filters getInstance] selectedTypes] count] ; i++) {
            FiltersSelected* selected_id = [[[Filters getInstance] selectedTypes] objectAtIndex:i];
            urlrequest = [NSString stringWithFormat:@"%@&params[filter][t][]=%@", urlrequest, selected_id.selectedId ];
        }
    }
    
    if([[[Filters getInstance] selectedAverages] count]) {
        for( NSUInteger i = 0; i < [[[Filters getInstance] selectedAverages] count] ; i++) {
            FiltersSelected* selected_id = [[[Filters getInstance] selectedAverages] objectAtIndex:i];
            urlrequest = [NSString stringWithFormat:@"%@&params[filter][a][]=%@", urlrequest, selected_id.selectedId ];
        }
    }
    
    if([[[Filters getInstance] selectedCuisines] count]) {
        for( NSUInteger i = 0; i < [[[Filters getInstance] selectedCuisines] count] ; i++) {
            FiltersSelected* selected_id = [[[Filters getInstance] selectedCuisines] objectAtIndex:i];
            urlrequest = [NSString stringWithFormat:@"%@&params[filter][c][]=%@", urlrequest, selected_id.selectedId ];
        }
    }
    
    if(![[[Filters getInstance] searchText] isEqualToString:@""]) {
        NSString* str = [[[Filters getInstance] searchText] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        urlrequest = [NSString stringWithFormat:@"%@&params[filter][search]=%@", urlrequest, str];
    }
    
    
    urlrequest = [NSString stringWithFormat:@"%@&params[arr]=mini", urlrequest];
    
    if(cellHeight == 0 && cellWidth == 0) {
        urlrequest = [NSString stringWithFormat:@"getRestaurants?params[arr]=map&params[limit]=999"];
        [[[RequestManager sharedManager] session] configuration ].timeoutIntervalForRequest = 120;
    }
    else {
        urlrequest = [NSString stringWithFormat:@"%@&params[offset]=%d&params[limit]=%d", urlrequest, offset, limit];
    }

    return [[RequestManager sharedManager] GET:urlrequest parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *restaurantsFromResponce = JSON;
        NSMutableArray *mulableRestaurants = [NSMutableArray arrayWithCapacity:[restaurantsFromResponce count]];
        for (NSDictionary *attributes in restaurantsFromResponce) {
            Restaurants *res = [[Restaurants alloc] initWithAttributes:attributes];
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

+ (NSURLSessionDataTask *)restaurantsSearchWithBlock:(void (^)(NSArray *restaurants, NSError *error))block {
    
    NSString* urlrequest = [NSString stringWithFormat:@"getRestaurants?params[arr]=map&params[limit]=999"];
    
    //    if(![[[Filters getInstance] categoryId] isEqualToString:@""]) {
    //        urlrequest = [NSString stringWithFormat:@"%@&params[category]=%@", urlrequest, [[Filters getInstance] categoryId]];
    //    }
    
    if([[MapsInstance getInstance] myLocationLoaded] == YES) {
        double latitude = 0;
        double longitude = 0;
        [[MapsInstance getInstance] getMyCoordinames:&latitude :&longitude];
        urlrequest = [NSString stringWithFormat:@"%@&params[lat]=%f&params[lon]=%f", urlrequest, latitude, longitude];
    }
    
    //    if([[[Filters getInstance] selectedFeatures] count]) {
    //
    //        for( NSUInteger i = 0; i < [[[Filters getInstance] selectedFeatures] count] ; i++) {
    //            NSNumber* selected_id = [[[Filters getInstance] selectedFeatures] objectAtIndex:i];
    //            urlrequest = [NSString stringWithFormat:@"%@&params[filter][f][]=%ld", urlrequest, (long)[selected_id integerValue] ];
    //        }
    //    }
    
    //    if([[[Filters getInstance] selectedMetro] count]) {
    //        for( NSUInteger i = 0; i < [[[Filters getInstance] selectedMetro] count] ; i++) {
    //            FiltersSelected* selected_id = [[[Filters getInstance] selectedMetro] objectAtIndex:i];
    //            urlrequest = [NSString stringWithFormat:@"%@&params[filter][m][]=%@", urlrequest, selected_id.selectedId ];
    //        }
    //    }
    //
    //    if([[[Filters getInstance] selectedTypes] count]) {
    //        for( NSUInteger i = 0; i < [[[Filters getInstance] selectedTypes] count] ; i++) {
    //            FiltersSelected* selected_id = [[[Filters getInstance] selectedTypes] objectAtIndex:i];
    //            urlrequest = [NSString stringWithFormat:@"%@&params[filter][t][]=%@", urlrequest, selected_id.selectedId ];
    //        }
    //    }
    //
    //    if([[[Filters getInstance] selectedAverages] count]) {
    //        for( NSUInteger i = 0; i < [[[Filters getInstance] selectedAverages] count] ; i++) {
    //            FiltersSelected* selected_id = [[[Filters getInstance] selectedAverages] objectAtIndex:i];
    //            urlrequest = [NSString stringWithFormat:@"%@&params[filter][a][]=%@", urlrequest, selected_id.selectedId ];
    //        }
    //    }
    //
    //    if([[[Filters getInstance] selectedCuisines] count]) {
    //        for( NSUInteger i = 0; i < [[[Filters getInstance] selectedCuisines] count] ; i++) {
    //            FiltersSelected* selected_id = [[[Filters getInstance] selectedCuisines] objectAtIndex:i];
    //            urlrequest = [NSString stringWithFormat:@"%@&params[filter][c][]=%@", urlrequest, selected_id.selectedId ];
    //        }
    //    }
    
    if(![[[Filters getInstance] searchText] isEqualToString:@""]) {
        NSString* str = [[[Filters getInstance] searchText] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        urlrequest = [NSString stringWithFormat:@"%@&params[filter][search]=%@", urlrequest, str];
    }
    
    
    
    
    return [[RequestManager sharedManager] GET:urlrequest parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSArray *restaurantsFromResponce = JSON;
        NSMutableArray *mulableRestaurants = [NSMutableArray arrayWithCapacity:[restaurantsFromResponce count]];
        for (NSDictionary *attributes in restaurantsFromResponce) {
            Restaurants *res = [[Restaurants alloc] initWithAttributes:attributes];
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

- (NSURLSessionDataTask *)getFullInfoWithBlock:(float)cellWidth :(float)cellHeight :(void (^)(NSError *))block
{
    CGFloat scaleFactor=[[UIScreen mainScreen] scale];

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    NSString* urlrequest = [NSString stringWithFormat:@"getRestaurant?id=%@&"
                            "params[img][width]=%f&params[img][height]=%f&params[img][method]=crop&"
                            "params[images][width]=%f&params[images][height]=%f&params[images][method]=crop&"
                            "params[offset]=10&params[try_image][width]=%f&params[try_image][height]=%f"
                            ,
                            self.restaurant_Id, cellWidth*scaleFactor, cellHeight*scaleFactor, cellWidth*scaleFactor, cellHeight*scaleFactor, screenRect.size.height, screenRect.size.height];
    
    return [[RequestManager sharedManager] GET:urlrequest parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON)
            {
                [self updateInfoWithAttributes:(NSDictionary *)JSON];
                
                if (block) block(nil);
            }
                                       failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                if (block) block(error);
            }];
}

- (NSURLSessionDataTask *)getHiResPhotosWithBlock:(float) cellWidth :(float) cellHeight : (void (^)(NSError *error))block
{
    CGFloat scaleFactor=[[UIScreen mainScreen] scale];
    
    NSString* urlrequest = [NSString stringWithFormat:@"getRestaurant?id=%@&"
                            "params[img][width]=%f&params[img][height]=%f&params[img][method]=crop&"
                            "params[images][width]=%f&params[images][height]=%f&params[images][method]=crop&"
                            "params[offset]=10",
                            self.restaurant_Id, cellWidth*scaleFactor, cellHeight*scaleFactor, cellWidth*scaleFactor, cellHeight*scaleFactor];
    
    return [[RequestManager sharedManager] GET:urlrequest parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON)
            {
                [self addHiResPhotos:(NSDictionary *)JSON];
                
                if (block) block(nil);
            }
                                       failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                if (block) block(error);
            }];
}

- (NSURLSessionDataTask *)likeRestaurantForUser:(NSString *)userHash withCompletion:(void (^)(NSError *error))block
{
    NSString* urlrequest = [NSString stringWithFormat:@"setLike"];
    
    if (!userHash)
        userHash = @"";
    
    NSDictionary *params = @{@"id" : self.restaurant_Id, @"hash" : [userHash stringByAddingPercentEscapesUsingEncoding:                                                                                                       NSUTF8StringEncoding]};
    
    return [[RequestManager sharedManager] GET:urlrequest parameters:params success:^(NSURLSessionDataTask * __unused task, id JSON)
            {
                _likes = [[(NSDictionary *)JSON objectForKey:@"likes"] integerValue];
                
                if (block) block(nil);
            }
                                       failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                if (block) block(error);
            }];
}

@end