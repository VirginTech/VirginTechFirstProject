//
//  StartScene.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/26.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "TitleScene.h"
#import "InformationLayer.h"
#import "SelectStage.h"
#import "GameManager.h"
#import "ShopView.h"
#import "IAdLayer.h"
#import "PreferencesLayer.h"
#import "InitializeManager.h"
#import "ItemSetupLayer.h"

@implementation TitleScene

CGSize winSize;

+ (TitleScene *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //ゲーム状態セット
    [GameManager setPlaying:false];
    [GameManager setPauseing:false];
    [GameManager setPauseStateChange:false];
    
    //画面状態
    [GameManager setActive:true];
    
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
    
    //初回データ初期値設定
    [InitializeManager initialize_All];
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background z:0];
    
    //iAdバナー表示
    IAdLayer* iAd=[[IAdLayer alloc]init:1];
    [self addChild:iAd];
    
    //インフォメーション z:1
    InformationLayer* infoLayer=[[InformationLayer alloc]init];
    [self addChild:infoLayer z:1];

    // タイトル
    CCLabelTTF *label = [CCLabelTTF labelWithString:
                                NSLocalizedString(@"Title",NULL) fontName:@"Chalkduster" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.6f); // Middle of screen
    [self addChild:label];
    
    //画像読込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button_default.plist"];
    
    //プレイボタン
    CCButton *stageButton=[CCButton buttonWithTitle:@"" spriteFrame:
                           [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"play.png"]];
    stageButton.positionType = CCPositionTypeNormalized;
    stageButton.position = ccp(0.5f, 0.35f);
    stageButton.scale=0.4;
    [stageButton setTarget:self selector:@selector(onSelectStageClicked:)];
    [self addChild:stageButton];

    // GameCenterボタン
    CCButton *gameCenterButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                  [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"gamecenter.png"]];
    gameCenterButton.positionType = CCPositionTypeNormalized;
    gameCenterButton.position = ccp(0.95f, 0.15f);
    gameCenterButton.scale=0.5;
    [gameCenterButton setTarget:self selector:@selector(onGameCenterClicked:)];
    [self addChild:gameCenterButton];
    
    //Twitter
    CCButton *twitterButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                  [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"twitter.png"]];
    twitterButton.positionType = CCPositionTypeNormalized;
    twitterButton.position = ccp(0.95f, 0.22f);
    twitterButton.scale=0.5;
    //[twitterButton setTarget:self selector:@selector(onTwitterClicked:)];
    [self addChild:twitterButton];
    
    //Facebook
    CCButton *facebookButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                  [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"facebook.png"]];
    facebookButton.positionType = CCPositionTypeNormalized;
    facebookButton.position = ccp(0.95f, 0.29f);
    facebookButton.scale=0.5;
    //[facebookButton setTarget:self selector:@selector(onFacebookClicked:)];
    [self addChild:facebookButton];

    //In-AppPurchaseボタン
    CCButton *inAppButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                    [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"shopBtn.png"]];
    inAppButton.positionType = CCPositionTypeNormalized;
    inAppButton.position = ccp(0.05f, 0.15f);
    inAppButton.scale=0.5;
    [inAppButton setTarget:self selector:@selector(onInAppPurchaseClicked:)];
    [self addChild:inAppButton];
    
    //環境設定
    CCButton *preferencesButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                   [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"configBtn.png"]];
    preferencesButton.positionType = CCPositionTypeNormalized;
    preferencesButton.position = ccp(0.05f, 0.22f);
    preferencesButton.scale=0.5;
    [preferencesButton setTarget:self selector:@selector(onPreferencesButtonClicked:)];
    [self addChild:preferencesButton];
    
    //クレジット
    CCButton *creditButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                   [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"creditBtn.png"]];
    creditButton.positionType = CCPositionTypeNormalized;
    creditButton.position = ccp(0.05f, 0.29f);
    creditButton.scale=0.5;
    //[creditButton setTarget:self selector:@selector(onCreditButtonClicked:)];
    [self addChild:creditButton];

    //アイテムセットアップ
    CCButton *itemSetupButton = [CCButton buttonWithTitle:@"[パワーアップ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    itemSetupButton.positionType = CCPositionTypeNormalized;
    itemSetupButton.position = ccp(0.5f, 0.2f);
    [itemSetupButton setTarget:self selector:@selector(onItemSetupButtonClicked:)];
    [self addChild:itemSetupButton];
    
    // done
	return self;
}

- (void)onSelectStageClicked:(id)sender
{
    if([GameManager getActive]){
        // start spinning scene with transition
        [[CCDirector sharedDirector] replaceScene:
                        [SelectStage scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
        //[[CCDirector sharedDirector] replaceScene:[Level_00 scene]withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
    }
}

-(void)onGameCenterClicked:(id)sender
{
    if([GameManager getActive]){
        lbv=[[LeaderboardView alloc]init];
        [lbv showLeaderboard];
    }
}

-(void)onInAppPurchaseClicked:(id)sender
{
    if([GameManager getActive]){
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
}

-(void)onPreferencesButtonClicked:(id)sender
{
    if([GameManager getActive]){
        [GameManager setActive:false];
        PreferencesLayer* prefence=[[PreferencesLayer alloc]init];
        [self addChild:prefence];
    }
}

-(void)onItemSetupButtonClicked:(id)sender
{
    if([GameManager getActive]){
        [GameManager setActive:false];
        ItemSetupLayer* itemSetup=[[ItemSetupLayer alloc]init];
        [self addChild:itemSetup];
    }
}

@end
