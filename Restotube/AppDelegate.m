//
//  AppDelegate.m
//  Restotube
//
//  Created by Maksim Kis on 31.03.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import "ConstantsManager.h"
#import "IntroViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Profile.h"
#import "RequestManager.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    application.statusBarHidden = NO;
    

    // check for first time launch
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"launchedBefore"])
    {
        _isFirstTimeLaunch = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"launchedBefore"];
    }
    
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:@"AIzaSyDTePL9WprHROYZQYAs6fZXqhLYaeVfrMM"];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:255.0f/255.0f green:35.0f/255.0f blue:101.0f/255.0f alpha:1.0f]];
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor], NSForegroundColorAttributeName,
//                                               [UIFont fontWithName:@"HelveticaNeue-Light" size:16], NSFontAttributeName,
                                                nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [ConstantsManager getInstance];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (_isFirstTimeLaunch)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        IntroViewController * destViewController = [storyboard instantiateViewControllerWithIdentifier:@"IntroViewController"];
        self.window.rootViewController = destViewController;
        [self.window makeKeyAndVisible];
    }
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge |
                                                                                UIRemoteNotificationTypeSound |
                                                                                UIRemoteNotificationTypeAlert)];
    } else {
        UIUserNotificationSettings *settings =  [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |
                                                                                              UIUserNotificationTypeAlert |
                                                                                              UIUserNotificationTypeBadge) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    [Fabric with:@[[Crashlytics class]]];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:url.path message:sourceApplication delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    return YES;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "ru.Restotube" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Restotube" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Restotube.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Push notifications

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken  {
    NSString *tokenString = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                              stringByReplacingOccurrencesOfString: @">" withString: @""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
//    NSLog(@"-Successfully got token: %@", deviceToken);
    NSLog(@"Successfully got token: %@", tokenString);
    [Profile getInstance].pushToken = tokenString;
    [self registerTokenOnServer];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)registerTokenOnServer {

    Profile *prof = [Profile getInstance];
//    NSLog(@"--- user_id=%@ device_token=%@", prof.m_id, prof.pushToken);
    
    if (!prof.pushToken || !prof.m_id) {
        return;
    }
    NSString* urlrequest = [NSString stringWithFormat:@"setDeviceToken?user_id=%@&device_token=%@", prof.m_id, prof.pushToken];

    [[RequestManager sharedManager] GET:urlrequest parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
         NSLog(@"registerTokenOnServer Success: %@", JSON);
         
     } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
         NSLog(@"registerTokenOnServer Error: %@", error);
     }];

}

@end


@implementation UIViewController (HackRotation)

- (BOOL)shouldAutorotate
{
    return [self hackShouldSupportAnyOrientation];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([self hackShouldSupportAnyOrientation]) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)hackShouldSupportAnyOrientation
{
    return [self isKindOfClass:[MPMoviePlayerViewController class]];
}

@end
