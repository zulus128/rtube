//
//  RegisterViewController.m
//  Restotube
//
//  Created by Maksim Kis on 13.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "RegisterViewController.h"
#import "Profile.h"
#import "UIAlertView+AFNetworking.h"

@implementation RegisterViewController {
    BOOL isPhoneSent;
}


-(void) viewDidLoad {
    isPhoneSent = NO;
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"head-line"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTranslucent:false];
    [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed: @"restotube-logo"]]];
    [self.textfieldPhone.formatter setDefaultOutputPattern:@"(###) ###-##-##"];
    self.textfieldPhone.formatter.prefix = @"+7 ";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loggedInNotification:)
                                                 name:@"LoggedIn"
                                               object:nil];
    [self.textfieldPassword setHidden:YES];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) loggedInNotification:(NSNotification *) notification  {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickButton:(id)sender {
    if(isPhoneSent == NO) {
       
        [self.activityIndicator startAnimating];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        NSURLSessionTask* task = [[Profile getInstance] profileRecoveryWithBlock:self.textfieldPhone.text :^(BOOL is_ok, NSError *error) {
            if(!error) {
                if(is_ok) {
                    [self.buttonPass setTitle:@"Авторизация" forState:UIControlStateNormal];
                    [self.buttonPass setTitle:@"Авторизация" forState:UIControlStateHighlighted];
                    [self.textfieldPassword setHidden:NO ];
                    [self.textfieldPhone setHidden:YES ];
                    isPhoneSent = YES;
                }
            }
            [self.activityIndicator stopAnimating];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
        
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    }
    else {
        // have code
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self.activityIndicator startAnimating];
        NSURLSessionTask* task = [[Profile getInstance] profileAuthWithBlock: self.textfieldPhone.text : self.textfieldPassword.text :^(BOOL is_ok, NSError *error) {
            if(!error) {
                if(is_ok) {
                    NSString * tmpTitle = [NSString stringWithUTF8String : "Restotube"];
                    NSString * tmpMsg = [NSString stringWithUTF8String : "Успешная авторизация"];
                    UIAlertView *alert = [[UIAlertView alloc] init];
                    [alert addButtonWithTitle:@"OK"];
                    [alert setTitle:tmpTitle];
                    [alert setMessage:tmpMsg];
                    [alert setAlertViewStyle:UIAlertViewStyleDefault];
                    [alert show];
                }
            }
            [self.activityIndicator stopAnimating];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
        
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    }
}

-(void)dismissKeyboard {
    [self.textfieldPhone resignFirstResponder];
    [self.textfieldPassword resignFirstResponder];
}

@end
