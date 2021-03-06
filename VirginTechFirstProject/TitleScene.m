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
#import "PreferencesLayer.h"
#import "ItemSetupLayer.h"
#import "CreditLayer.h"
#import "TutorialLevel.h"
#import "SoundManager.h"

#import "IAdLayer.h"
#import "NendAdLayer.h"
#import "GameFeatLayer.h"
#import "IMobileLayer.h"
#import "AdGenerLayer.h"

@implementation TitleScene

CGSize winSize;
CCSprite* finger;
GameFeatLayer* gfAd;

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
    
    //オープニングBGM
    [SoundManager playBGM];
    
    //ゲーム状態セット
    [GameManager setPlaying:false];
    [GameManager setPauseing:false];
    [GameManager setPauseStateChange:false];
    
    //画面状態
    [GameManager setActive:true];
    
    // Create a colored background (Dark Grey)
    //CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    //[self addChild:background z:0];
    
    //タイトル画像
    CCSprite* title=[CCSprite spriteWithImageNamed:@"title.png"];
    title.position=ccp(winSize.width/2,winSize.height/2);
    title.scale=0.5;
    [self addChild:title];
    
    //タイトルロゴ
    CCSprite* logo;
    if([GameManager getLocale]==1){//英語
        logo=[CCSprite spriteWithImageNamed:@"title_logo_en.png"];
    }else{//日本語
        logo=[CCSprite spriteWithImageNamed:@"title_logo_jp.png"];
    }
    float rate;
    float offY;
    if([GameManager getDevice]==3){//iPad
        rate=0.4;
        offY=20.0;
    }else{
        rate=0.35;
        offY=0.0;
    }
    logo.position=ccp(winSize.width/2,winSize.height-(logo.contentSize.height*rate)/2+offY);
    logo.scale=rate;
    [self addChild:logo];
    
    //iAdバナー表示
    //IAdLayer* iAd=[[IAdLayer alloc]init:1];
    //[self addChild:iAd];
    
    //NendAdバナー表示
    //NendAdLayer* nAd=[[NendAdLayer alloc]init];
    //[self addChild:nAd];

    //iMobileバナー
    //IMobileLayer* iMAd=[[IMobileLayer alloc]init];
    //[self addChild:iMAd];
    
    //ADG-SSPバナー
    AdGenerLayer* adgSSP=[[AdGenerLayer alloc]init];
    [self addChild:adgSSP];
    
    //GameFeat広告
    gfAd=[[GameFeatLayer alloc]init];
    [self addChild:gfAd];
    
    //インフォメーション z:1
    InformationLayer* infoLayer=[[InformationLayer alloc]init];
    [self addChild:infoLayer z:1];

    /*/ タイトル
    CCLabelTTF *label = [CCLabelTTF labelWithString:
                                NSLocalizedString(@"Title",NULL) fontName:@"Chalkduster" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.6f); // Middle of screen
    [self addChild:label];
    */
    
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
    [twitterButton setTarget:self selector:@selector(onTwitterClicked:)];
    [self addChild:twitterButton];
    
    //Facebook
    CCButton *facebookButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                  [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"facebook.png"]];
    facebookButton.positionType = CCPositionTypeNormalized;
    facebookButton.position = ccp(0.95f, 0.29f);
    facebookButton.scale=0.5;
    [facebookButton setTarget:self selector:@selector(onFacebookClicked:)];
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
    [creditButton setTarget:self selector:@selector(onCreditButtonClicked:)];
    [self addChild:creditButton];

    //アイテムセットアップ
    CCButton *itemSetupButton = [CCButton buttonWithTitle:@"" spriteFrame:
                              [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"itemSetBtn.png"]];
    itemSetupButton.positionType = CCPositionTypeNormalized;
    itemSetupButton.position = ccp(0.32f, 0.25f);
    itemSetupButton.scale=0.7;
    [itemSetupButton setTarget:self selector:@selector(onItemSetupButtonClicked:)];
    [self addChild:itemSetupButton];

    //チュートリアル
    CCButton *tutorialButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                 [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"tutorialBtn.png"]];
    tutorialButton.positionType = CCPositionTypeNormalized;
    tutorialButton.position = ccp(0.68f, 0.25f);
    tutorialButton.scale=0.7;
    [tutorialButton setTarget:self selector:@selector(onTutorialButtonClicked:)];
    [self addChild:tutorialButton];

    //画像読込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"interface_default.plist"];
    //チュートリアルが実行されていなければ「指」を表示
    if([GameManager load_Aggregate_Stage]<0){
        finger=[CCSprite spriteWithSpriteFrame:
                                [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"finger.png"]];
        finger.positionType = CCPositionTypeNormalized;
        finger.position=ccp(tutorialButton.position.x+0.1,tutorialButton.position.y);
        finger.scale=0.5;
        [self addChild:finger];
        [self schedule:@selector(finger_Rotation_Schedule:)interval:0.01];
    }
    
    //バージョン
    CCLabelTTF* versionLabel=[CCLabelTTF labelWithString:@"Version 1.1.0" fontName:@"Verdana" fontSize:13];
    versionLabel.position=ccp(winSize.width-versionLabel.contentSize.width/2,winSize.height-versionLabel.contentSize.height/2);
    [self addChild:versionLabel];
    
    /*/デイリー・ボーナス
    NSDate* currentDate=[NSDate date];//現在ログイン日時（GMTで貫く）
    NSCalendar *calen = [NSCalendar currentCalendar];//日付のみに変換
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *comps = [calen components:unitFlags fromDate:currentDate];
    currentDate = [calen dateFromComponents:comps];
    
    NSDate* recentDate=[GameManager load_Login_Date];//前回ログイン日
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];//バンドル取得
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:appDomain];
    
    if([dict valueForKey:@"LoginDate"]==nil //初回なら
       || [currentDate compare:recentDate]==NSOrderedDescending){ //もしくは、日付が変わってるなら
        
        [GameManager save_login_Date:currentDate];
        
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.delegate = self;
        alert.title = NSLocalizedString(@"BonusGet",NULL);
        alert.message = NSLocalizedString(@"DailyBonus",NULL);
        [alert addButtonWithTitle:NSLocalizedString(@"OK",NULL)];
        [alert show];
    }*/
    
    // done
	return self;
}

