//
//  MTWAppRecommend.h
//  BWMaster
//
//  Created by CaiYu on 13-9-30.
//  Copyright (c) 2013年 Meituwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface MTWAppRecommend : NSObject <UIAlertViewDelegate, SKStoreProductViewControllerDelegate>

+ (void)setURL:(NSString*)url;
+ (void)setRootViewController:(UIViewController*)rootViewController;
+ (void)showAppRecommendView;
+ (void)setTime:(NSInteger)time;

@end
