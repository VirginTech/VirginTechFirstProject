//
//  Level_00.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/26.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "Level_00.h"
#import "TitleScene.h"
#import "RouteDispLayer.h"
#import "CCDrawingPrimitives.h"
#import "BgHigherLayer.h"
#import "BgLowerLayer.h"

@implementation Level_00

CGSize winSize;
NSMutableArray* posArray;
CGPoint oldPos;
RouteDispLayer* routeDisp;
NSMutableArray* animalArray;

bool routeDispFlg;
Player* hitPlayer;

+ (Level_00 *)scene
{
    return [[self alloc] init];
}

- (id)init{
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    //各種データ初期化
    animalArray=[[NSMutableArray alloc]init];
    
    //地面レイヤー
    BgLowerLayer* bgLayer1 = [[BgLowerLayer alloc]init];
    [self addChild:bgLayer1 z:0];
    
    //経路表示レイヤー
    routeDisp=[[RouteDispLayer alloc]init];//z:1
    
    //プレイヤー作成
    //player=[Player createPlayer];
    //[self addChild:player z:2];
    
    //背景レイヤー
    BgHigherLayer* bgLayer2 = [[BgHigherLayer alloc]init];
    [self addChild:bgLayer2 z:3];

    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    // done
	return self;
}

- (void)dealloc
{
    // clean up code goes here
}

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

+(BOOL)isAnimal:(CGPoint)touchLocation{
    
    BOOL flg=false;
    
    for(Player* _player in animalArray){
        if(CGRectContainsPoint(_player.boundingBox, touchLocation)){
            hitPlayer=_player;
            flg=true;
        }
    }
    return flg;
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchLocation = [touch locationInNode:self];
    
    if([Level_00 isAnimal:touchLocation]){
        
        posArray=[[NSMutableArray alloc]init];
        routeDisp.posArray=[[NSMutableArray alloc]init];

        NSValue *value=[NSValue valueWithCGPoint:hitPlayer.position];
        [posArray addObject:value];
        [routeDisp.posArray addObject:value];
        
        value = [NSValue valueWithCGPoint:touchLocation];
        [posArray addObject:value];
        [routeDisp.posArray addObject:value];
        
        //経路を表示
        [self addChild:routeDisp z:1];
        routeDispFlg=true;
        
    }else{
        //プレイヤー作成
        player=[Player createPlayer:touchLocation];
        [animalArray addObject:player];
        [self addChild:player z:2];
        routeDispFlg=false;
    }
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
    if(routeDispFlg){
        CGPoint touchLocation = [touch locationInNode:self];
        NSValue *value=[NSValue valueWithCGPoint:touchLocation];
        [posArray addObject:value];
        [routeDisp.posArray addObject:value];
    }
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
    //プレイヤー移動
    if(routeDispFlg){
        [self removeChild:routeDisp];//経路を非表示
        if(posArray.count>0){
            [hitPlayer moveTank:posArray];
        }
    }
}

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];

    //[[CCDirector sharedDirector] replaceScene:[TitleScene scene]withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

@end
