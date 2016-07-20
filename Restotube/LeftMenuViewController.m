//
//  LeftMenuViewController.m
//  Restotube
//
//  Created by Maksim Kis on 04.04.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UIViewController+RESideMenu.h"
#import "Profile.h"
#import "CategoriesViewController.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "ProfileView.h"
//#import "NearMeViewController.h"
#import "ConstantsManager.h"
#import "RequestManager.h"
#import "AppDelegate.h"
#import "ReplenishBalanceViewController.h"
#import "ReplenishNavigationController.h"

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

@interface LeftMenuViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIImageView *imageAvatar;
@property (weak, nonatomic) IBOutlet UIButton *buttonAddBalance;
@property (weak, nonatomic) IBOutlet UILabel *labelBalanceText;
@property (weak, nonatomic) IBOutlet UILabel *labelBalance;
@property (weak, nonatomic) IBOutlet UIButton *buttonRestaurants;
@property (weak, nonatomic) IBOutlet UIButton *buttonFilters;
@property (weak, nonatomic) IBOutlet UIButton *buttonProfile;
@property (weak, nonatomic) IBOutlet UIButton *buttonReservations;
@property (weak, nonatomic) IBOutlet UIButton *buttonNear;
@property (weak, nonatomic) IBOutlet UIButton *buttonMoscow;
@property (weak, nonatomic) IBOutlet UIButton *buttonSochi;
@property(strong, nonatomic) NSArray *cityList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap6;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap7;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap0;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap8;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameHeight;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad
{
    self.cityList = @[@"Москва", @"Сочи", @"Ростов", @"Краснодар"];
    [super viewDidLoad];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickAvatar)];
    singleTap.numberOfTapsRequired = 1;
    [self.imageAvatar setUserInteractionEnabled:YES];
    [self.imageAvatar addGestureRecognizer:singleTap];
    
    [[self.buttonAddBalance layer] setBorderWidth:2.0f];
    [[self.buttonAddBalance layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [self.buttonAddBalance setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonAddBalance setTitleColor:[UIColor colorWithRed:150.0 green:150.0 blue:150.0 alpha:1.0] forState:UIControlStateHighlighted];
    
    
    [self.labelBalanceText setTextColor:[UIColor whiteColor]];
    [self.labelBalance setTextColor:[UIColor whiteColor]];
    
    [self.buttonRestaurants setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonRestaurants setTitleColor:[UIColor colorWithRed:150.0 green:150.0 blue:150.0 alpha:1.0] forState:UIControlStateHighlighted];
    
    [self.buttonNear setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonNear setTitleColor:[UIColor colorWithRed:150.0 green:150.0 blue:150.0 alpha:1.0] forState:UIControlStateHighlighted];
    
    [self.buttonFilters setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonFilters setTitleColor:[UIColor colorWithRed:150.0 green:150.0 blue:150.0 alpha:1.0] forState:UIControlStateHighlighted];
    
    [self.buttonProfile setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonProfile setTitleColor:[UIColor colorWithRed:150.0 green:150.0 blue:150.0 alpha:1.0] forState:UIControlStateHighlighted];
    
    [self.buttonReservations setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonReservations setTitleColor:[UIColor colorWithRed:150.0 green:150.0 blue:150.0 alpha:1.0] forState:UIControlStateHighlighted];
    
    self.labelBalance.text = @"0 руб.";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(balanceChanged:) name:NDM_BALANCE_CHANGED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loggedInNotification:)
                                                 name:@"LoggedIn"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ImageChanged:)
                                                 name:@"ImageChanged"
                                               object:nil];
    
    NSString* hash = [[NSUserDefaults standardUserDefaults] stringForKey:@"lambda"];
    
    if(![hash  isEqual: @""]) {
        [[Profile getInstance] profileAuthByHashWithBlock:hash :^(BOOL is_ok, NSError *error) {
            // logged
        }];
    }
    if ([[ConstantsManager getInstance].city isEqualToString:@"moscow"])
    {
        _buttonMoscow.selected = YES;
        _buttonSochi.selected = NO;
    }
    else
    {
        _buttonMoscow.selected = NO;
        _buttonSochi.selected = YES;
    }
    
    self.view.backgroundColor = [UIColor clearColor];
    self.picker.backgroundColor = [UIColor colorWithRed:224/255.0f green:187/255.0f blue:195/255.0f alpha:1];
    self.picker.layer.cornerRadius = 7;
    self.picker.layer.masksToBounds = YES;

    CGFloat gap = 8;
    self.pickerHeight.constant = 150;
    if(IS_IPHONE_6P) {
        gap = 8;
//        self.pickerHeight.constant = 180;
    } else if(IS_IPHONE_6) {
        gap = 0;
//        self.pickerHeight.constant = 150;
    } else if (IS_IPHONE_5) {
        gap = -10;
        self.gap8.constant = 5;
        self.pickerHeight.constant = 120;
        self.nameHeight.constant = 30;
    } else if (IS_IPHONE_4_OR_LESS) {
        gap = -20;
        self.gap8.constant = 2;
        self.pickerHeight.constant = 90;
        self.nameHeight.constant = 10;
    }
    self.gap0.constant = gap;
    self.gap1.constant = gap;
    self.gap2.constant = gap;
    self.gap3.constant = gap;
    self.gap4.constant = gap;
    self.gap5.constant = gap;
    self.gap6.constant = gap;
    self.gap7.constant = gap;

    int index = 0;
    if([[ConstantsManager getInstance].city isEqualToString:@"moscow"]) {
        index = 0;
    } else if([[ConstantsManager getInstance].city isEqualToString:@"sochi"]) {
        index = 1;
    } else if([[ConstantsManager getInstance].city isEqualToString:@"rostov"]) {
        index = 2;
    } else  if([[ConstantsManager getInstance].city isEqualToString:@"krasnodar"]) {
        index = 3;
    }
    [self.picker selectRow:index inComponent:0 animated:YES];
    [self.buttonMoscow setTitle:self.cityList[index] forState:UIControlStateNormal];
}

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) ImageChanged:(NSNotification *) notification  {
    ProfileView* view = (ProfileView*)notification.object;
    
    if(view) {
        CGFloat corner = self.imageAvatar.image.size.width;
        _imageAvatar.image = [self resizeImage:view.imageAvatar.image imageSize: CGSizeMake(70, 70)];
        self.imageAvatar.layer.cornerRadius = 90 / 2;
        self.imageAvatar.layer.masksToBounds = YES;
    }
}

