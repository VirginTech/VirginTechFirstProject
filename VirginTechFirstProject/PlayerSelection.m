//
//  PlayerSelection.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/30.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "PlayerSelection.h"
#import "GameManager.h"
#import "StageLevel_00.h"
#import "StageLevel_01.h"

@implementation PlayerSelection

@synthesize createPlayerPos;

CGSize winSize;
CCSprite* bg;
CCSprite* arrow;

+ (PlayerSelection *)scene{
    
    return [[self alloc] init];
}

- (id)init{
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"interface_default.plist"];
    bg=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"playerselect.png"]];
    
    CCButton* animal01=[CCButton buttonWithTitle:@"Animal01" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal01.png"]];
    CCButton* animal02=[CCButton buttonWithTitle:@"Animal02" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal02.png"]];
    CCButton* animal03=[CCButton buttonWithTitle:@"Animal03" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal03.png"]];
    CCButton* animal04=[CCButton buttonWithTitle:@"Animal04" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal04.png"]];
    CCButton* animal05=[CCButton buttonWithTitle:@"Animal05" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal05.png"]];

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
    [StageLevel_01 createPlayer:createPlayerPos playerNum:1];
    [self removeFromParentAndCleanup:YES];
}
-(void)onAnimal02_Clicked:(id)sender
{
    [StageLevel_01 createPlayer:createPlayerPos playerNum:2];
    [self removeFromParentAndCleanup:YES];
}
-(void)onAnimal03_Clicked:(id)sender
{
    [StageLevel_01 createPlayer:createPlayerPos playerNum:3];
    [self removeFromParentAndCleanup:YES];
}
-(void)onAnimal04_Clicked:(id)sender
{
    [StageLevel_01 createPlayer:createPlayerPos playerNum:4];
    [self removeFromParentAndCleanup:YES];
}
-(void)onAnimal05_Clicked:(id)sender
{
    [StageLevel_01 createPlayer:createPlayerPos playerNum:5];
    [self removeFromParentAndCleanup:YES];
}

@end
