//
//  CategorieViewCell.m
//  Restotube
//
//  Created by Maksim Kis on 06.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "CategoriesViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "RequestManager.h"


@implementation CategoriesViewCell

- (void) awakeFromNib {

}



- (void) setCategory:(Categories *)category {
    category = category;
    self.labelTitle.text = category.title;
    NSURL *assetsBaseUrl = [RequestManager sharedManager].assetsBaseUrl;
    NSURL *iconUrl = [[NSURL alloc] initWithString:category.icon relativeToURL:assetsBaseUrl];
    NSURL *imgUrl = [[NSURL alloc] initWithString:category.img relativeToURL:assetsBaseUrl];
    NSURLRequest* req_bg = [NSURLRequest requestWithURL:imgUrl];
    NSURLRequest* req_ico = [NSURLRequest requestWithURL:iconUrl];
    __weak UIImageView *weakImageView = self.imageViewBackground;
    __weak UIImageView *weakImageIco = self.imageViewIcon;

    [self.imageViewBackground setImageWithURLRequest:req_bg placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        UIImageView *strongImageView = weakImageView;
        if (!strongImageView) return;
        
        [UIView transitionWithView:strongImageView
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            strongImageView.image = image;
                        }
                        completion:NULL];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"error: %@", error);
    }];
    
    
    [self.imageViewIcon setImageWithURLRequest:req_ico placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        UIImageView *strongImageViewIco = weakImageIco;
        if (!strongImageViewIco) return;
        
        [UIView transitionWithView:strongImageViewIco
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            strongImageViewIco.image = image;
                        }
                        completion:NULL];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"error: %@", error);
    }];

    [self setNeedsLayout];
}

@end
