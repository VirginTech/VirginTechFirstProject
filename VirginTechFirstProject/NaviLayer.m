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
#import "PreferencesLayer.h"
#import "GameManager.h"
#import "ItemSetupLayer.h"

@implementation NaviLayer

CGSize winSize;

CCLabelTTF *label;
CCNodeColor *background;
CCButton *pauseButton;
CCButton *titleButton;
CCButton *stageButton;
CCButton *preferencesButton;
CCButton *itemSetupButton;

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
    
    //環境設定
    preferencesButton = [CCButton buttonWithTitle:@"[ 環境設定 ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    preferencesButton.positionType = CCPositionTypeNormalized;
    preferencesButton.position = ccp(0.5f, 0.40f);
    [preferencesButton setTarget:self selector:@selector(onPreferencesButtonClicked:)];
    [self addChild:preferencesButton];
    preferencesButton.visible=false;
    
    //アイテムセットアップ
    itemSetupButton = [CCButton buttonWithTitle:@"[パワーアップ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    itemSetupButton.positionType = CCPositionTypeNormalized;
    itemSetupButton.position = ccp(0.5f, 0.35f);
    [itemSetupButton setTarget:self selector:@selector(onItemSetupButtonClicked:)];
    [self addChild:itemSetupButton];
    itemSetupButton.visible=false;
    
    //ラベル
    label = [CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:36.0f];
    label.color = [CCColor whiteColor];
    label.positionType = CCPositionTypeNormalized;
    label.position = ccp(0.50f, 0.65f); // Top Right of screen
    [self addChild:label];
    
    return self;
}

+(void)setStageEndingScreen:(bool)clearFlg
{
    if(clearFlg){
        label.string = @"あなたの勝利です！";
    }else{
        label.string = @"あなたの負けです";
    }
    pauseButton.visible=false;
    background.visible=true;
    titleButton.visible=true;
    stageButton.visible=true;
    preferencesButton.visible=true;
    itemSetupButton.visible=true;
}

+(void)setPauseScreen
{
    if([GameManager getPauseing]){//ポーズ中
        pauseButton.title=@"[再　開]";
        background.visible=true;
        titleButton.visible=true;
        stageButton.visible=true;
        preferencesButton.visible=true;
        itemSetupButton.visible=true;
    }else{//再開中
        pauseButton.title=@"[ポーズ]";
        background.visible=false;
        titleButton.visible=false;
        stageButton.visible=false;
        preferencesButton.visible=false;
        itemSetupButton.visible=false;
    }
}

- (void)onPauseClicked:(id)sender
{
    if([GameManager getPauseing]){//再開する
        [GameManager setPauseStateChange:true];
        [GameManager setPauseing:false];
    }else{//ポーズする
        [GameManager setPauseStateChange:true];
        [GameManager setPauseing:true];
    }
    [NaviLayer setPauseScreen];
}

- (void)onTitleClicked:(id)sender
{
    //[[CCDirector sharedDirector]resume];
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}
- (void)onSelectStageClicked:(id)sender
{
    //[[CCDirector sharedDirector]resume];
    [[CCDirector sharedDirector] replaceScene:[SelectStage scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}
- (void)onPreferencesButtonClicked:(id)sender
{
    PreferencesLayer* prefence=[[PreferencesLayer alloc]init];
    [self addChild:prefence];
}
-(void)onItemSetupButtonClicked:(id)sender
{
    if([GameManager getActive]){
        //[GameManager setActive:false];
        ItemSetupLayer* itemSetup=[[ItemSetupLayer alloc]init];
        [self addChild:itemSetup];
    }
}

@end
