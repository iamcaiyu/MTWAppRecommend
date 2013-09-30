//
//  MTWAppRecommend.m
//  BWMaster
//
//  Created by CaiYu on 13-9-30.
//  Copyright (c) 2013年 Meituwan. All rights reserved.
//

#import "MTWAppRecommend.h"
#import <AFHTTPRequestOperationManager.h>

#define kMTWAppRecommend @"kMTWAppRecommend"
#define kMTWAppRecommendTime @"kMTWAppRecommendTime"

@interface MTWAppRecommend () {
    UIViewController *rViewController;
    NSString *appURL;
    NSDictionary *appRecommendDic;
    NSInteger timeToShow;
}

@end

@implementation MTWAppRecommend

+ (MTWAppRecommend*)sharedAppRecommend
{
    static MTWAppRecommend *appRecommend;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appRecommend=[[MTWAppRecommend alloc]init];
    });
    return appRecommend;
}

+ (void)setRootViewController:(UIViewController *)rootViewController
{
    [[MTWAppRecommend sharedAppRecommend]setRootViewController:rootViewController];
}

+ (void)setTime:(NSInteger)time
{
    [[MTWAppRecommend sharedAppRecommend]setTime:time];
}

+ (void)setURL:(NSString *)url
{
    [[MTWAppRecommend sharedAppRecommend]setURL:url];
}

+ (void)showAppRecommendView
{
    [[MTWAppRecommend sharedAppRecommend]showAppRecommendView];
}

- (void)setURL:(NSString*)URL
{
    appURL=URL;
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    [manager GET:appURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject!=nil) {
            NSUserDefaults *standardDefaults=[NSUserDefaults standardUserDefaults];
            [standardDefaults setObject:responseObject forKey:kMTWAppRecommend];
            [standardDefaults synchronize];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)setRootViewController:(UIViewController*)rootViewController
{
    rViewController=rootViewController;
}

- (void)setTime:(NSInteger)time
{
    timeToShow=time;
}

- (void)showAppRecommendView
{
    NSUserDefaults *standardDefaults=[NSUserDefaults standardUserDefaults];
    NSNumber *time=[standardDefaults objectForKey:kMTWAppRecommendTime];
    if (time==nil) {
        time=[NSNumber numberWithInteger:0];
    }
    NSInteger timeInteger=[time integerValue];
    if (timeInteger>=timeToShow) {
        appRecommendDic=[standardDefaults objectForKey:kMTWAppRecommend];
        if (appRecommendDic!=nil) {
            NSString *title=[appRecommendDic objectForKey:@"title"];
            NSString *content=[appRecommendDic objectForKey:@"content"];
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"View", nil];
            [alertView show];
        }
        timeInteger=0;
    } else {
        timeInteger++;
    }
    [standardDefaults setObject:[NSNumber numberWithInteger:timeInteger] forKey:kMTWAppRecommendTime];
    [standardDefaults synchronize];
}

#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSNumber *appid=[NSNumber numberWithInteger:[[appRecommendDic objectForKey:@"id"]integerValue]];
        SKStoreProductViewController *storeProductViewController=[[SKStoreProductViewController alloc]init];
        [storeProductViewController loadProductWithParameters:[NSDictionary dictionaryWithObject:appid forKey:SKStoreProductParameterITunesItemIdentifier] completionBlock:^(BOOL result, NSError *error){
            NSLog(@"%@",error);
        }];
        storeProductViewController.delegate=self;
        [rViewController presentViewController:storeProductViewController animated:YES completion:nil];
    }
}

#pragma mark SKStoreProductViewController Delegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
