//
//  GalleryCollectionViewCell.h
//  Restotube
//
//  Created by Andrey Rebrik on 08.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) IBOutlet UIImageView *itemImageView;
@property (nonatomic, strong) IBOutlet UIButton *playButton;

- (void)fillWithImage:(NSString *)imagePath atIndexPath:(NSIndexPath *)indexPath;

@end