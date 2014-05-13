//
//  NaviLayer.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/02.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "NaviLayer.h"
#import "TitleScene.h"
#import "SelectStage.h"

@implementation NaviLayer

CGSize winSize;

CCNodeColor *background;
CCButton *pauseButton;
CCButton *titleButton;
CCButton *stageButton;

+ (NaviLayer *)scene{
    
    return [[self alloc] init];
}

- (id)init{
    
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //BGカラー
    background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.5f]];
    [self addChild:background];
    background.visible=false;

    //ポーズボタン
    pauseButton = [CCButton buttonWithTitle:@"[ポーズ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    pauseButton.positionType = CCPositionTypeNormalized;
    pauseButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [pauseButton setTarget:self selector:@selector(onPauseClicked:)];
    [self addChild:pauseButton];

    //タイトルボタン
    titleButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:18.0f];
    titleButton.positionType = CCPositionTypeNormalized;
    titleButton.position = ccp(0.50f, 0.50f); // Top Right of screen
    [titleButton setTarget:self selector:@selector(onTitleClicked:)];
    [self addChild:titleButton];
    titleButton.visible=false;
    
    //セレクトステージ
    stageButton = [CCButton buttonWithTitle:@"[セレクトステージ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    stageButton.positionType = CCPositionTypeNormalized;
    stageButton.position = ccp(0.5f, 0.45f);
    [stageButton setTarget:self selector:@selector(onSelectStageClicked:)];
    [self addChild:stageButton];
    stageButton.visible=false;
    
    return self;
}

- (void)onPauseClicked:(id)sender
{
    if([[CCDirector sharedDirector]isPaused]){//ポーズ中〜開始
        [[CCDirector sharedDirector]resume];
        [GameManager setPauseing:false];
        pauseButton.title=@"[ポーズ]";
        background.visible=false;
        //ナビボタン
        titleButton.visible=false;
        stageButton.visible=false;
        
    }else{//開始中〜ポーズ
        [[CCDirector sharedDirector]pause];
        [GameManager setPauseing:true];
        pauseButton.title=@"[再　開]";
        background.visible=true;
        //ナビボタン
        titleButton.visible=true;
        stageButton.visible=true;
    }
}

- (void)onTitleClicked:(id)sender
{
    [[CCDirector sharedDirector]resume];
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}
- (void)onSelectStageClicked:(id)sender
{
    [[CCDirector sharedDirector]resume];
    [[CCDirector sharedDirector] replaceScene:[SelectStage scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}
@end
