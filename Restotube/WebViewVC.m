//
//  WebViewVC.m
//  YandexMoneyTest
//
//  Created by owel on 02/09/15.
//  Copyright (c) 2015 owel. All rights reserved.
//

#import "WebViewVC.h"
#import "Reservation.h"
#import "AppDelegate.h"
#import "Profile.h"

typedef void(^CheckCompletionBlock)(NSString*, NSError*);

@interface WebViewVC () <UIWebViewDelegate>

@property (strong, nonatomic) UIView    *topView;
@property (strong, nonatomic) UIButton  *backButton;
@property (strong, nonatomic) UIWebView *webView;

@property (copy,   nonatomic) CheckCompletionBlock  checkCompletionBlock;
@property (strong, nonatomic) NSTimer               *checkTimer;

@end

@implementation WebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 80)];
    _topView.backgroundColor = [UIColor lightGrayColor];
    
    _backButton = [UIButton new];
    [_backButton setTitle:@"< Back" forState:UIControlStateNormal];
    [_backButton sizeToFit];
    _backButton.frame = CGRectMake(10, _topView.frame.size.height / 2 - _backButton.frame.size.height / 2, _backButton.frame.size.width, _backButton.frame.size.height);
    [_backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
//    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, self.view.bounds.size.height - 80)];
    [_webView loadRequest:self.requestToLoad];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _webView.delegate = self;
    
    [self.topView addSubview:_backButton];
    
    [self.view addSubview:_webView];
    [self.view addSubview:_topView];
    
    if (self.book_id) // getBookStatus request
    {
        __weak WebViewVC *weakSelf = self;
        _checkCompletionBlock  = ^void(NSString *response, NSError *error) {
            
            NSLog(@"getBookStatus response : %@", response);
            
            if ([response isEqualToString:@"paid"])
            {
                [weakSelf dismissSelf:YES];
            }
            else if (response == nil || [response hasPrefix:@"wait"]){
                weakSelf.checkTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:weakSelf selector:@selector(sendCheckRequest) userInfo:nil repeats:NO];
            }
            else {
                ;// fixme : request cancelled
            }
        };
        _checkCompletionBlock(nil, nil);
    }
    else if (self.requiredBalance > 0) // check for balance
    {
        __weak WebViewVC *weakSelf = self;
        weakSelf.checkTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:weakSelf selector:@selector(sendAuthRequest) userInfo:nil repeats:NO];
    }
}

#pragma mark -

-(void) dismissSelf: (BOOL)success
{
    if (self.delegate)
        [self.delegate webViewWillReturn:success];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) sendAuthRequest
{
    __weak WebViewVC *weakSelf = self;
    [[Profile getInstance] profileAuthByHashWithBlock:[Profile getInstance].m_hash :^(BOOL is_ok, NSError *error) {
        NSLog(@"current balance = %li", (long)[Profile getInstance].m_balance);
        if (error == nil && [Profile getInstance].m_balance >= self.requiredBalance)
        {
            [self dismissSelf:YES];
        }
        else {
            weakSelf.checkTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:weakSelf selector:@selector(sendAuthRequest) userInfo:nil repeats:NO];
        }
    }];

}

-(void) sendCheckRequest
{
//    CheckCompletionBlock newBlock = _checkCompletionBlock;
//    [Reservation sendCheckReservationRequest:self.book_id WithCompletion:newBlock];
    
    __weak WebViewVC *weakSelf = self;
    
    [Reservation sendCheckReservationRequest:self.book_id WithCompletion:^(NSString *response, NSError *error) {
        NSLog(@"getBookStatus response : %@", response);
        
        if ([response isEqualToString:@"paid"])
        {
            [weakSelf dismissSelf:YES];
        }
        else if (response == nil || [response hasPrefix:@"wait"]){
            weakSelf.checkTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(sendCheckRequest) userInfo:nil repeats:NO];
        }
        else {
            ;// fixme : request cancelled
        }

    }];
}

#pragma mark - buttons

-(void)backButtonPressed: (id)sender
{
    [self dismissSelf:NO];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL shouldStartLoad = YES;
//    NSMutableDictionary *authInfo = nil;
//    NSError *error = nil;
    // session - instance of YMAAPISession class
    NSLog(@"request: %@", request);
    NSLog(@"request's url path: %@", request.URL.path);
    if ( [request.URL.absoluteString hasPrefix:@"https://restotube.ru/mobileappsuccess"])
    {
        [self dismissSelf:YES];
    }
    else if ([request.URL.absoluteString hasPrefix:@"https://restotube.ru/mobileappfail"])
    {
        [self dismissSelf:NO];
    }
//    if ([self.session isRequest:request
//                  toRedirectUrl:redirectUri
//              authorizationInfo:&authInfo
//                          error:&error]) {
//        shouldStartLoad = NO;
//        if (error == nil) {
//            NSString *authCode = authInfo[@"code"];
//            //Process temporary authorization code
//            NSDictionary *additionalParameters = @{
//                                                   @"grant_type"           : authCode, // Constant parameter
//                                                   YMAParameterRedirectUri : redirectUri
//                                                   };
//            
//            // session  - instance of YMAAPISession class
//            // authCode - temporary authorization code
//            [self.session receiveTokenWithCode:authCode
//                                 clientId:clientId
//                     additionalParameters:additionalParameters
//                               completion:^(NSString *instanceId, NSError *error) {
//                                   if (error == nil && instanceId != nil && instanceId.length > 0) {
//                                       NSString *accessToken = instanceId; // Do NOT request access_token every time, when you need to call API method.
//                                       // Obtain it once and reuse it.
//                                       // Process access_token
//                                       [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:accessTokenKey];
//                                       [self dismissViewControllerAnimated:YES completion:nil];
//                                   }
//                                   else {
//                                       // Process error
//                                       NSLog(@"token error: %@", error.description);
//                                   }
//                               }];
//        }
//    }
    return shouldStartLoad;
}

@end
