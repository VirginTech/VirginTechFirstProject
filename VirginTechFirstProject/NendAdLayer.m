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

@synthesize _nadView;

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
        
        _nadView = [[NADView alloc] initWithFrame:CGRectMake(0, 0, 728, 90)];
        _nadView.frame=CGRectOffset(_nadView.frame, 20,winSize.height*2-_nadView.frame.size.height);//20,940
        [_nadView setNendID:@"eb677269310d1106785785de3456b9dfbeeaabdd" spotID:@"213467"];
        
    }else{//iPhone
        
        _nadView = [[NADView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        _nadView.frame=CGRectOffset(_nadView.frame, 0,winSize.height-_nadView.frame.size.height);
        [_nadView setNendID:@"aa3ae540353f82776f1e51df58ce2b59a508ea91" spotID:@"213114"];
        
    }
    
    [[[CCDirector sharedDirector]view]addSubview:_nadView];
    [_nadView setDelegate:self];
    [_nadView load];

    return self;
}

- (void) dealloc
{
    [_nadView setDelegate:nil]; //delegate に nil をセット
    _nadView = nil; //プロパティ経由で release、nil をセット
    [_nadView removeFromSuperview];
    //[superdealloc]; //MRC(非ARC時には必要)
}

//広告取得失敗時の処理
-(void)nadViewDidFailToReceiveAd:(NADView *)adView
{
    [_nadView setDelegate:nil]; //delegate に nil をセット
    _nadView = nil; //プロパティ経由で release、nil をセット
    [_nadView removeFromSuperview];
    //[superdealloc]; //MRC(非ARC時には必要)
}

@end
