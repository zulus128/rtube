//
//  ProfileView.m
//  Restotube
//
//  Created by Maksim Kis on 13.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "ProfileView.h"
#import "Profile.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "RSKImageCropViewController.h"
#import "AFNetworking.h"
#import "RequestManager.h"

@interface ProfileView () <RSKImageCropViewControllerDelegate, JSImagePickerViewControllerDelegate> {
    BOOL isImageChanged;
}

@end

@implementation ProfileView
- (void)viewDidLoad
{
    [super viewDidLoad];
    isImageChanged = NO;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickAvatar)];
    singleTap.numberOfTapsRequired = 1;
    [self.imageAvatar setUserInteractionEnabled:YES];
    [self.imageAvatar addGestureRecognizer:singleTap];
    
    self.labelBalance.text = [NSString stringWithFormat:@"%ld Руб", (long)[[Profile getInstance] m_balance]];
    self.textFieldName.text = [[Profile getInstance] m_name];
    self.textFieldLastName.text = [[Profile getInstance] m_surname];
    self.textFieldEmail.text = [[Profile getInstance] m_email];
    self.textFieldPassword.text = @"test";
    [self.textFieldPhone.formatter setDefaultOutputPattern:@"# (###) ###-##-##"];
    self.textFieldPhone.formatter.prefix = @"+";
    [self.textFieldPhone setFormattedText:[[Profile getInstance] m_phone]];
