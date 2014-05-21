//
//  ItemSetupLayer.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/21.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "ItemSetupLayer.h"
#import "CCScrollView.h"
#import "GameManager.h"
#import "ObjectManager.h"
#import "InformationLayer.h"

@implementation ItemSetupLayer

int afterDia;

CCLabelTTF* label01;
CCLabelTTF* label02;
CCLabelTTF* label03;
CCLabelTTF* label04;
CCLabelTTF* label05;

+ (ItemSetupLayer *)scene
{
    return [[self alloc] init];
}

- (id)init
{    
    self = [super init];
    if (!self) return(nil);
    
    //self.userInteractionEnabled = YES;

    //BGカラー
    CCNodeColor* background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"interface_default.plist"];
    
    CCSprite* bgSprite=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"playerselect.png"]];
    
    CCSprite* animal01=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal01.png"]];;
    CCSprite* animal02=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal02.png"]];;
    CCSprite* animal03=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal03.png"]];;
    CCSprite* animal04=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal04.png"]];;
    CCSprite* animal05=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal05.png"]];;
    
    animal01.position=CGPointMake(animal01.contentSize.width/2, animal01.contentSize.height/2+10);
    animal02.position=CGPointMake(animal02.contentSize.width+60, animal02.contentSize.height/2+10);
    animal03.position=CGPointMake(animal03.contentSize.width*2+60, animal03.contentSize.height/2+10);
    animal04.position=CGPointMake(animal04.contentSize.width*3+60, animal04.contentSize.height/2+10);
    animal05.position=CGPointMake(animal05.contentSize.width*4+60, animal05.contentSize.height/2+10);
    
    //パワーアップボタン
    CCButton* setBtn01=[CCButton buttonWithTitle:@"LevelUp!" fontName:@"Verdana-Bold" fontSize:15.0f];
    setBtn01.position=ccp(animal01.contentSize.width/2, animal01.contentSize.height/2-40);
    [setBtn01 setTarget:self selector:@selector(onSetBtn01_Clicked:)];
    setBtn01.color=[CCColor blueColor];
    [animal01 addChild:setBtn01];
    
    CCButton* setBtn02=[CCButton buttonWithTitle:@"LevelUp!" fontName:@"Verdana-Bold" fontSize:15.0f];
    setBtn02.position=ccp(animal02.contentSize.width/2, animal02.contentSize.height/2-40);
    [setBtn02 setTarget:self selector:@selector(onSetBtn02_Clicked:)];
    setBtn02.color=[CCColor blueColor];
    [animal02 addChild:setBtn02];
    
    CCButton* setBtn03=[CCButton buttonWithTitle:@"LevelUp!" fontName:@"Verdana-Bold" fontSize:15.0f];
    setBtn03.position=ccp(animal03.contentSize.width/2, animal03.contentSize.height/2-40);
    [setBtn03 setTarget:self selector:@selector(onSetBtn03_Clicked:)];
    setBtn03.color=[CCColor blueColor];
    [animal03 addChild:setBtn03];
    
    CCButton* setBtn04=[CCButton buttonWithTitle:@"LevelUp!" fontName:@"Verdana-Bold" fontSize:15.0f];
    setBtn04.position=ccp(animal04.contentSize.width/2, animal04.contentSize.height/2-40);
    [setBtn04 setTarget:self selector:@selector(onSetBtn04_Clicked:)];
    setBtn04.color=[CCColor blueColor];
    [animal04 addChild:setBtn04];
    
    CCButton* setBtn05=[CCButton buttonWithTitle:@"LevelUp!" fontName:@"Verdana-Bold" fontSize:15.0f];
    setBtn05.position=ccp(animal05.contentSize.width/2, animal05.contentSize.height/2-40);
    [setBtn05 setTarget:self selector:@selector(onSetBtn05_Clicked:)];
    setBtn05.color=[CCColor blueColor];
    [animal05 addChild:setBtn05];

    //レベルラベル
    label01=[CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:30.0f];
    label01.color = [CCColor blueColor];
    label01.position=CGPointMake(animal01.contentSize.width/2,animal01.contentSize.height/2);
    [animal01 addChild:label01];
    
    label02=[CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:30.0f];
    label02.color = [CCColor blueColor];
    label02.position=CGPointMake(animal02.contentSize.width/2,animal02.contentSize.height/2);
    [animal02 addChild:label02];
    
    label03=[CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:30.0f];
    label03.color = [CCColor blueColor];
    label03.position=CGPointMake(animal03.contentSize.width/2,animal03.contentSize.height/2);
    [animal03 addChild:label03];
    
    label04=[CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:30.0f];
    label04.color = [CCColor blueColor];
    label04.position=CGPointMake(animal04.contentSize.width/2,animal04.contentSize.height/2);
    [animal04 addChild:label04];
    
    label05=[CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:30.0f];
    label05.color = [CCColor blueColor];
    label05.position=CGPointMake(animal05.contentSize.width/2,animal05.contentSize.height/2);
    [animal05 addChild:label05];
    
    [bgSprite addChild:animal01];
    [bgSprite addChild:animal02];
    [bgSprite addChild:animal03];
    [bgSprite addChild:animal04];
    [bgSprite addChild:animal05];

    //レベルセット
    [self setButtonLevel];
    
    //スクロールビュー
    CCScrollView* iTemScroll=[[CCScrollView alloc]initWithContentNode:bgSprite];
    iTemScroll.verticalScrollEnabled=NO;
    [self addChild:iTemScroll];
    
    //閉じるボタン
    CCButton *closeButton = [CCButton buttonWithTitle:@"[閉じる]" fontName:@"Verdana-Bold" fontSize:18.0f];
    closeButton.positionType = CCPositionTypeNormalized;
    closeButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [closeButton setTarget:self selector:@selector(onCloseClicked:)];
    [self addChild:closeButton];
    
    return self;
}

