//
//  PlayerSelection.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/30.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "PlayerSelection.h"
#import "GameManager.h"
#import "ObjectManager.h"
#import "StageLevel_01.h"

@implementation PlayerSelection

@synthesize createPlayerPos;

CGSize winSize;
CCSprite* bg;
CCSprite* arrow;
int afterCoin;

CCLabelTTF* label01;
CCLabelTTF* label02;
CCLabelTTF* label03;
CCLabelTTF* label04;
CCLabelTTF* label05;

+ (PlayerSelection *)scene{
    
    return [[self alloc] init];
}

- (id)init{
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"interface_default.plist"];
    bg=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"playerselect.png"]];

    CCButton* animal01=[CCButton buttonWithTitle:@""
                    spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal01.png"]];
    CCButton* animal02=[CCButton buttonWithTitle:@""
                    spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal02.png"]];
    CCButton* animal03=[CCButton buttonWithTitle:@""
                    spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal03.png"]];
    CCButton* animal04=[CCButton buttonWithTitle:@""
                    spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal04.png"]];
    CCButton* animal05=[CCButton buttonWithTitle:@""
                    spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal05.png"]];

    [animal01 setTarget:self selector:@selector(onAnimal01_Clicked:)];
    [animal02 setTarget:self selector:@selector(onAnimal02_Clicked:)];
    [animal03 setTarget:self selector:@selector(onAnimal03_Clicked:)];
    [animal04 setTarget:self selector:@selector(onAnimal04_Clicked:)];
    [animal05 setTarget:self selector:@selector(onAnimal05_Clicked:)];
    
    animal01.position=CGPointMake(animal01.contentSize.width/2, animal01.contentSize.height/2+10);
    animal02.position=CGPointMake(animal02.contentSize.width+60, animal02.contentSize.height/2+10);
    animal03.position=CGPointMake(animal03.contentSize.width*2+60, animal03.contentSize.height/2+10);
    animal04.position=CGPointMake(animal04.contentSize.width*3+60, animal04.contentSize.height/2+10);
    animal05.position=CGPointMake(animal05.contentSize.width*4+60, animal05.contentSize.height/2+10);

    [bg addChild:animal01];
    [bg addChild:animal02];
    [bg addChild:animal03];
    [bg addChild:animal04];
    [bg addChild:animal05];
    
    //レベルラベル
    label01=[CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:30.0f];
    label01.color = [CCColor blueColor];
    label01.position=CGPointMake(animal01.contentSize.width/2,animal01.contentSize.height/2-40);
    [animal01 addChild:label01];
    
    label02=[CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:30.0f];
    label02.color = [CCColor blueColor];
    label02.position=CGPointMake(animal01.contentSize.width/2,animal01.contentSize.height/2-40);
    [animal02 addChild:label02];

    label03=[CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:30.0f];
    label03.color = [CCColor blueColor];
    label03.position=CGPointMake(animal01.contentSize.width/2,animal01.contentSize.height/2-40);
    [animal03 addChild:label03];

    label04=[CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:30.0f];
    label04.color = [CCColor blueColor];
    label04.position=CGPointMake(animal01.contentSize.width/2,animal01.contentSize.height/2-40);
    [animal04 addChild:label04];

    label05=[CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:30.0f];
    label05.color = [CCColor blueColor];
    label05.position=CGPointMake(animal01.contentSize.width/2,animal01.contentSize.height/2-40);
    [animal05 addChild:label05];

    self = [super initWithContentNode:bg];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    self.userInteractionEnabled = YES;
    self.verticalScrollEnabled=NO;
    
    //矢印初期化
    arrow=[CCSprite spriteWithImageNamed:@"arrow.png"];
    [self addChild:arrow];
    
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
-(void)setArrowVisible:(float)offsetY{
    
    arrow.rotation=180;
    arrow.position=CGPointMake(createPlayerPos.x, createPlayerPos.y - offsetY - arrow.contentSize.height/2);
    arrow.visible=true;
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

//-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
//
//}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
    [self removeFromParentAndCleanup:YES];
}

-(void)onAnimal01_Clicked:(id)sender
{
    afterCoin = [GameManager load_Currency_Coin] - 1;
    if(afterCoin >= 0){
        [StageLevel_01 createPlayer:createPlayerPos playerNum:1];
        [self removeFromParentAndCleanup:YES];
    }
}
-(void)onAnimal02_Clicked:(id)sender
{
    afterCoin = [GameManager load_Currency_Coin] - 2;
    if(afterCoin >= 0){
        [StageLevel_01 createPlayer:createPlayerPos playerNum:2];
        [self removeFromParentAndCleanup:YES];
    }
}
-(void)onAnimal03_Clicked:(id)sender
{
    afterCoin = [GameManager load_Currency_Coin] - 3;
    if(afterCoin >= 0){
        [StageLevel_01 createPlayer:createPlayerPos playerNum:3];
        [self removeFromParentAndCleanup:YES];
    }
}
-(void)onAnimal04_Clicked:(id)sender
{
    afterCoin = [GameManager load_Currency_Coin] - 4;
    if(afterCoin >= 0){
        [StageLevel_01 createPlayer:createPlayerPos playerNum:4];
        [self removeFromParentAndCleanup:YES];
    }
}
-(void)onAnimal05_Clicked:(id)sender
{
    afterCoin = [GameManager load_Currency_Coin] - 5;
    if(afterCoin >= 0){
        [StageLevel_01 createPlayer:createPlayerPos playerNum:5];
        [self removeFromParentAndCleanup:YES];
    }
}

@end
