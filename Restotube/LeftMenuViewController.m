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
#import "NearMeViewController.h"
#import "ConstantsManager.h"
#import "RequestManager.h"
#import "AppDelegate.h"
#import "ReplenishBalanceViewController.h"
#import "ReplenishNavigationController.h"


@interface LeftMenuViewController ()

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

@end

@implementation LeftMenuViewController

- (void)viewDidLoad
{
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
        self.imageAvatar.layer.cornerRadius = 70 / 2;
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
         _imageAvatar.image = [self resizeImage:image imageSize: CGSizeMake(70, 70)];
         self.imageAvatar.layer.cornerRadius = 70 / 2;
         self.imageAvatar.layer.masksToBounds = YES;
         self.imageAvatar.layer.borderWidth  = 0;
     }
                                     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                         NSLog(@"error8: %@", error);
                                     }];
    
    self.labelBalance.text = [NSString stringWithFormat: @"%ld руб.", (long)[[Profile getInstance] m_balance]];


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
    if (sender == _buttonMoscow)
    {
        _buttonMoscow.selected = YES;
        _buttonSochi.selected = NO;
        [ConstantsManager getInstance].city = @"moscow";
    }
    else
    {
        _buttonMoscow.selected = NO;
        _buttonSochi.selected = YES;
        [ConstantsManager getInstance].city = @"sochi";
    }
    
    UINavigationController *nc = (UINavigationController *)self.sideMenuViewController.contentViewController;
    if (nc.childViewControllers.count > 1)
    {
        [nc popToRootViewControllerAnimated:NO];
    }
    UIViewController *vc = nc.childViewControllers.firstObject;
    if ([vc isKindOfClass:[CategoriesViewController class]])
    {
        [(CategoriesViewController *)vc reload:nil];
    }
}

- (IBAction)onNearButton:(id)sender {
    CategoriesViewController* cat = [self.storyboard instantiateViewControllerWithIdentifier:@"categoriesViewController"];
    cat.needsNearOpen = YES;
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

@end