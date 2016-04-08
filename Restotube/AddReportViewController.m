//
//  AddReportViewController.m
//  Restotube
//
//  Created by Andrey Rebrik on 15.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "AddReportViewController.h"
#import "Profile.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "RequestManager.h"
#import "RestaurantsDetailViewController.h"

#define TEXT_VIEW_PLACEHOLDER @"Напишите Ваш отзыв..."

@implementation AddReportViewController
{
    NSString *photoId;
    BOOL isPhotoSending;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [commentTextView.layer setBorderColor:[[UIColor colorWithRed:167.0/255.0 green:169.0/255.0 blue:172.0/255.0 alpha:1.0] CGColor]];
    commentTextView.layer.borderWidth = 1.0f;
    [addPhotoButton.layer setBorderColor:[[UIColor colorWithRed:167.0/255.0 green:169.0/255.0 blue:172.0/255.0 alpha:1.0] CGColor]];
    addPhotoButton.layer.borderWidth = 1.0f;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMMM yyyy"];
    
    NSString *nameString = @"";
    if ([Profile getInstance].m_name)
        nameString = [Profile getInstance].m_name;
    else if ([Profile getInstance].m_surname)
        nameString = [NSString stringWithFormat:@"%@ %@", nameString, [Profile getInstance].m_surname];
    if ([nameString isEqualToString:@""])
        nameString = @"Гость";
    
    userLabel.text = [NSString stringWithFormat:@"%@\n%@", nameString, [formatter stringFromDate:date]];
    
    if ([Profile getInstance].m_image && ![[Profile getInstance].m_image isEqualToString:@""])
    {
        avatarImageView.image = nil;
        avatarImageView.layer.masksToBounds = YES;
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2;

        NSURL *assetsBaseUrl = [RequestManager sharedManager].assetsBaseUrl;
        NSURL *avatarUrl = [[NSURL alloc] initWithString:[Profile getInstance].m_image relativeToURL:assetsBaseUrl];
        NSURLRequest* avatarRequest = [NSURLRequest requestWithURL:avatarUrl];

        __weak UIImageView *weakAvatarImageView = avatarImageView;
        
        [avatarImageView setImageWithURLRequest:avatarRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
         {
             UIImageView *strongImageView = weakAvatarImageView;
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
             NSLog(@"error2: %@", error);
         }];
    }

}

- (IBAction)onButtonBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addPhotoPressed:(id)sender
{
    if ([commentTextView isFirstResponder])
        [commentTextView resignFirstResponder];
    
    JSImagePickerViewController *imagePicker = [[JSImagePickerViewController alloc] init];
    imagePicker.delegate = self;
    [imagePicker showImagePickerInController:self animated:YES];
}

- (void)imagePickerDidSelectImage:(UIImage *)image
{
    photoImageView.image = image;
    addPhotoButton.hidden = YES;
    photoView.hidden = NO;
    
    CGFloat correctImageViewHeight = (photoImageView.frame.size.width / image.size.width) * image.size.height;
    
    photoImageView.frame = CGRectMake(  photoImageView.frame.origin.x,
                                      photoImageView.frame.origin.x,
                                      CGRectGetWidth(photoImageView.bounds),
                                      correctImageViewHeight);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    isPhotoSending = YES;
    [manager POST:@"http://restotube.ru/api/addReportFoto" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(photoImageView.image)  name:@"filename" fileName:@"filename.png" mimeType:@"image/png"];
        if ([[Profile getInstance] m_hash])
            [formData appendPartWithFormData:[[[Profile getInstance] m_hash] dataUsingEncoding:NSUTF8StringEncoding] name:@"hash"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        photoId = responseObject[@"id"];
        NSLog(@"Success: %@", responseObject);
        isPhotoSending = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error3: %@", error);
        [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Не удалось загрузить изображение" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        [self deletePhotoPressed:nil];
        isPhotoSending = NO;
    }];
}

- (void)sendPressed:(id)sender
{
    if ([commentTextView.text isEqualToString:@""] || [commentTextView.text isEqualToString:TEXT_VIEW_PLACEHOLDER])
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Введите Ваш отзыв для отправки" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    if (!isPhotoSending)
    {
        NSString* urlrequest = [NSString stringWithFormat:@"addReport?id_item=%@&text=%@&hash=%@", _restaurantId, [commentTextView.text stringByAddingPercentEscapesUsingEncoding:                                                                                                       NSUTF8StringEncoding], [Profile getInstance].m_hash ? [Profile getInstance].m_hash : @""];
        if (photoId)
            urlrequest = [NSString stringWithFormat:@"%@&file_id=%@", urlrequest, photoId];
//        if (parentIdOrNil)
//            urlrequest = [NSString stringWithFormat:@"%@&params[parent_id]=%@", urlrequest, parentIdOrNil];
        
        [[RequestManager sharedManager] GET:urlrequest parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON)
                {
                   NSLog(@"Success: %@", JSON);
                    [[[UIAlertView alloc] initWithTitle:nil message:@"Отзыв отправлен" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                    
                    UIViewController *restaurauntDetail;
                    
                    for (UIViewController *controller in self.navigationController.viewControllers)
                    {
                        if ([controller isKindOfClass:[RestaurantsDetailViewController class]])
                        {
                            restaurauntDetail = controller;
                            break;
                        }
                    }
                    
                    if (restaurauntDetail)
                        [self.navigationController popToViewController:restaurauntDetail animated:YES];
                    else
                        [self.navigationController popViewControllerAnimated:YES];
                    
                } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                    NSLog(@"error4: %@", error);
                }];
    }
    else
        [[[UIAlertView alloc] initWithTitle:nil message:@"Подождите, идет отправка изображения" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

- (void)deletePhotoPressed:(id)sender
{
    photoImageView.image = nil;
    addPhotoButton.hidden = NO;
    photoView.hidden = YES;
    photoId = nil;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [textView setTextColor:[UIColor blackColor]];
    
    if ([textView.text isEqualToString:TEXT_VIEW_PLACEHOLDER])
    {
        textView.text = @"";
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.text = TEXT_VIEW_PLACEHOLDER;
        textView.textColor = [UIColor lightGrayColor];
    }
}

@end