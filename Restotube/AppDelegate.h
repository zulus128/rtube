//
//  AppDelegate.h
//  Restotube
//
//  Created by Maksim Kis on 31.03.15.
//  Copyright (c) 2015 Maksim Kis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define NDM_BALANCE_CHANGED @"balanceChanged"

#define YA_MONEY_URL        @"https://money.yandex.ru/eshop.xml"
#define YA_MONEY_SHOP_ID    @"34456"
#define YA_MONEY_SCID       @"34623"    /*@"526809"*/

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (readonly, assign, nonatomic) BOOL isFirstTimeLaunch;

@end

