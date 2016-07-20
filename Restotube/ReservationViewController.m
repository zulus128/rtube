//
//  ReservationViewController.m
//  Restotube
//
//  Created by Andrey Rebrik on 13.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "ReservationViewController.h"
#import "ReservationInfoViewController.h"
#import "Reservation.h"
#import "IAPHelper.h"
#import "UIImageView+AFNetworking.h"
#import "RequestManager.h"
#import "WebViewVC.h"
#import "Profile.h"
#import "Balance.h"
#import "ReplenishBalanceViewController.h"
#import "AppDelegate.h"

#define PRODUCT_PRICE_LINE                @"и всего %ld\n руб. с человека"
#define PRODUCT_PRICE_PARAM_NAME          @"productPrice"
#define PRODUCT_PRICE_DEFAULT_VALUE       50
#define PRODUCT_PRICE_EXISTS_PARAM_NAME   @"productPriceExists"

#define TRY_ANIMATION_TIME1 0.35

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@interface ReservationViewController() {
    BOOL isLarge;
}
@property (weak, nonatomic) IBOutlet UIView *discountView;
@property (weak, nonatomic) IBOutlet UIImageView *infoBubble;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel1;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel2;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel3;
@property (weak, nonatomic) IBOutlet UIImageView *bottomPicture;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tryImageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tryImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tryImageToTryText;
@property (weak, nonatomic) IBOutlet UILabel *bottomText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toPresentText;

@end

@implementation ReservationViewController
{
    NSString *timeString;
    NSString *dateString;
    NSDate *datePickerDate;
    NSDate *datePickerTime;
    Addresses *selectedAddress;
    
    Reservation *sendedReservation;
    IAPHelper *_helper;
    UITapGestureRecognizer *tapGestureRecognizer;
}

- (IBAction)tryImageClicked:(id)sender {
//    if(!isLarge) {
//        [self makeFull];
//    } else {
//        [self makeSmall];
//    }
}

- (void)makeFull {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.tryImageWidth.constant = screenRect.size.width - 2 * 20;
    self.tryImageHeight.constant = screenRect.size.width - 2 * 20;
    self.tryImageToTryText.constant = -200;
    [UIView animateWithDuration:TRY_ANIMATION_TIME1 - 0.05
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         self.bottomPicture.layer.cornerRadius = (screenRect.size.width - 2 * 20) / 2;
                         isLarge = YES;
                     }];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.duration = TRY_ANIMATION_TIME1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.toValue = @((screenRect.size.width - 2 * 20) / 2);
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    [self.bottomPicture.layer addAnimation:animation forKey:@"setCornerRadius:"];
}

