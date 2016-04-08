//
//  AddCommentViewController.m
//  Restotube
//
//  Created by Andrey Rebrik on 15.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "AddCommentViewController.h"
#import "Profile.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "RequestManager.h"
#import "RestaurantsDetailViewController.h"

#define TEXT_VIEW_PLACEHOLDER @"Напишите Ваш комментарий..."

@interface AddCommentViewController ()

@end

@implementation AddCommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [commentTextView.layer setBorderColor:[[UIColor colorWithRed:167.0/255.0 green:169.0/255.0 blue:172.0/255.0 alpha:1.0] CGColor]];
    commentTextView.layer.borderWidth = 1.0f;
    
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
             NSLog(@"error1: %@", error);
         }];
    }
}

- (IBAction)onButtonBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendPressed:(id)sender
{
    if ([commentTextView.text isEqualToString:@""] || [commentTextView.text isEqualToString:TEXT_VIEW_PLACEHOLDER])
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Введите Ваш комментарий для отправки" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
    NSString* urlrequest = [NSString stringWithFormat:@"addReport?id_item=%@&text=%@&hash=%@", _restaurantId, [commentTextView.text stringByAddingPercentEscapesUsingEncoding:                                                                                                       NSUTF8StringEncoding], [Profile getInstance].m_hash ? [Profile getInstance].m_hash : @""];
    if (_parentId)
        urlrequest = [NSString stringWithFormat:@"%@&parent_id=%@", urlrequest, _parentId];
    
    [[RequestManager sharedManager] GET:urlrequest parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON)
     {
         NSLog(@"Success: %@", JSON);
         [[[UIAlertView alloc] initWithTitle:nil message:@"Комментарий отправлен" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
         
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
         NSLog(@"Success: %@", error);
     }];
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