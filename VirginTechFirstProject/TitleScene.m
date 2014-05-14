//
//  StartScene.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/26.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "TitleScene.h"
//#import "HelloWorldScene.h"
#import "SelectStage.h"
#import "GameManager.h"
#import "ShopView.h"
#import "IAdLayer.h"
#import "PreferencesLayer.h"

@implementation TitleScene

+ (TitleScene *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    //ゲーム状態セット
    [GameManager setPlaying:false];
    [GameManager setPauseing:false];
    [GameManager setPauseStateChange:false];
    
    //デバイス登録
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if(screenBounds.size.height==568){ //iPhone5 (4インチスクリーン)用のレイアウト
        [GameManager setDevice:1];
    }else if(screenBounds.size.height==480){ //iPhone4 (3.5インチスクリーン)用のレイアウト
        [GameManager setDevice:2];
    }else if(screenBounds.size.height==1024){ //iPad2 (1024px)
        [GameManager setDevice:3];
    }else{
        [GameManager setDevice:0];
    }
    //NSLog(@"デバイスは %d です。",[GameManager getDevice]);
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    //iAdバナー表示
    IAdLayer* iAd=[[IAdLayer alloc]init:1];
    [self addChild:iAd];
    
    // タイトル
    CCLabelTTF *label = [CCLabelTTF labelWithString:
                                NSLocalizedString(@"Title",NULL) fontName:@"Chalkduster" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.5f); // Middle of screen
    [self addChild:label];
    
    // スタートボタン
    CCButton *stageButton = [CCButton buttonWithTitle:@"[ スタート ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    stageButton.positionType = CCPositionTypeNormalized;
    stageButton.position = ccp(0.5f, 0.35f);
    [stageButton setTarget:self selector:@selector(onSelectStageClicked:)];
    [self addChild:stageButton];

    // GameCenterボタン
    CCButton *gameCenterButton = [CCButton buttonWithTitle:@"[Game Center]" fontName:@"Verdana-Bold" fontSize:18.0f];
    gameCenterButton.positionType = CCPositionTypeNormalized;
    gameCenterButton.position = ccp(0.5f, 0.30f);
    [gameCenterButton setTarget:self selector:@selector(onGameCenterClicked:)];
    [self addChild:gameCenterButton];

    //In-AppPurchaseボタン
    CCButton *inAppButton = [CCButton buttonWithTitle:@"[ ショップ ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    inAppButton.positionType = CCPositionTypeNormalized;
    inAppButton.position = ccp(0.5f, 0.25f);
    [inAppButton setTarget:self selector:@selector(onInAppPurchaseClicked:)];
    [self addChild:inAppButton];
    
    //環境設定
    CCButton *preferencesButton = [CCButton buttonWithTitle:@"[ 環境設定 ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    preferencesButton.positionType = CCPositionTypeNormalized;
    preferencesButton.position = ccp(0.15f, 0.95f);
    [preferencesButton setTarget:self selector:@selector(onPreferencesButtonClicked:)];
    [self addChild:preferencesButton];
    
    //マシンメンテナンス
    
    
    // done
	return self;
}

- (void)onSelectStageClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[SelectStage scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    //[[CCDirector sharedDirector] replaceScene:[Level_00 scene]withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

-(void)onGameCenterClicked:(id)sender
{    
    lbv=[[LeaderboardView alloc]init];
    [lbv showLeaderboard];
}

-(void)onInAppPurchaseClicked:(id)sender
{
    //アプリ内購入の設定チェック
    if (![SKPaymentQueue canMakePayments]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー！"
                                                        message:@"アプリ内課金が使用制限されています。"
                                                        delegate:nil
                                                        cancelButtonTitle:nil
                                                        otherButtonTitles:@"OK", nil];
        [alert show];
        return;
        
    }else{
        //ショップ画面へ
        [[CCDirector sharedDirector] replaceScene:[ShopView scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];

    }
}

-(void)onPreferencesButtonClicked:(id)sender
{
    PreferencesLayer* prefence=[[PreferencesLayer alloc]init];
    [self addChild:prefence];
}

@end