- (void)makeSmall {
    self.tryImageWidth.constant = 120;
    self.tryImageHeight.constant = 120;
    self.tryImageToTryText.constant = 20;
    [UIView animateWithDuration:TRY_ANIMATION_TIME1 - 0.05
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         self.bottomPicture.layer.cornerRadius = 120 / 2;
                         isLarge = NO;
                     }];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.duration = TRY_ANIMATION_TIME1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.toValue = @(120 / 2);
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    [self.bottomPicture.layer addAnimation:animation forKey:@"setCornerRadius1:"];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
//    NSLog(@"--- %@", [Profile getInstance].m_phone);
    // tap to remove keyboard
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];    
    
    // main scroll view
    mainScroll.alwaysBounceHorizontal = NO;
    
    _helper = [IAPHelper helper];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBuyed) name:@"IAPHelperProductPurchasedNotification" object:nil];
    
    [self.navigationItem setTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed: @"restotube-logo"]]];
    
    for (UIView *field in textfields)
    {
        [field.layer setBorderColor:[[UIColor colorWithRed:167.0/255.0 green:169.0/255.0 blue:172.0/255.0 alpha:1.0] CGColor]];
        field.layer.borderWidth = 1.0f;
        
        if ([field isKindOfClass:[UITextField class]])
            field.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    }
    
    timeString = @"";
    dateString = @"";
    
    if (_restaurant.addresses.count > 0)
    {
        selectedAddress = _restaurant.addresses[0];
        addressLabel.text = selectedAddress.name;
    }
    
    if([_restaurant.sale isEqualToString: @""]) {
        if (_restaurant.presentDesc.length == 0)
        {
            [resrveWithDiscountButton setHidden:YES];
        }
        else
        {
            NSString* str = [NSString stringWithFormat:@"Забронировать c подарком"];
            [resrveWithDiscountButton setTitle:str forState:UIControlStateNormal];
            [resrveButton setHidden:YES];
            
            NSURL *assetsBaseUrl = [RequestManager sharedManager].assetsBaseUrl;
            NSURL *imgUrl = [[NSURL alloc] initWithString:_restaurant.presentImg relativeToURL:assetsBaseUrl];
            NSURLRequest* req_bg = [NSURLRequest requestWithURL:imgUrl];
            [self.bottomPicture setImageWithURLRequest:req_bg placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    
                [UIView transitionWithView:self.bottomPicture
                                  duration:0.3
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    self.bottomPicture.image = image;
                                }
                                completion:NULL];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                NSLog(@"error: %@", error);
            }];
            self.bottomText.hidden = NO;
            self.bottomText.text = _restaurant.presentDesc;
        }
    }
    else {
        NSString* str = [NSString stringWithFormat:@"Забронировать со скидкой %ld%%", (long)_restaurant.saleint];
        [resrveWithDiscountButton setTitle:str forState:UIControlStateNormal];
        [resrveButton setHidden:YES];
        [self.bottomPicture setImage:[UIImage imageNamed:@"salepic"]];
        self.bottomText.hidden = YES;
    }
    
    if (_restaurant.presentDesc.length == 0)
    {
        bubblePresentImageView.hidden = YES;
        
        discountLabel.textColor = [UIColor colorWithRed:236.0 / 255.0 green:47.0 / 255.0 blue:101.0 / 255.0 alpha:1]; // EC2F65
        discountLabel.text = [NSString stringWithFormat:@"%ld%%", (long)_restaurant.saleint];
    }
    else
    {
//        _presentImgView.backgroundColor = [UIColor whiteColor];
//        _presentImgView.layer.cornerRadius = _presentImgView.frame.size.width / 2;
//        _presentImgView.layer.borderColor = [UIColor whiteColor].CGColor;
//        _presentImgView.layer.borderWidth = 3;
////        _presentImgView.layer.masksToBounds = YES;
//        _presentImgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//        _presentImgView.layer.shadowRadius = 1;
//        _presentImgView.layer.shadowOffset = CGSizeMake(0, 0);
//        _presentImgView.layer.shadowOpacity = 1;
//        
//        _presentDescLabel.text = _restaurant.presentDesc;
//
//        NSURL *imgUrl = [[NSURL alloc] initWithString:_restaurant.presentImg];
//        NSURLRequest* req_bg = [NSURLRequest requestWithURL:imgUrl];
//        [_presentImgView setImageWithURLRequest:req_bg placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//            
//            [UIView transitionWithView:_presentImgView
//                              duration:0.3
//                               options:UIViewAnimationOptionTransitionCrossDissolve
//                            animations:^{
//                                _presentImgView.image = image;
//                            }
//                            completion:NULL];
//        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//            NSLog(@"error: %@", error);
//        }];
        
        discountLabel.hidden     = YES;
        discountDescription.text = @"получите\nподарок!";
    }
    _presentDescLabel.hidden = YES;
    _presentImgView.hidden = YES;
    bottomConstrain.constant = 20;
    
    _productPrice = -1;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:PRODUCT_PRICE_EXISTS_PARAM_NAME])
    {
        _productPrice = [[NSUserDefaults standardUserDefaults] integerForKey:PRODUCT_PRICE_PARAM_NAME];
    }
    [self updateCostPerPersonLabel];
    
    NSDictionary *cache = [[NSUserDefaults standardUserDefaults] objectForKey:@"kReserveCache"];
    surnameField.text = [[Profile getInstance] m_surname];//cache[@"surname"];
    nameField.text = [[Profile getInstance] m_name];//cache[@"name"];
    phoneField.text = [self profilePhone] ? [self profilePhone] : cache[@"fullPhone"];
    phoneField.enabled = ![self profilePhone];
    phoneField.textColor = [self profilePhone] ? [UIColor grayColor] : [UIColor blackColor];
    
    _discountView.hidden = YES;
    _infoBubble.hidden = YES;
    _infoLabel1.hidden = YES;
    _infoLabel2.hidden = YES;
    _infoLabel3.hidden = YES;
    
    self.bottomPicture.layer.cornerRadius = 120 / 2;
    
    CGFloat h = 40;
    if(IS_IPHONE_5) {
        h = 60;
    } else if(IS_IPHONE_6) {
        self.toPresentText.constant = 15;
        h = 140;
    } else    if(IS_IPHONE_6P) {
        self.toPresentText.constant = 30;
        h = 170;
    }
    self.tryImageWidth.constant = h;
    self.tryImageHeight.constant = h;
    self.bottomPicture.layer.cornerRadius = h / 2;
    self.bottomPicture.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    mainScroll.contentSize = CGSizeMake(mainScroll.frame.size.width, resrveButton.frame.size.height + resrveButton.frame.origin.y + 37);
    [mainScroll setContentOffset:CGPointZero animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWillShow:(NSNotification *)notification
{
    CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    mainScroll.contentSize = CGSizeMake(mainScroll.frame.size.width, resrveButton.frame.size.height + resrveButton.frame.origin.y + 33 + keyboardHeight);
    
    UIView *view = [self findFirstResponder];
    if (view)
    {
        CGFloat offsetHeight = view.frame.size.height + view.frame.origin.y - (mainScroll.frame.size.height - keyboardHeight);
        offsetHeight = offsetHeight < 0 ? 0 : offsetHeight;
        [mainScroll setContentOffset:CGPointMake(0, offsetHeight + 70) animated:YES];
    }
}

- (void) keyboardWillHide:(NSNotification *)notification
{
    mainScroll.contentSize = CGSizeMake(mainScroll.frame.size.width, resrveButton.frame.size.height + resrveButton.frame.origin.y + 37);
}

- (id)findFirstResponder
{
    for (UIView *subView in self.view.subviews)
        if ([subView isFirstResponder])
            return subView;
    
    return nil;
}

- (BOOL)isDataOk
{
    BOOL isDataOk = dateString && ![dateString isEqualToString:@""] &&
    timeString && ![timeLabel.text isEqualToString:@""] &&
    ![nameField.text isEqualToString:@""] &&
    ![surnameField.text isEqualToString:@""] &&
    [self strippedPhone].length == 10 &&
    ![peopleField.text isEqualToString:@""];
    
    for (UIView *field in textfields)
    {
        [field.layer setBorderColor:[[UIColor colorWithRed:167.0/255.0 green:169.0/255.0 blue:172.0/255.0 alpha:1.0] CGColor]];
        field.layer.borderWidth = 1.0f;
    }
    
    if (!dateString || [dateString isEqualToString:@""])
        [dateBackground.layer setBorderColor:[[UIColor colorWithRed:255.0/255.0 green:37.0/255.0 blue:103.0/255.0 alpha:1.0] CGColor]];
    if (!timeString || [timeString isEqualToString:@""])
        [timeBackground.layer setBorderColor:[[UIColor colorWithRed:255.0/255.0 green:37.0/255.0 blue:103.0/255.0 alpha:1.0] CGColor]];
    if ([nameField.text isEqualToString:@""])
        [nameField.layer setBorderColor:[[UIColor colorWithRed:255.0/255.0 green:37.0/255.0 blue:103.0/255.0 alpha:1.0] CGColor]];
    if ([surnameField.text isEqualToString:@""])
        [surnameField.layer setBorderColor:[[UIColor colorWithRed:255.0/255.0 green:37.0/255.0 blue:103.0/255.0 alpha:1.0] CGColor]];
    if ([self strippedPhone].length < 10)
        [phoneField.layer setBorderColor:[[UIColor colorWithRed:255.0/255.0 green:37.0/255.0 blue:103.0/255.0 alpha:1.0] CGColor]];
    if ([peopleField.text isEqualToString:@""])
        [peopleField.layer setBorderColor:[[UIColor colorWithRed:255.0/255.0 green:37.0/255.0 blue:103.0/255.0 alpha:1.0] CGColor]];
    
    NSString *alertMessage = @"Пожалуйста Заполните все обязательные поля.";
    
    if (datePickerDate && datePickerTime)
    {
        if (([datePickerDate compare: [NSDate date]] != NSOrderedDescending) &&
            ([datePickerTime compare: [NSDate date]] != NSOrderedDescending))
        {
            [timeBackground.layer setBorderColor:[[UIColor colorWithRed:255.0/255.0 green:37.0/255.0 blue:103.0/255.0 alpha:1.0] CGColor]];
            [dateBackground.layer setBorderColor:[[UIColor colorWithRed:255.0/255.0 green:37.0/255.0 blue:103.0/255.0 alpha:1.0] CGColor]];
            isDataOk = NO;
            alertMessage = @"Некорректно указаны дата и время.";
        }
    }
    
    if (!isDataOk)
        [[[UIAlertView alloc] initWithTitle:@"Внимание!" message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    return isDataOk;
}


#pragma mark - Actions


- (void)addressPressed:(id)sender
{
    UIView *responder = [self findFirstResponder];
    if (responder) [responder resignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Адрес"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    for (Addresses *address in _restaurant.addresses)
        [actionSheet addButtonWithTitle:address.name];
    
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Отмена"];
    
    [actionSheet showInView:self.view];
}

- (void)datePressed:(id)sender
{
    [dateTextField becomeFirstResponder];
}

- (void)timePressed:(id)sender
{
    [timeTextField becomeFirstResponder];
}

-(void) openRequest:(NSURLRequest*)request
{
    
}

- (void)reserveWithDiscountPressed:(id)sender
{
    if (![self isDataOk]) return;
    
    [self.view endEditing:YES];
    ((UIButton *)sender).enabled = NO;
    
    NSString *buySale = @"1";
////    __block NSString *payment_id;
//    NSInteger sum = _numberOfPeople * 50; // fixme : test only
//    BOOL useCard = NO;
//    
//    if ([[Profile getInstance] isProfileLoaded] == YES)
//    {
//        buySale = @"rtmoney";
//        
//        NSInteger balance = [Profile getInstance].m_balance;
//        NSInteger diff = balance - sum;
//        if (diff < 0)
//        { // replenish balance
////            ReplenishBalanceViewController *vc = [[ReplenishBalanceViewController alloc] init];
////            vc.minSum = -diff;
////            [self.navigationController pushViewController:vc animated:YES];
//            
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            ReplenishBalanceViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ReplenishBalanceViewController"];
//            vc.minSum                   = -diff;
//            vc.requiredSum              = sum;
//            vc.dontConfigureBackButton  = YES;
//            vc.delegate                 = self;
//            [self.navigationController pushViewController:vc animated:YES];
//            
//            ((UIButton *)sender).enabled = YES;
//            return;
//        }
////        else {
////            
////        }
//    }
//    else {
//        buySale = @"1";
//        useCard = YES;
//    }
    
    NSDictionary *params = @{@"date" : dateString,
                             @"time" : timeString,
                             @"col" : peopleField.text,
                             @"surname" : surnameField.text,
                             @"name" : nameField.text,
                             @"phone" : [self strippedPhone],
                             @"address" : selectedAddress.address_Id,
                             @"text" : commentTextView.text,
                             @"buy_sale" : buySale,
                             @"app" : @(1),
                             @"fullPhone" : phoneField.text,
                             @"hash" : [Profile getInstance].m_hash ? [Profile getInstance].m_hash : @""
                             };

    [[NSUserDefaults standardUserDefaults] setObject:params forKey:@"kReserveCache"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.view addSubview:self.fadeView];
    
    [Reservation sendReserveRequest:params
                     WithCompletion:^(Reservation *reservation, NSError *error)
     {
         if (error) {
             NSLog(@"Reservation error: %@", error);
             [[[UIAlertView alloc] initWithTitle:@"Ошибка бронирования"
                                        message:error.userInfo[@"errors"] ?: error.localizedRecoverySuggestion ?: error.localizedDescription
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
             [self.fadeView removeFromSuperview];
             ((UIButton *)sender).enabled = YES;
             return;
         }
         sendedReservation = reservation;
         
//         if (useCard == YES)
//         {
//             static NSString* const yaMoneyUrl   = YA_MONEY_URL;//@"https://money.yandex.ru/eshop.xml";
//             static NSString* const yaShopId     = YA_MONEY_SHOP_ID;
//             static NSString* const yaScid       = YA_MONEY_SCID;
//                 
//             NSDictionary *params = @{   @"shopId"           : yaShopId,
//                                         @"scid"             : yaScid,
//                                         @"sum"              : reservation.sum,//@(PRODUCT_PRICE_DEFAULT_VALUE),
//                                         //                                @"shopArticleId"    : @"",
//    //                                     @"customerNumber"   : @(123),
//                                         @"orderNumber"      : reservation.payment_id,
//                                         //                                @"cps_email"        : @"",
//                                         //                                @"cps_phone"        : @"",
//                                         @"paymentType"      : @"AC"
//                                         
//                                         };
//             
//             NSLog(@"params to send :\n%@", params);
//             
//             NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:yaMoneyUrl parameters:params error:nil];
//             WebViewVC *vc = [WebViewVC new];
//             vc.delegate        = self;
//             vc.requestToLoad   = request;
//             vc.book_id         = reservation.book_id;
//             [self presentViewController:vc animated:YES completion:nil];
//         }
//         else {

         [self showSuccessDialog];
         
//             [self performSegueWithIdentifier:@"ReservationResponseSegue" sender:nil];
         
             [self.fadeView removeFromSuperview];
             [[NSNotificationCenter defaultCenter] postNotificationName:NDM_BALANCE_CHANGED object:nil];
//         }
         
         ((UIButton *)sender).enabled = YES;
         
         return;
         
         NSString *identifier;
         int col = [peopleField.text intValue];
         if (_restaurant.saleint > 0)
         {
             if (col > 1)
             {
                 identifier = [NSString stringWithFormat:@"ru.restotube.InAppPurchases.reservation%d.%d",(int)_restaurant.saleint,col];
             }
             else
             {
                 identifier = [NSString stringWithFormat:@"ru.restotube.InAppPurchases.reservation%d",(int)_restaurant.saleint];
             }
             
         }
         else
         {
             if (col > 1)
             {
                 identifier = [NSString stringWithFormat:@"ru.restotube.InAppPurchases.reservationPresent.%d", col];
             }
             else {
                 identifier = @"ru.restotube.InAppPurchases.reservationPresent";
             }
         }

         sendedReservation = reservation;
         [_helper requestProductIdentifier:identifier withCompletionHandler:^(BOOL success, NSArray *products) {
             ((UIButton *)sender).enabled = YES;
             if (products.count > 0)
             {
                 [_helper buyProduct:products[0]];
                 // remembering the price
                 SKProduct *product = products[0];
                 _productPrice = product.price.integerValue;
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PRODUCT_PRICE_EXISTS_PARAM_NAME];
                 [[NSUserDefaults standardUserDefaults] setInteger:_productPrice forKey:PRODUCT_PRICE_PARAM_NAME];
                 [self updateCostPerPersonLabel];
             }
             else
             {
                 [self.fadeView removeFromSuperview];
                 if (reservation.sale_url && ![reservation.sale_url isEqualToString:@""])
                 {
                     NSURL *url;
                     
                     if ([reservation.sale_url rangeOfString:@"http"].location == NSNotFound)
                         url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", reservation.sale_url]];
                     else
                         url = [NSURL URLWithString:reservation.sale_url];
                     
                     [[UIApplication sharedApplication]  openURL:url];
                 }
             }
         }];
         
     }];
}

- (void)showSuccessDialog {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@, Ваш заказ принят! \n Ожидайте подтверждения по СМС в ближайшее время! \n Живите вкусно с RestoTube!", nameField.text] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)onBuyed
{
    if (sendedReservation != nil)
    {
        NSDictionary *params = @{@"id" : sendedReservation.reservation_id,
                                 @"hash" : sendedReservation.reservation_hash};
        
        [Reservation sendReservedRequest:params WithCompletion:^(NSDictionary *response, NSError *error) {
            [self performSegueWithIdentifier:@"ReservationResponseSegue" sender:nil];
        }];
        [self.fadeView removeFromSuperview];
    }
}

- (void)reservePressed:(id)sender
{
    if (![self isDataOk]) return;
    
    NSDictionary *params = @{@"date" : dateString,
                             @"time" : timeString,
                             @"col" : peopleField.text,
                             @"surname" : surnameField.text,
                             @"name" : nameField.text,
                             @"phone" : [self strippedPhone],
                             @"address" : selectedAddress.address_Id,
                             @"text" : commentTextView.text,
                              @"fullPhone" : phoneField.text};

    [[NSUserDefaults standardUserDefaults] setObject:params forKey:@"kReserveCache"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [Reservation sendReserveRequest:params
                     WithCompletion:^(Reservation *reservation, NSError *error) {
                         if (error) {
                             NSLog(@"Reservation error: %@", error);
                             [[[UIAlertView alloc] initWithTitle:@"Ошибка бронирования"
                                                         message:error.userInfo[@"errors"] ?: error.localizedRecoverySuggestion ?: error.localizedDescription
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil] show];
                             [self.fadeView removeFromSuperview];
                             ((UIButton *)sender).enabled = YES;
                             return;
                         }
                         [self showSuccessDialog];
                         sendedReservation = reservation;
//                         [self performSegueWithIdentifier:@"ReservationResponseSegue" sender:nil];
                     }];
}

- (NSString *)strippedPhone
{
    if (![phoneField.text isEqualToString:@""])
    {
        NSString *string = [phoneField.text substringFromIndex:3];
        string = [string stringByReplacingOccurrencesOfString:@") " withString:@""];
        
        return string;
    }
    
    return @"";
}

- (NSString *)profilePhone {
    
    if(![Profile getInstance].m_phone)
        return nil;
    NSString *s = [NSString stringWithFormat:@"+%@(%@) %@", [[Profile getInstance].m_phone substringToIndex:1], [[Profile getInstance].m_phone substringWithRange:NSMakeRange(1, 3)], [[Profile getInstance].m_phone substringWithRange:NSMakeRange(4, 7)]];
    return s;
}

#pragma mark - auxiliary

-(void) updateCostPerPersonLabel
{
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.type = kCATransitionFade;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [costPerPersonLabel.layer addAnimation:animation forKey:@"changeTextTransition"];
    if (_numberOfPeople == 0 || _productPrice < 0)
    {
        costPerPersonLabel.text = [NSString stringWithFormat:PRODUCT_PRICE_LINE, (long)PRODUCT_PRICE_DEFAULT_VALUE];
    }
    else {
        costPerPersonLabel.text = [NSString stringWithFormat:PRODUCT_PRICE_LINE, (long)_productPrice / _numberOfPeople];
    }
}

#pragma mark - tap to remove keyboard

-(void) onTap
{
    [self.view endEditing:YES];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
//    NSLog(@"reservebutton frame : %f %f %f %f", resrveWithDiscountButton.frame.origin.x, resrveWithDiscountButton.frame.origin.y, resrveWithDiscountButton.frame.size.width, resrveWithDiscountButton.frame.size.height);
//    for (UIView *iView in mainScroll.subviews)
//    {
//        NSLog(@"subview : %@", iView);
//    }
    if (gestureRecognizer == tapGestureRecognizer)
    {
        if ([touch.view isKindOfClass:[UIButton class]] || touch.view == fadView)
        {
            return NO;
        }
    }
    return YES;
}


#pragma mark - UIActionSheetDelegate


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex < _restaurant.addresses.count)
    {
        selectedAddress = _restaurant.addresses[buttonIndex];
        addressLabel.text = selectedAddress.name;
    }
}


#pragma mark - UITextFieldDelegate


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == dateTextField)
    {
        if (!datePickerDate)
            datePickerDate = [NSDate date];
        
        UIDatePicker *datePicker = [[UIDatePicker alloc]init];
        [datePicker setMinimumDate:[NSDate date]];
        datePicker.backgroundColor = [UIColor whiteColor];
        [datePicker setDate:datePickerDate];
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
        [textField setInputView:datePicker];
        [textField setInputAccessoryView:doneButtonAcessoryView];
        
        [self updateTextField:nil];
        fadView.hidden = NO;
    }
    else if (textField == timeTextField)
    {
        if (!datePickerTime)
            datePickerTime = [self getRoundedMinimumDate:[NSDate date]];
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        
        if (!datePickerDate || ([datePickerDate compare: [NSDate date]] != NSOrderedDescending))
            [datePicker setMinimumDate:[self getRoundedMinimumDate:[NSDate date]]];
        
        [datePicker setDate:datePickerTime];
        [datePicker setDatePickerMode:UIDatePickerModeTime];
        [datePicker setMinuteInterval:10];
        datePicker.backgroundColor = [UIColor whiteColor];
        [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
        [textField setInputView:datePicker];
        [textField setInputAccessoryView:doneButtonAcessoryView];
        
        [self updateTextField:nil];
        fadView.hidden = NO;
    }
    else if (textField == phoneField)
    {
        if (textField.text.length == 0 || [textField.text isEqualToString:@"+7("])
        {
            textField.text = @"+7(";
        }
    }
}

- (void)updateTextField:(id)sender
{
    if ([dateTextField isFirstResponder])
    {
        UIDatePicker *picker = (UIDatePicker*)dateTextField.inputView;
        datePickerDate = picker.date;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd MMMM, EE"];
        dateLabel.text = [formatter stringFromDate:picker.date];
        
        NSDateFormatter *sendformatter = [[NSDateFormatter alloc] init];
        [sendformatter setDateFormat:@"yyyy-MM-dd"];
        dateString = [sendformatter stringFromDate:picker.date];
    }
    else if ([timeTextField isFirstResponder])
    {
        UIDatePicker *picker = (UIDatePicker*)timeTextField.inputView;
        
        datePickerTime = picker.date;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        timeLabel.text = [formatter stringFromDate:picker.date];
        
        NSDateFormatter *sendformatter = [[NSDateFormatter alloc] init];
        [sendformatter setDateFormat:@"HH:mm"];
        timeString = [formatter stringFromDate:picker.date];
    }
}

- (NSDate *)getRoundedMinimumDate:(NSDate *)inDate{
    
    NSDate *returnDate;
    NSInteger minuteInterval = 10;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit | NSHourCalendarUnit fromDate:inDate];
    NSInteger minutes = [dateComponents minute];
    
    NSInteger minutesToRound = minuteInterval - (NSInteger)(minutes % minuteInterval);
    
    NSDate *roundedDate = [[NSDate alloc] initWithTimeInterval:60.0 * minutesToRound  sinceDate:inDate];
    
    returnDate = roundedDate;
    return returnDate;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    fadView.hidden = YES;
    
    [textField resignFirstResponder];
    
    if (textField == dateTextField)
        [timeTextField becomeFirstResponder];
    else if (textField == timeTextField)
        [peopleField becomeFirstResponder];
    else if (textField == peopleField)
        [nameField becomeFirstResponder];
    else if (textField == nameField)
        [surnameField becomeFirstResponder];
    else if (textField == surnameField)
        [phoneField becomeFirstResponder];
    else if (textField == phoneField)
        [commentTextView becomeFirstResponder];
    
    return YES;
}

- (void)doneButtonPreesed:(id)sender
{
    fadView.hidden = YES;
    
    if ([dateTextField isFirstResponder])
        [self textFieldShouldReturn:dateTextField];
    else if ([timeTextField isFirstResponder])
        [self textFieldShouldReturn:timeTextField];
    else if ([commentTextView isFirstResponder])
        [commentTextView resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == phoneField || textField == peopleField)
    {
        if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
        {
            return NO;
        }
        
        if (textField == phoneField)
        {
            if (string.length > 1 || range.length > 1)
                return NO;
            if (range.length <= 3 && range.location == 0)
                return NO;
            
            if (textField.text.length <= 3)
            {
                textField.text = [NSString stringWithFormat:@"%@%@", @"+7(", string];
                return NO;
            }
            
            if (range.location == 15 || textField.text.length > 15)
                return NO;
            
            if (range.location == 6)
            {
                textField.text = [textField.text stringByAppendingString:@") "];
                return YES;
            }
            if (range.location == 7)
            {
                textField.text = [textField.text substringToIndex:5];
                return YES;
            }
        }
    }
    
    if (textField == peopleField)
    {
        NSString * proposedNewString = [[textField text] stringByReplacingCharactersInRange:range withString:string];
        
        if (proposedNewString.intValue > 15)
        {
            textField.text = @"15";
            return NO;
        }
        
        _numberOfPeople = proposedNewString.integerValue;
        [self updateCostPerPersonLabel];
    }
    
    return YES;
}


#pragma mark - UITextViewDelegate


- (void)textViewDidBeginEditing:(UITextView *)textView
{
     [textView setInputAccessoryView:doneButtonAcessoryView];
}

#pragma mark - WebViewVCDelegate

-(void)webViewWillReturn:(BOOL)success
{
    [self.fadeView removeFromSuperview];
    if (success)
        [self performSegueWithIdentifier:@"ReservationResponseSegue" sender:nil];

}

#pragma mark - ReplenishBalanceViewControllerDelegate

-(void)replenishWillReturn:(BOOL)success
{
    if (success)
        [self reserveWithDiscountPressed:nil];
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ReservationResponseSegue"])
    {
        ReservationInfoViewController *controller = (ReservationInfoViewController *)segue.destinationViewController;
        controller.reservation = sendedReservation;
        controller.nameString = [NSString stringWithFormat:@"%@ %@", nameField.text, surnameField.text];
    }
}

- (UIView *)fadeView
{
    if (_fadeView == nil)
    {
        _fadeView = [[UIView alloc] initWithFrame:self.view.bounds];
        _fadeView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activity sizeToFit];
        activity.center = _fadeView.center;
        activity.backgroundColor = [UIColor clearColor];
        activity.color = [UIColor colorWithRed:204/255.0 green:50/255.0 blue:101/255.0 alpha:1];
        [activity startAnimating];
        [_fadeView addSubview:activity];
    }
    return _fadeView;
}

@end