//
//  GameFeatLayer.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/08/16.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "GameFeatLayer.h"
#import "GameManager.h"

@implementation GameFeatLayer

CGSize winSize;

+ (GameFeatLayer*)scene
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //アイコン広告
    gfIconController = [[GFIconController alloc] init];
    [gfIconController setRefreshTiming:30];
    
    {
        GFIconView *iconView = [[GFIconView alloc] initWithFrame:CGRectMake(18, 320, 60, 60)];
        [gfIconController addIconView:iconView];
        [[[CCDirector sharedDirector]view]addSubview:iconView];
    }
    {
        GFIconView *iconView = [[GFIconView alloc] initWithFrame:CGRectMake(90, 320, 60, 60)];
        [gfIconController addIconView:iconView];
        [[[CCDirector sharedDirector]view]addSubview:iconView];
    }
    {
        GFIconView *iconView = [[GFIconView alloc] initWithFrame:CGRectMake(162, 320, 60, 60)];
        [gfIconController addIconView:iconView];
        [[[CCDirector sharedDirector]view]addSubview:iconView];
    }
    {
        GFIconView *iconView = [[GFIconView alloc] initWithFrame:CGRectMake(234, 320, 60, 60)];
        [gfIconController addIconView:iconView];
        [[[CCDirector sharedDirector]view]addSubview:iconView];
    }

    //ウォールボタン
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button_default.plist"];

    CCButton* moreAppBtn;
    if([GameManager getLocale]==1){//英語
        moreAppBtn=[CCButton buttonWithTitle:@"" spriteFrame:
                            [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"gfBtn_en.png"]];
    }else{
        moreAppBtn=[CCButton buttonWithTitle:@"" spriteFrame:
                            [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"gfBtn_jp.png"]];
    }
    moreAppBtn.positionType = CCPositionTypeNormalized;
    moreAppBtn.position = ccp(0.5f, 0.15f);
    moreAppBtn.scale=0.7;
    [moreAppBtn setTarget:self selector:@selector(onMoreAppBtnClicked:)];
    [self addChild:moreAppBtn];

    
    return self;
}

-(void)onEnter
{
    [super onEnter];
    [gfIconController loadAd:@"7627"];
    [gfIconController visibleIconAd];
}

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

-(void)onMoreAppBtnClicked:(id)sender
{
    //CCAppDelegate *delegate = (CCAppDelegate *)[[UIApplication sharedApplication] delegate];
    [GFController showGF:[CCDirector sharedDirector] site_id:@"7627" delegate:self];
}

//=======================================================
// GFViewDelegate
//=======================================================
- (void)didShowGameFeat{
    // GameFeatが表示されたタイミングで呼び出されるdelegateメソッド
    //NSLog(@"didShowGameFeat");
}
- (void)didCloseGameFeat{
    // GameFeatが閉じられたタイミングで呼び出されるdelegateメソッド
    //NSLog(@"didCloseGameFeat");
}

@end