- (void) loggedInNotification:(NSNotification *) notification  {
    if([[Profile getInstance] m_image] == nil) {
        return;
    }
    CGFloat corner = self.imageAvatar.image.size.width;
    self.imageAvatar.contentMode = UIViewContentModeScaleAspectFit;
    self.imageAvatar.clipsToBounds = YES;

    NSURL *assetsBaseUrl = [RequestManager sharedManager].assetsBaseUrl;
    NSURL *avatarUrl = [[NSURL alloc] initWithString:[Profile getInstance].m_image relativeToURL:assetsBaseUrl];
    NSURLRequest* avatarRequest = [NSURLRequest requestWithURL:avatarUrl];
    [self.imageAvatar setImageWithURLRequest:avatarRequest
                            placeholderImage:[UIImage imageNamed:@"no-photo"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
     {
         _imageAvatar.image = image;//[self resizeImage:image imageSize: CGSizeMake(70, 70)];
         self.imageAvatar.layer.cornerRadius = 90 / 2;
         self.imageAvatar.layer.masksToBounds = YES;
         self.imageAvatar.layer.borderWidth  = 0;
     }
                                     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                         NSLog(@"error8: %@", error);
                                     }];
    
    self.labelBalance.text = [NSString stringWithFormat: @"%ld руб.", (long)[[Profile getInstance] m_balance]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", [[Profile getInstance] m_name], [[Profile getInstance] m_surname]];
}

-(UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)onClickAvatar {
    CategoriesViewController* cat = [self.storyboard instantiateViewControllerWithIdentifier:@"categoriesViewController"];
    
    if([[Profile getInstance] isProfileLoaded] == NO) {
        cat.needsAuthOpen = YES;
    }
    else {
        cat.needsProfileOpen = YES;
    }
    
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:cat] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
- (IBAction)onCityButton:(UIButton *)sender {
    _picker.hidden = NO;
//    if (sender == _buttonMoscow)
//    {
//        _buttonMoscow.selected = YES;
//        _buttonSochi.selected = NO;
//        [ConstantsManager getInstance].city = @"moscow";
//    }
//    else
//    {
//        _buttonMoscow.selected = NO;
//        _buttonSochi.selected = YES;
//        [ConstantsManager getInstance].city = @"sochi";
//    }
//    
//    UINavigationController *nc = (UINavigationController *)self.sideMenuViewController.contentViewController;
//    if (nc.childViewControllers.count > 1)
//    {
//        [nc popToRootViewControllerAnimated:NO];
//    }
//    UIViewController *vc = nc.childViewControllers.firstObject;
//    if ([vc isKindOfClass:[CategoriesViewController class]])
//    {
//        [(CategoriesViewController *)vc reload:nil];
//    }
}

- (IBAction)onNearButton:(id)sender {
    CategoriesViewController* cat = [self.storyboard instantiateViewControllerWithIdentifier:@"categoriesViewController"];
    cat.needsNearOpen = YES;
    cat.needsSale = NO;
    cat.needsGift = NO;
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:cat] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

- (IBAction)onNearButtonSale:(id)sender {
    CategoriesViewController* cat = [self.storyboard instantiateViewControllerWithIdentifier:@"categoriesViewController"];
    cat.needsNearOpen = YES;
    cat.needsSale = YES;
    cat.needsGift = NO;
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:cat] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

- (IBAction)onNearButtonGift:(id)sender {
    CategoriesViewController* cat = [self.storyboard instantiateViewControllerWithIdentifier:@"categoriesViewController"];
    cat.needsNearOpen = YES;
    cat.needsSale = NO;
    cat.needsGift = YES;
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:cat] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

- (IBAction)onClickAddBalance:(id)sender {
    if([[Profile getInstance] isProfileLoaded] == NO) {
        CategoriesViewController* cat = [self.storyboard instantiateViewControllerWithIdentifier:@"categoriesViewController"];
        cat.needsAuthOpen = YES;
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:cat] animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    }
    else {
//        NSString* msg = [NSString stringWithFormat:@"http://restotube.ru/user/payment/create?user_id=%@d&sum=300", [[Profile getInstance] m_id]];
//        NSURL* nsUrl = [NSURL URLWithString:[msg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        [[UIApplication sharedApplication] openURL:nsUrl] ;
        
//        ReplenishBalanceViewController *vc = [ReplenishBalanceViewController new];
//        vc.minSum = 0;
//        [self presentViewController:vc animated:YES completion:nil];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ReplenishNavigationController *nc = [storyboard instantiateViewControllerWithIdentifier:@"replenishNavigationController"];
        ReplenishBalanceViewController *vc = nc.viewControllers[0];
        vc.requiredSum = [Profile getInstance].m_balance + 1;
        [self presentViewController:nc animated:YES completion:nil];
    }
}

