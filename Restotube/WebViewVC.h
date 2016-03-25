//
//  WebViewVC.h
//  YandexMoneyTest
//
//  Created by owel on 02/09/15.
//  Copyright (c) 2015 owel. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "YMAAPISession.h"

@protocol WebViewVCDelegate <NSObject>

-(void) webViewWillReturn: (BOOL)success;

@end

@interface WebViewVC : UIViewController

@property (strong, nonatomic) NSURLRequest      *requestToLoad;
//@property (strong, nonatomic) YMAAPISession     *session;
@property (strong, nonatomic) NSString          *book_id;
@property (assign, nonatomic) NSInteger         requiredBalance;

@property (assign, nonatomic) id<WebViewVCDelegate> delegate;

@end
