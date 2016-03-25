//
//  GalleryCollectionViewCell.m
//  Restotube
//
//  Created by Andrey Rebrik on 08.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "GalleryCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "RequestManager.h"

@implementation GalleryCollectionViewCell

- (void)fillWithImage:(NSString *)imagePath atIndexPath:(NSIndexPath *)indexPath
{
    self.itemImageView.image = nil;

    NSURL *assetsBaseUrl = [RequestManager sharedManager].assetsBaseUrl;
    NSURL *imageUrl = [[NSURL alloc] initWithString:imagePath relativeToURL:assetsBaseUrl];
    NSURLRequest* req_bg = [NSURLRequest requestWithURL:imageUrl];
    
    __weak UIImageView *weakImageView = self.itemImageView;
    
    [self.itemImageView setImageWithURLRequest:req_bg placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
     {
        UIImageView *strongImageView = weakImageView;
        if (!strongImageView) return;
        
        [UIView transitionWithView:strongImageView
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            strongImageView.image = image;
                        }
                        completion:NULL];
    }
                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
    {
        NSLog(@"error: %@", error);
    }];

    _playButton.hidden = indexPath.row != 0;
    _playButton.tag = indexPath.row;
}

@end
