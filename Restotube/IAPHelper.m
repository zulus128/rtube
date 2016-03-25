//
//  IAPHelper.m
//  centrallo
//
//  Created by Kirill Pyulzyu on 01.04.14.
//  Copyright (c) 2014 Centrallo, LLC. All rights reserved.
//

#import "IAPHelper.h"

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";

@interface IAPHelper () <SKProductsRequestDelegate>

@end

@implementation IAPHelper
{
    SKProductsRequest *_productsRequest;
    RequestProductsCompletionHandler _completionHandler;
    NSSet *_productIdentifiers;
    NSMutableSet *_purchasedProductIdentifiers;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init]))
    {
        
        // Сохраняем идентификаторы продуктов
        _productIdentifiers = productIdentifiers;
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

+ (IAPHelper *)helper
{
    static IAPHelper *helper = nil;
    if (helper == nil)
    {
        helper = [[IAPHelper alloc] initWithProductRestotubeProudcts];
    }
    return helper;
}

- (id)initWithProductRestotubeProudcts
{
    
    NSSet *set = [NSSet  setWithObjects:@"ru.restotube.InAppPurchases.reservation10",@"ru.restotube.InAppPurchases.reservation15",@"ru.restotube.InAppPurchases.reservation20",@"ru.restotube.InAppPurchases.reservation25",@"ru.restotube.InAppPurchases.reservation30",@"ru.restotube.InAppPurchases.reservation35",@"ru.restotube.InAppPurchases.reservation40",@"ru.restotube.InAppPurchases.reservation45",@"ru.restotube.InAppPurchases.reservation50",@"ru.restotube.InAppPurchases.reservationPresent", nil];
    NSMutableSet *resSet = [NSMutableSet setWithSet:set];
    for (int j = 10; j<= 30; j+= 5)
    {
        for (int i = 2; i< 15;i++)
        {
            [resSet addObject:[NSString stringWithFormat:@"ru.restotube.InAppPurchases.reservation%d.%d",j,i]];
        }
    }
    for (int i = 2; i< 15;i++)
    {
        [resSet addObject:[NSString stringWithFormat:@"ru.restotube.InAppPurchases.reservationPresent.%d",i]];
    }
    return [[IAPHelper alloc] initWithProductIdentifiers:resSet];
}

- (void)requestProductIdentifier:(NSString *)identifier withCompletionHandler:(RequestProductsCompletionHandler)completionHandler
{
    _completionHandler = [completionHandler copy];
    
    NSSet *set = [NSSet setWithObject:identifier];
    // 2
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    _productsRequest.delegate = self;
    [_productsRequest start];
}
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler
{
    
    // 1
    _completionHandler = [completionHandler copy];
    
    // 2
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
    
}


#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"Загруженый список продуктов...");
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts)
    {
        NSLog(@"Найден продукт: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    if (_completionHandler)
        _completionHandler(YES, skProducts);
    
    _completionHandler = nil;
    
}


- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    
    NSLog(@"Не смог загрузить список продуктов.");
    NSLog(@"%@", error);
    _productsRequest = nil;
    
    if(_completionHandler)
        _completionHandler(NO, nil);
    
    _completionHandler = nil;
    
}


- (BOOL)productPurchased:(NSString *)productIdentifier
{
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product
{
    NSLog(@"Buying %@...", product.productIdentifier);
    
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
    
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"completeTransaction...");
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:nil userInfo:nil];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"restoreTransaction...");
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)restoreCompletedTransactions
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

@end
