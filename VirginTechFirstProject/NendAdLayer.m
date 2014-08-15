//
//  NendAdLayer.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/08/05.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "NendAdLayer.h"
#import "GameManager.h"

@implementation NendAdLayer

@synthesize nadView;

CGSize winSize;

+ (NendAdLayer*)scene
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    if([GameManager getDevice]==3){//iPad
        
        nadView = [[NADView alloc] initWithFrame:CGRectMake(0, 0, 728, 90)];
        nadView.frame=CGRectOffset(nadView.frame, 20,winSize.height*2-nadView.frame.size.height);//20,940
        [nadView setNendID:@"eb677269310d1106785785de3456b9dfbeeaabdd" spotID:@"213467"];//本番
        //[nadView setNendID:@"2e0b9e0b3f40d952e6000f1a8c4d455fffc4ca3a" spotID:@"70999"];//テスト
        
    }else{//iPhone
        
        nadView = [[NADView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        nadView.frame=CGRectOffset(nadView.frame, 0,winSize.height-nadView.frame.size.height);
        //[nadView setNendID:@"aa3ae540353f82776f1e51df58ce2b59a508ea91" spotID:@"213114"];//本番
        [nadView setNendID:@"a6eca9dd074372c898dd1df549301f277c53f2b9" spotID:@"3172"];//テスト
    }
    
    [nadView setIsOutputLog:NO];
    [nadView setDelegate:self];
    [nadView load];

    [[[CCDirector sharedDirector]view]addSubview:nadView];

    return self;
}

- (void)nadViewDidFinishLoad:(NADView *)adView {
    
}

- (void) dealloc
{
    [nadView setDelegate:nil]; //delegate に nil をセット
    [nadView removeFromSuperview];
    nadView = nil; //プロパティ経由で release、nil をセット
    //[superdealloc]; //MRC(非ARC時には必要)
}

//広告取得失敗時の処理
-(void)nadViewDidFailToReceiveAd:(NADView *)adView
{
    [nadView setDelegate:nil]; //delegate に nil をセット
    [nadView removeFromSuperview];
    nadView = nil; //プロパティ経由で release、nil をセット
    //[superdealloc]; //MRC(非ARC時には必要)
}

@end
