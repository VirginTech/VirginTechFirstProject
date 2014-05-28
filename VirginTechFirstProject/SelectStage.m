//
//  SelectStage.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/02.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "SelectStage.h"
#import "StageLevel_00.h"
#import "StageLevel_01.h"
#import "GameManager.h"
#import "TitleScene.h"
#import "IAdLayer.h"

@implementation SelectStage

CGSize winSize;
CCScrollView* scrollView;
CCSprite* bgSpLayer;

+ (SelectStage *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    winSize=[[CCDirector sharedDirector]viewSize];
    
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Create a colored background (Dark Grey)
    //CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    //[self addChild:background];

    //背景画像セット
    UIImage *image = [UIImage imageNamed:@"bgLayer.png"];
    UIGraphicsBeginImageContext(CGSizeMake(winSize.width,1400));
    [image drawInRect:CGRectMake(0, 0, winSize.width,1400)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //スクロールビュー配置
    bgSpLayer=[CCSprite spriteWithCGImage:image.CGImage key:nil];
    scrollView=[[CCScrollView alloc]initWithContentNode:bgSpLayer];
    scrollView.horizontalScrollEnabled=NO;
    //bgSpLayer.position=CGPointMake(0, -bgSpLayer.contentSize.height);
    [self addChild:scrollView z:0];
    
    //ゲーム状態セット
    [GameManager setPlaying:false];
    [GameManager setPauseing:false];
    [GameManager setPauseStateChange:false];
    
    //iAdバナー表示
    IAdLayer* iAd=[[IAdLayer alloc]init:1];
    [self addChild:iAd];
    
    //タイトル
    CCButton *backButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    /*/ステージ１
    CCButton *button1 = [CCButton buttonWithTitle:@"[ステージレベル１]" fontName:@"Verdana-Bold" fontSize:18.0f];
    button1.positionType = CCPositionTypeNormalized;
    button1.position = ccp(0.5f, 0.70f);
    [button1 setTarget:self selector:@selector(onStageLevel01:)];
    [self addChild:button1];
    
    //ステージ２
    CCButton *button2 = [CCButton buttonWithTitle:@"[ステージレベル２]" fontName:@"Verdana-Bold" fontSize:18.0f];
    button2.positionType = CCPositionTypeNormalized;
    button2.position = ccp(0.5f, 0.65f);
    [button2 setTarget:self selector:@selector(onStageLevel02:)];
    [self addChild:button2];*/
    
    float y = bgSpLayer.contentSize.height - 50;
    for(int i=1;i<=50;i++){
        CCButton* stageBtn=[CCButton buttonWithTitle:
                          [NSString stringWithFormat:@"[ステージレヴェル %02d]",i] fontName:@"Verdana-Bold" fontSize:15.0f];
        stageBtn.position = ccp(winSize.width/2 - 50, y);
        stageBtn.name=[NSString stringWithFormat:@"%d",i];
        y -= 25;
        [stageBtn setTarget:self selector:@selector(onStageLevel:)];
        [bgSpLayer addChild:stageBtn];
    }
    
    
    // done
	return self;
}

- (void)onStageLevel:(id)sender
{
    // start spinning scene with transition
    CCButton* button =(CCButton*)sender;
    [GameManager setStageLevel:[[button name]intValue]];
    [[CCDirector sharedDirector] replaceScene:[StageLevel_01 scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}
/*
- (void)onStageLevel01:(id)sender
{
    // start spinning scene with transition
    [GameManager setStageLevel:1];
    [[CCDirector sharedDirector] replaceScene:[StageLevel_01 scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

- (void)onStageLevel02:(id)sender
{
    // start spinning scene with transition
    [GameManager setStageLevel:2];
    [[CCDirector sharedDirector] replaceScene:[StageLevel_01 scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}
*/
- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    //[[CCDirector sharedDirector] replaceScene:[TitleScene scene]withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

@end
