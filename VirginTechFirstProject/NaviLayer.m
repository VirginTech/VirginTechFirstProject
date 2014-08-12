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
#import "SoundManager.h"
#import "InformationLayer.h"
#import <Social/Social.h>
#import "NADInterstitial.h"

@implementation NaviLayer

CGSize winSize;

//CCLabelTTF *label;
CCNodeColor *background;
CCButton *pauseButton;
CCButton *resumeButton;
CCButton *titleButton;
CCButton *stageButton;
CCButton *preferencesButton;
CCButton *itemSetupButton;

CCButton* tweetButton;
CCButton* facebookButton;

CCSprite* victoryImg;
CCSprite* defeatImg;

NSMutableArray* starB_Array;
NSMutableArray* starG_Array;

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

    //画像読込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button_default.plist"];

    //ポーズボタン
    pauseButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"pause.png"]];
    pauseButton.positionType = CCPositionTypeNormalized;
    pauseButton.position = ccp(0.9f, 0.95f); // Top Right of screen
    pauseButton.scale=0.3;
    [pauseButton setTarget:self selector:@selector(onPauseClicked:)];
    [self addChild:pauseButton];

    //リジュームボタン
    resumeButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"resume.png"]];
    resumeButton.positionType = CCPositionTypeNormalized;
    resumeButton.position = ccp(0.9f, 0.95f); // Top Right of screen
    resumeButton.scale=0.3;
    [resumeButton setTarget:self selector:@selector(onPauseClicked:)];
    [self addChild:resumeButton];
    resumeButton.visible=false;
    
    //ホームボタン
    titleButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"homeBtn.png"]];
    titleButton.positionType = CCPositionTypeNormalized;
    titleButton.position = ccp(0.35f, 0.45f); // Top Right of screen
    titleButton.scale=0.35;
    [titleButton setTarget:self selector:@selector(onTitleClicked:)];
    [self addChild:titleButton];
    titleButton.visible=false;
    
    //セレクトステージ
    stageButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"stageListBtn.png"]];
    stageButton.positionType = CCPositionTypeNormalized;
    stageButton.position = ccp(0.5f, 0.45f);
    stageButton.scale=0.35;
    [stageButton setTarget:self selector:@selector(onSelectStageClicked:)];
    [self addChild:stageButton];
    stageButton.visible=false;
    
    //環境設定
    preferencesButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"configBtn2.png"]];
    preferencesButton.positionType = CCPositionTypeNormalized;
    preferencesButton.position = ccp(0.65f, 0.45f);
    preferencesButton.scale=0.35;
    [preferencesButton setTarget:self selector:@selector(onPreferencesButtonClicked:)];
    [self addChild:preferencesButton];
    preferencesButton.visible=false;
    
    //アイテムセットアップ
    itemSetupButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                 [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"itemSetBtn.png"]];
    itemSetupButton.positionType = CCPositionTypeNormalized;
    itemSetupButton.position = ccp(0.5f, 0.35f);
    itemSetupButton.scale=0.7;
    [itemSetupButton setTarget:self selector:@selector(onItemSetupButtonClicked:)];
    [self addChild:itemSetupButton];
    itemSetupButton.visible=false;
    
    /*/ラベル
    label = [CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:36.0f];
    label.color = [CCColor whiteColor];
    //label.outlineWidth=5.0;
    //label.outlineColor=[CCColor redColor];
    label.positionType = CCPositionTypeNormalized;
    label.position = ccp(0.50f, 0.55f); // Top Right of screen
    [self addChild:label z:2];
     */
    
    //星
    CCSprite* starG;
    CCSprite* starB;
    starB_Array=[[NSMutableArray alloc]init];
    starG_Array=[[NSMutableArray alloc]init];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"interface_default.plist"];
    for(int i=0;i<3;i++)
    {
        starG=[CCSprite spriteWithSpriteFrame:
               [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"star_G.png"]];
        starB=[CCSprite spriteWithSpriteFrame:
               [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"star_B.png"]];
        
        starG.positionType = CCPositionTypeNormalized;
        starB.positionType = CCPositionTypeNormalized;
        if(i==0){
            starB.position=ccp(0.20f,0.65f);
            starG.position=ccp(0.20f,0.65f);
        }else if(i==1){
            starB.position=ccp(0.50f,0.75f);
            starG.position=ccp(0.50f,0.75f);
        }else{
            starB.position=ccp(0.80f,0.65f);
            starG.position=ccp(0.80f,0.65f);
        }
        [starB_Array addObject:starB];
        [starG_Array addObject:starG];
        [self addChild:starB z:0];
        [self addChild:starG z:1];
        starB.visible=false;
        starG.visible=false;
    }
    
    //ヴィクトリー画像
    if([GameManager getLocale]==1){//英語
        victoryImg=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"victory_en.png"]];
    }else{
        victoryImg=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"victory_jp.png"]];
    }
    victoryImg.positionType = CCPositionTypeNormalized;
    victoryImg.position=ccp(0.50f, 0.55f);
    victoryImg.visible=false;
    [self addChild:victoryImg z:2];
    
    if([GameManager getLocale]==1){//英語
        defeatImg=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"defeat_en.png"]];
    }else{
        defeatImg=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"defeat_jp.png"]];
    }
    defeatImg.positionType = CCPositionTypeNormalized;
    defeatImg.position=ccp(0.50f, 0.55f);
    defeatImg.visible=false;
    [self addChild:defeatImg z:2];
    
    //ツイートボタン
    tweetButton = [CCButton buttonWithTitle:NSLocalizedString(@"d_Get",NULL) spriteFrame:
                   [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"twitter_p.png"]];
    //tweetButton = [CCButton buttonWithTitle:@"Tweetする"];
    tweetButton.positionType = CCPositionTypeNormalized;
    tweetButton.position = ccp(0.5f, 0.25f); // Top Right of screen
    tweetButton.scale=0.7;
    [tweetButton setTarget:self selector:@selector(onTweetClicked:)];
    [self addChild:tweetButton];
    tweetButton.visible=false;
    
    //Facebookボタン
    facebookButton = [CCButton buttonWithTitle:NSLocalizedString(@"d_Get",NULL) spriteFrame:
                   [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"facebook_p.png"]];
    //facebookButton = [CCButton buttonWithTitle:@"Facebookへ投稿"];
    facebookButton.positionType = CCPositionTypeNormalized;
    facebookButton.position = ccp(0.5f, 0.20f); // Top Right of screen
    facebookButton.scale=0.7;
    [facebookButton setTarget:self selector:@selector(onFacebookPostClicked:)];
    [self addChild:facebookButton];
    facebookButton.visible=false;
    
    return self;
}