- (void)dealloc
{
    // clean up code goes here
}

-(void)onEnter
{
    [super onEnter];
}

- (void)onExit
{
    // always call super onExit last
    [super onExit];
    //[SoundManager stopBGM];
}

/*-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //ダイヤ付与
    [GameManager save_Currency_Dia:[GameManager load_Currency_Dia]+ 1];
    [InformationLayer update_CurrencyLabel];
}*/

-(void)finger_Rotation_Schedule:(CCTime)dt
{
    if(finger.rotation<15){
        finger.rotation=finger.rotation+0.3;
    }else{
        finger.rotation=0;
    }
}

- (void)onTutorialButtonClicked:(id)sender
{
    if([GameManager getActive]){
        [SoundManager button_Click];
        [GameManager setStageLevel:0];
        [[CCDirector sharedDirector] replaceScene:
                        [TutorialLevel scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    }
}

- (void)onSelectStageClicked:(id)sender
{
    if([GameManager getActive]){
        // start spinning scene with transition
        [SoundManager button_Click];
        [[CCDirector sharedDirector] replaceScene:
                        [SelectStage scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    }
}

-(void)onGameCenterClicked:(id)sender
{
    if([GameManager getActive]){
        [SoundManager button_Click];
        lbv=[[LeaderboardView alloc]init];
        [lbv showLeaderboard];
    }
}

-(void)onInAppPurchaseClicked:(id)sender
{
    if([GameManager getActive]){
        [SoundManager button_Click];
        //アプリ内購入の設定チェック
        if (![SKPaymentQueue canMakePayments]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",NULL)
                                                            message:NSLocalizedString(@"InAppBillingIslimited",NULL)
                                                            delegate:nil
                                                            cancelButtonTitle:nil
                                                            otherButtonTitles:NSLocalizedString(@"OK",NULL), nil];
            [alert show];
            return;
            
        }else{
            //ショップ画面へ
            [[CCDirector sharedDirector] replaceScene:[ShopView scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];

        }
    }
}

-(void)onTwitterClicked:(id)sender
{
    [SoundManager button_Click];
    NSURL* url = [NSURL URLWithString:@"https://twitter.com/VirginTechLLC"];
    [[UIApplication sharedApplication]openURL:url];
}

-(void)onFacebookClicked:(id)sender
{
    [SoundManager button_Click];
    NSURL* url = [NSURL URLWithString:@"https://www.facebook.com/pages/VirginTech-LLC/516907375075432"];
    [[UIApplication sharedApplication]openURL:url];
}

-(void)onPreferencesButtonClicked:(id)sender
{
    if([GameManager getActive]){
        [SoundManager button_Click];
        [GameManager setActive:false];
        PreferencesLayer* prefence=[[PreferencesLayer alloc]init];
        [self addChild:prefence];
        
        [gfAd hiddenGfIconAd];
    }
}

-(void)onItemSetupButtonClicked:(id)sender
{
    if([GameManager getActive]){
        [SoundManager button_Click];
        [GameManager setActive:false];
        ItemSetupLayer* itemSetup=[[ItemSetupLayer alloc]init];
        [self addChild:itemSetup];
        
        [gfAd hiddenGfIconAd];
    }
}

-(void)onCreditButtonClicked:(id)sender
{
    if([GameManager getActive]){
        [SoundManager button_Click];
        [GameManager setActive:false];
        [[CCDirector sharedDirector] replaceScene:[CreditLayer scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    }
}

@end
