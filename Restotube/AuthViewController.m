//
//  AuthViewController.m
//  Restotube
//
//  Created by Maksim Kis on 13.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "AuthViewController.h"
#import "Profile.h"
#import "UIAlertView+AFNetworking.h"

@implementation AuthViewController


-(void) viewDidLoad {
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
        
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) loggedInNotification:(NSNotification *) notification  {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onButtonLogin:(id)sender {
    [self.activityIndicator startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    NSURLSessionTask* task = [[Profile getInstance] profileAuthWithBlock:self.textfieldPhone.text :self.textFieldPassword.text :^(BOOL is_ok, NSError *error) {
        if(!error && is_ok) {
            NSString * tmpTitle = [NSString stringWithUTF8String : "Restotube"];
            NSString * tmpMsg = [NSString stringWithUTF8String : "Успешная авторизация"];
            UIAlertView *alert = [[UIAlertView alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert setTitle:tmpTitle];
            [alert setMessage:tmpMsg];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            [alert show];
        }
        
        [self.activityIndicator stopAnimating];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];

    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}


-(void)dismissKeyboard {
    [self.textfieldPhone resignFirstResponder];
     [self.textFieldPassword resignFirstResponder];
}

@end