-(void)setButtonLevel
{
    label01.string=[NSString stringWithFormat:@"Lv.%d",[ObjectManager load_Object_Ability_Level:@"beartank1"]];
    label02.string=[NSString stringWithFormat:@"Lv.%d",[ObjectManager load_Object_Ability_Level:@"beartank2"]];
    label03.string=[NSString stringWithFormat:@"Lv.%d",[ObjectManager load_Object_Ability_Level:@"beartank3"]];
    label04.string=[NSString stringWithFormat:@"Lv.%d",[ObjectManager load_Object_Ability_Level:@"beartank4"]];
    label05.string=[NSString stringWithFormat:@"Lv.%d",[ObjectManager load_Object_Ability_Level:@"beartank5"]];
}

-(void)onSetBtn01_Clicked:(id)sender
{
    afterDia = [GameManager load_Currency_Dia] - 1;
    if(afterDia >= 0){
        [ObjectManager levelUp_Object_Ability:@"beartank1"];
        [self setButtonLevel];
        [GameManager in_Out_Dia:1 addFlg:false];//コイン1減
        [InformationLayer updateCurrencyLabel];
    }
}
-(void)onSetBtn02_Clicked:(id)sender
{
    afterDia = [GameManager load_Currency_Dia] - 1;
    if(afterDia >= 0){
        [ObjectManager levelUp_Object_Ability:@"beartank2"];
        [self setButtonLevel];
        [GameManager in_Out_Dia:1 addFlg:false];//コイン1減
        [InformationLayer updateCurrencyLabel];
    }
}
-(void)onSetBtn03_Clicked:(id)sender
{
    afterDia = [GameManager load_Currency_Dia] - 1;
    if(afterDia >= 0){
        [ObjectManager levelUp_Object_Ability:@"beartank3"];
        [self setButtonLevel];
        [GameManager in_Out_Dia:1 addFlg:false];//コイン1減
        [InformationLayer updateCurrencyLabel];
    }
}
-(void)onSetBtn04_Clicked:(id)sender
{
    afterDia = [GameManager load_Currency_Dia] - 1;
    if(afterDia >= 0){
        [ObjectManager levelUp_Object_Ability:@"beartank4"];
        [self setButtonLevel];
        [GameManager in_Out_Dia:1 addFlg:false];//コイン1減
        [InformationLayer updateCurrencyLabel];
    }
}
-(void)onSetBtn05_Clicked:(id)sender
{
    afterDia = [GameManager load_Currency_Dia] - 1;
    if(afterDia >= 0){
        [ObjectManager levelUp_Object_Ability:@"beartank5"];
        [self setButtonLevel];
        [GameManager in_Out_Dia:1 addFlg:false];//コイン1減
        [InformationLayer updateCurrencyLabel];
    }
}
-(void)onCloseClicked:(id)sender
{
    [GameManager setActive:true];
    [self removeFromParentAndCleanup:YES];
}

@end