//    [self.textFieldPhone setEnabled:NO];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"head-line"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTranslucent:false];
    [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed: @"restotube-logo"]]];
    
    if(![[[Profile getInstance] m_image]  isEqual: @""]) {
        self.imageAvatar.contentMode = UIViewContentModeScaleAspectFit;
        self.imageAvatar.clipsToBounds = YES;

        NSURL *assetsBaseUrl = [RequestManager sharedManager].assetsBaseUrl;
        NSURL *avatarUrl = [[NSURL alloc] initWithString:[Profile getInstance].m_image relativeToURL:assetsBaseUrl];
        NSURLRequest* avatarRequest = [NSURLRequest requestWithURL:avatarUrl];
        [self.imageAvatar setImageWithURLRequest:avatarRequest
                                placeholderImage:[UIImage imageNamed:@"no-photo"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                    _imageAvatar.image = [self resizeImage:image imageSize: CGSizeMake(100, 100)];
                                    self.imageAvatar.layer.cornerRadius = 100 / 2;
                                    self.imageAvatar.layer.masksToBounds = YES;
                                    self.imageAvatar.layer.borderWidth  = 0;
                                }
                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
         {
             NSLog(@"error9: %@", error);
         }];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.textFieldName resignFirstResponder];
    [self.textFieldLastName resignFirstResponder];
    [self.textFieldEmail resignFirstResponder];
    [self.textFieldPassword resignFirstResponder];
    [self.textFieldPhone resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

- (IBAction)onButtonAddMoney:(id)sender {
    NSString* msg = [NSString stringWithFormat:@"http://restotube.ru/user/payment/create?user_id=%@d&sum=300", [[Profile getInstance] m_id]];
    NSURL* nsUrl = [NSURL URLWithString:[msg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:nsUrl] ;
}


- (IBAction)onButtonSaveSettings:(id)sender {
    if(isImageChanged) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:@"http://restotube.ru/api/setUserFoto" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:UIImagePNGRepresentation(self.imageAvatar.image)  name:@"filename" fileName:@"filename.png" mimeType:@"image/png"];
            [formData appendPartWithFormData:[[[Profile getInstance] m_hash] dataUsingEncoding:NSUTF8StringEncoding] name:@"hash"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@", responseObject);
            [self saveSettings];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ImageChanged"
             object:self];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    else {
        [self saveSettings];
    }
}

-(void)saveSettings {
    BOOL isSomeChanged = NO;
    __block BOOL isError = NO;
    NSString* url = [NSString stringWithFormat:@"http://restotube.ru/api/setUser?hash=%@", [[Profile getInstance] m_hash]];
    if(![self.textFieldName.text isEqual:[[Profile getInstance] m_name]]) {
        url = [NSString stringWithFormat:@"%@&params[name]=%@",url , [self.textFieldName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ] ];
        isSomeChanged = YES;
    }
    
    if(![self.textFieldLastName.text isEqual:[[Profile getInstance] m_surname]]) {
        url = [NSString stringWithFormat:@"%@&params[surname]=%@",url , [self.textFieldLastName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ] ];
        isSomeChanged = YES;
    }
        
    if(![self.textFieldEmail.text isEqual:[[Profile getInstance] m_email]]) {
        url = [NSString stringWithFormat:@"%@&params[email]=%@",url , [self.textFieldEmail.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
        isSomeChanged = YES;
    }
    
    if(![self.textFieldPassword.text isEqual:@"test"]) {
        url = [NSString stringWithFormat:@"%@&params[password]=%@",url ,[ self.textFieldPassword.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ] ];
        isSomeChanged = YES;
    }
    
    if(![self.textFieldPhone.text isEqual:[[Profile getInstance] m_phone]]) {
        NSString* phone = self.textFieldPhone.text ;
        
        phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"+7" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        if([phone length] < 10) {
            NSString * tmpTitle = [NSString stringWithUTF8String : "Restotube"];
            NSString * tmpMsg = [NSString stringWithUTF8String : "Телефон введен неверно"];
            UIAlertView *alert = [[UIAlertView alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert setTitle:tmpTitle];
            [alert setMessage:tmpMsg];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
            return;
        }
        
        url = [NSString stringWithFormat:@"%@&params[phone]=%@",url , phone];
        isSomeChanged = YES;
    }
    
    
    if(isSomeChanged == YES) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@", responseObject);
            
            [[Profile getInstance] initWithAttributes:responseObject];
            
            NSString * tmpTitle = [NSString stringWithUTF8String : "Restotube"];
            NSString * tmpMsg = [NSString stringWithUTF8String : "Настройки сохранены!"];
            UIAlertView *alert = [[UIAlertView alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert setTitle:tmpTitle];
            [alert setMessage:tmpMsg];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            isError = YES;
            NSString * tmpTitle = [NSString stringWithUTF8String : "Restotube"];
            NSString * tmpMsg = [NSString stringWithUTF8String : "Произошла неизвестная ошибка!"];
            UIAlertView *alert = [[UIAlertView alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert setTitle:tmpTitle];
            [alert setMessage:tmpMsg];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }];
    }
    else {
        if(isImageChanged) {
            NSString * tmpTitle = [NSString stringWithUTF8String : "Restotube"];
            NSString * tmpMsg = [NSString stringWithUTF8String : "Картинка сохранена!"];
            UIAlertView *alert = [[UIAlertView alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert setTitle:tmpTitle];
            [alert setMessage:tmpMsg];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
    }
}

-(void)onClickAvatar {
    JSImagePickerViewController *imagePicker = [[JSImagePickerViewController alloc] init];
    imagePicker.delegate = self;
    [imagePicker showImagePickerInController:self animated:YES];
    
}

- (UIViewController *)getCurrentRootViewController {
    
    UIViewController *result = nil;
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows)
        {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    id nextResponder = [rootView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil)
        result = topWindow.rootViewController;
    else
        NSAssert(NO, @"Could not find a root view controller.");
    
    return result;
}

- (void)imagePickerDidSelectImage:(UIImage *)image {
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
    imageCropVC.delegate = self;
    [self.navigationController pushViewController:imageCropVC animated:YES];
}

-(UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    //here is the scaled image which has been changed to the size specified
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image has been cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
{
    
    _imageAvatar.image = [self resizeImage:croppedImage imageSize: CGSizeMake(100, 100)];
    self.imageAvatar.layer.cornerRadius = 100 / 2;
    self.imageAvatar.layer.masksToBounds = YES;
    self.imageAvatar.layer.borderWidth  = 0;
//    self.imageAvatar.image = croppedImage;
    [self.navigationController popViewControllerAnimated:YES];
    isImageChanged = YES;
    
    
}

@end