+(void)setStageEndingScreen:(bool)clearFlg rate:(int)rate
{
    int i=0;
    for(CCSprite* star_B in starB_Array){
        star_B.visible=true;
    }
    for(CCSprite* star_G in starG_Array){
        if(rate > i){
            star_G.visible=true;
        }
        i++;
    }
    if(clearFlg){
        victoryImg.visible=true;
        tweetButton.visible=true;
        facebookButton.visible=true;
    }else{
        defeatImg.visible=true;
    }
    pauseButton.visible=false;
    resumeButton.visible=false;
    background.visible=true;
    titleButton.visible=true;
    stageButton.visible=true;
    preferencesButton.visible=true;
    itemSetupButton.visible=true;
}

+(void)setPauseScreen
{
    if([GameManager getPauseing]){//ポーズ中
        //pauseButton.title=@"[再　開]";
        pauseButton.visible=false;
        resumeButton.visible=true;
        background.visible=true;
        titleButton.visible=true;
        stageButton.visible=true;
        preferencesButton.visible=true;
        itemSetupButton.visible=true;

        //tweetButton.visible=true;
        //facebookButton.visible=true;

    }else{//再開中
        //pauseButton.title=@"[ポーズ]";
        pauseButton.visible=true;
        resumeButton.visible=false;
        background.visible=false;
        titleButton.visible=false;
        stageButton.visible=false;
        preferencesButton.visible=false;
        itemSetupButton.visible=false;
    }
}

- (void)onPauseClicked:(id)sender
{
    [SoundManager button_Click];
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
    [SoundManager button_Click];
    //[[CCDirector sharedDirector]resume];
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    [[NADInterstitial sharedInstance] showAd];
}
- (void)onSelectStageClicked:(id)sender
{
    [SoundManager button_Click];
    //[[CCDirector sharedDirector]resume];
    [[CCDirector sharedDirector] replaceScene:[SelectStage scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}
- (void)onPreferencesButtonClicked:(id)sender
{
    [SoundManager button_Click];
    PreferencesLayer* prefence=[[PreferencesLayer alloc]init];
    [self addChild:prefence z:3];
}
-(void)onItemSetupButtonClicked:(id)sender
{
    if([GameManager getActive]){
        [SoundManager button_Click];
        //[GameManager setActive:false];
        ItemSetupLayer* itemSetup=[[ItemSetupLayer alloc]init];
        [self addChild:itemSetup z:3];
    }
}
-(void)onTweetClicked:(id)sender
{
    SLComposeViewController *vc = [SLComposeViewController
                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
    [vc setInitialText:[NSString stringWithFormat:
                        @"%@ %ld %@\n",NSLocalizedString(@"PostMessage",NULL),
                        [GameManager load_HighScore],
                        NSLocalizedString(@"PostEnd",NULL)]];
    [vc addURL:[NSURL URLWithString:NSLocalizedString(@"URL",NULL)]];
    [vc setCompletionHandler:^(SLComposeViewControllerResult result)
    {
        switch (result) {
        case SLComposeViewControllerResultDone:
            //ダイヤを付与
            [GameManager in_Out_Dia:1 addFlg:true];
            //ダイア表示更新
            [InformationLayer update_CurrencyLabel];
            break;
        case SLComposeViewControllerResultCancelled:
            break;
        }
    }];
    [[CCDirector sharedDirector]presentViewController:vc animated:YES completion:nil];
}
-(void)onFacebookPostClicked:(id)sender
{
    SLComposeViewController *vc = [SLComposeViewController
                                   composeViewControllerForServiceType:SLServiceTypeFacebook];
    [vc setInitialText:[NSString stringWithFormat:
                        @"%@ %ld %@\n",NSLocalizedString(@"PostMessage",NULL),
                        [GameManager load_HighScore],
                        NSLocalizedString(@"PostEnd",NULL)]];
    [vc addURL:[NSURL URLWithString:NSLocalizedString(@"URL",NULL)]];
    [vc setCompletionHandler:^(SLComposeViewControllerResult result)
    {
        switch (result) {
        case SLComposeViewControllerResultDone:
            //ダイヤを付与
            [GameManager in_Out_Dia:1 addFlg:true];
            //ダイア表示更新
            [InformationLayer update_CurrencyLabel];
            break;
        case SLComposeViewControllerResultCancelled:
            break;
        }
    }];
    [[CCDirector sharedDirector]presentViewController:vc animated:YES completion:nil];
}

@end
