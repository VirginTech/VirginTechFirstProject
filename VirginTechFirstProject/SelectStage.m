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
    
    //Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    //Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor blackColor]];
    [self addChild:background];

    //背景画像セット
    UIImage *image = [UIImage imageNamed:@"stageSelect2.png"];
    UIGraphicsBeginImageContext(CGSizeMake(winSize.width+50,700));
    [image drawInRect:CGRectMake(0, 0, winSize.width+50,700)];
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
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"interface_default.plist"];
    CGPoint btnPos=CGPointMake(70, bgSpLayer.contentSize.height-50);

    for(int i=0;i<50;i++){
        
        int stageNum=i+1;
        CCButton* levelBtn=[CCButton buttonWithTitle:
                            [NSString stringWithFormat:@"%02d",stageNum] fontName:@"Chalkduster" fontSize:25];
        levelBtn.color=[CCColor blackColor];
        if(i%5 !=0){
            btnPos=CGPointMake(btnPos.x+50, btnPos.y+10);
        }else{
            btnPos=CGPointMake(70, btnPos.y-90);
        }
        levelBtn.position = CGPointMake(btnPos.x, btnPos.y);
        levelBtn.name=[NSString stringWithFormat:@"%d",stageNum];
        [levelBtn setTarget:self selector:@selector(onStageLevel:)];
        [bgSpLayer addChild:levelBtn];
        
        //星ラベル
        if([GameManager load_StageClear_State:stageNum]>0){
            CCSprite* star;
            star=[CCSprite spriteWithSpriteFrame:
                            [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:
                            [NSString stringWithFormat:@"star%d.png",[GameManager load_StageClear_State:stageNum]]]];
            star.position=CGPointMake(levelBtn.contentSize.width/2, levelBtn.contentSize.height+5);
            star.scale=0.3;
            [levelBtn addChild:star];
        }
        //錠前
        if(i>[GameManager load_Aggregate_Stage]){
            //CCSprite* lock=[CCSprite spriteWithSpriteFrame:
            //            [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"lock.png"]];
            //lock.scale=0.7;
            //lock.position=CGPointMake(levelBtn.contentSize.width/2, levelBtn.contentSize.height/2);
            //[levelBtn addChild:lock z:1];
            levelBtn.enabled=false;
        }
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

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

@end
