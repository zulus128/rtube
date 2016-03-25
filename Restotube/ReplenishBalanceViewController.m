//
//  ReplenishBalanceViewController.m
//  Restotube
//
//  Created by Victort on 10/09/15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "ReplenishBalanceViewController.h"
#import "Balance.h"
#import "WebViewVC.h"
#import "Profile.h"
#import "AFNetworking.h"
#import "AppDelegate.h"

@interface ReplenishBalanceViewController () <WebViewVCDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *sumField;
@property (weak, nonatomic) IBOutlet UIButton *replenishButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftItem;

@end

@implementation ReplenishBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.leftItem setImage:[UIImage imageNamed:@"arrow-back"]];
//    [self.leftItem setTitle:@"Назад"];
//
    [self setNeedsStatusBarAppearanceUpdate];
    
    if (self.dontConfigureBackButton == NO)
    {
        UIButton *backButton = [UIButton new];
        [backButton setImage:[UIImage imageNamed:@"arrow-back"] forState:UIControlStateNormal];
        [backButton setTitle:@" Назад" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor colorWithRed:236.0 / 255.0 green:47.0 / 255.0 blue:101.0 / 255.0 alpha:1] forState:UIControlStateNormal]; // EC2F65
        [backButton sizeToFit];
        [backButton addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backItem;
    }
    
    self.sumField.delegate = self;
    
    if (self.minSum > 0)
        self.sumField.text = [@(self.minSum) stringValue];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (IBAction)backPressed:(id)sender {
//    NSLog(@"back pressed");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void) backButtonPressed: (id)sender
{
    [self webViewWillReturn:NO];
}
- (IBAction)replenishButtonPressed:(id)sender {
    NSInteger sum = [_sumField.text integerValue];
    
    [Balance replenishBalanceRequest:sum withCompletion:^(NSDictionary *responce, NSError *error) {
        if (error == nil)
        {
            static NSString* const yaMoneyUrl   = YA_MONEY_URL;//@"https://money.yandex.ru/eshop.xml";
            static NSString* const yaShopId     = YA_MONEY_SHOP_ID;
            static NSString* const yaScid       = YA_MONEY_SCID;
            
            NSDictionary *params = @{   @"shopId"           : yaShopId,
                                        @"scid"             : yaScid,
                                        @"sum"              : @(sum),//@(PRODUCT_PRICE_DEFAULT_VALUE),
                                        //                                @"shopArticleId"    : @"",
                                        @"customerNumber"   : [Profile getInstance].m_id,
                                        @"orderNumber"      : [responce valueForKey:@"payment_id"],
                                        //                                @"cps_email"        : @"",
                                        //                                @"cps_phone"        : @"",
                                        @"paymentType"      : @"AC"
                                        
                                        };
            
            NSLog(@"params to send :\n%@", params);
            
            NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:yaMoneyUrl parameters:params error:nil];
            WebViewVC *vc = [WebViewVC new];
            vc.delegate         = self;
            vc.requestToLoad    = request;
            vc.requiredBalance  = self.requiredSum;
            //            [self.navigationController pushViewController:vc animated:YES];
            
            [self presentViewController:vc animated:YES completion:nil];
        }
        else {
            //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error with balance replenishing" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //            [alertView show];
            return;
        }
    }];

}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self replenishButtonPressed:nil];
    return YES;
}

#pragma mark - WebViewVCDelegate

-(void)webViewWillReturn:(BOOL)success
{
    if (self.requiredSum)
    {
        if (self.delegate)
        {
            [self.delegate replenishWillReturn:success];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NDM_BALANCE_CHANGED object:nil];
    
    
    if (self.minSum == 0){
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}

@end