- (IBAction)onClickRestaurants:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"categoriesViewController"]]
                                                              animated:YES];
                 [self.sideMenuViewController hideMenuViewController];
}

- (IBAction)onClickFilters:(id)sender {
    CategoriesViewController* cat = [self.storyboard instantiateViewControllerWithIdentifier:@"categoriesViewController"];
    cat.needsFiltersOpen = YES;
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:cat] animated:YES];
    [self.sideMenuViewController hideMenuViewController];

}

- (IBAction)onClickProfile:(id)sender {
    CategoriesViewController* cat = [self.storyboard instantiateViewControllerWithIdentifier:@"categoriesViewController"];

    
    if([[Profile getInstance] isProfileLoaded] == NO) {
        cat.needsAuthOpen = YES;
    }
    else {
        cat.needsProfileOpen = YES;
    }

    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:cat] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

- (IBAction)onClickReservations:(id)sender {
    CategoriesViewController* cat = [self.storyboard instantiateViewControllerWithIdentifier:@"categoriesViewController"];
    
    if([[Profile getInstance] isProfileLoaded] == NO) {
        cat.needsAuthOpen = YES;
    }
    else {
        cat.needsReservationsOpen = YES;
    }
    
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:cat] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

- (IBAction)onClickAbout:(id)sender {
    CategoriesViewController* cat = [self.storyboard instantiateViewControllerWithIdentifier:@"categoriesViewController"];
    cat.needsAboutOpen = YES;
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:cat] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark -

-(void) balanceChanged:(NSNotification*)notification
{
    [[Profile getInstance] profileAuthByHashWithBlock:[Profile getInstance].m_hash :^(BOOL is_ok, NSError *error) {
        if (error == nil)
        {
            ;
        }
    }];
}

#pragma mark UIPicker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.cityList.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    _picker.hidden = YES;
    [self.buttonMoscow setTitle:self.cityList[row] forState:UIControlStateNormal];
    switch (row) {
        case 0:
            [ConstantsManager getInstance].city = @"moscow";
            break;
        case 1:
            [ConstantsManager getInstance].city = @"sochi";
            break;
        case 2:
            [ConstantsManager getInstance].city = @"rostov";
            break;
        case 3:
            [ConstantsManager getInstance].city = @"krasnodar";
            break;
            
        default:
            break;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* tView = (UILabel*)view;
    if (!tView) {
        tView = [[UILabel alloc] init];
        [tView setTextAlignment:NSTextAlignmentCenter];
        [tView setTextColor:[UIColor colorWithRed:170/255.0f green:31/255.0f blue:74/255.0f alpha:1]];//aa1f4a
        [tView setFont:[UIFont fontWithName:@"Helvetica" size:21]];
    }
    tView.text = self.cityList[row];
    return tView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

@end