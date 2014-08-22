//
//  IMobileLayer.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/08/22.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "IMobileLayer.h"
#import "GameManager.h"

@implementation IMobileLayer

CGSize winSize;

+ (IMobileLayer*)scene
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    [ImobileSdkAds registerWithPublisherID:@"31967" MediaID:@"115572" SpotID:@"276558"];
    [ImobileSdkAds startBySpotID:@"276558"];
    
    if([GameManager getDevice]==3){//iPad
        //表示しない
    }else{//iPhone
        adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        adView.frame=CGRectOffset(adView.frame, 0,winSize.height-adView.frame.size.height);

        [[[CCDirector sharedDirector]view]addSubview:adView];
        
        [ImobileSdkAds setSpotDelegate:@"276558" delegate:self];
        [ImobileSdkAds showBySpotID:@"276558" View:adView];
    }
    
    
    return self;
}

- (void) dealloc
{
    [ImobileSdkAds setSpotDelegate:@"276558" delegate:nil];
    [adView removeFromSuperview];
    adView=nil;
}

//広告の表示が準備完了した際に呼ばれます
- (void)imobileSdkAdsSpot:(NSString *)spotId didReadyWithValue:(ImobileSdkAdsReadyResult)value{};

//広告の取得を失敗した際に呼ばれます
- (void)imobileSdkAdsSpot:(NSString *)spotId didFailWithValue:(ImobileSdkAdsFailResult)value{};

//広告の表示要求があった際に、準備が完了していない場合に呼ばれます
- (void)imobileSdkAdsSpotIsNotReady:(NSString *)spotId{};

//広告クリックした際に呼ばれます
- (void)imobileSdkAdsSpotDidClick:(NSString *)spotId{};

//広告を閉じた際に呼ばれます(広告の表示がスキップされた場合も呼ばれます)
- (void)imobileSdkAdsSpotDidClose:(NSString *)spotId{};

//広告の表示が完了した際に呼ばれます
- (void)imobileSdkAdsSpotDidShow:(NSString *)spotId{};

@end
