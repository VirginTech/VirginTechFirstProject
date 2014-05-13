//
//  IAdLayer.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/13.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "IAdLayer.h"

@implementation IAdLayer

CGSize winSize;
bool _bannerIsVisible;
int bannerType;

+ (IAdLayer*)scene
{
    return [[self alloc] init];
}

- (id)init:(int)type
{    
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    bannerType=type;
    
    // iAd設定
    iAdView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    iAdView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    [[[CCDirector sharedDirector] view] addSubview:iAdView];
    
    if(bannerType==0){//上部表示
        iAdView.frame = CGRectOffset(iAdView.frame, 0, -iAdView.frame.size.height);
    }else if(bannerType==1){//下部表示
        iAdView.frame = CGRectOffset(iAdView.frame, 0, [[UIScreen mainScreen] bounds].size.height);
    }else if(bannerType==2){//フルスクリーン
        
    }else{
        
    }
    iAdView.delegate = self;
    _bannerIsVisible = NO;
    
    return self;
}

- (void)dealloc
{
    [iAdView removeFromSuperview];
}

//iAd広告取得成功時の処理
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!_bannerIsVisible) {
        [UIView animateWithDuration:0.3 animations:^{
            
            if(bannerType==0){//上部表示
                iAdView.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
            }else if(bannerType==1){//下部表示
                iAdView.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
            }else if(bannerType==2){//フルスクリーン
                
            }else{
                
            }
        }];
        _bannerIsVisible = YES;
    }
    
}

//iAd広告取得失敗時の処理
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [iAdView removeFromSuperview];
    iAdView = nil;
}

@end
