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

@implementation Level_00

CCSprite *_sprite;
NSMutableArray* posArray;
CGPoint oldPos;
RouteDispLayer* routeDisp;

+ (Level_00 *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    //経路表示レイヤー
    routeDisp=[[RouteDispLayer alloc]init];
    //[self addChild:routeDisp];
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    //プレイヤー作成
    player=[Player createPlayer];
    [self addChild:player z:1];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    // done
	return self;
}

// -----------------------------------------------------------------------

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

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    posArray=[[NSMutableArray alloc]init];
    routeDisp.posArray=[[NSMutableArray alloc]init];
    
    CGPoint touchLocation = [touch locationInNode:self];
    
    NSValue *value=[NSValue valueWithCGPoint:player.position];
    [posArray addObject:value];
    [routeDisp.posArray addObject:value];
    
    value = [NSValue valueWithCGPoint:touchLocation];
    [posArray addObject:value];
    [routeDisp.posArray addObject:value];
    
    //経路を表示
    [self addChild:routeDisp z:0];
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
    CGPoint touchLocation = [touch locationInNode:self];
    NSValue *value=[NSValue valueWithCGPoint:touchLocation];
    [posArray addObject:value];
    [routeDisp.posArray addObject:value];
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
    if(posArray.count>0){
        [player moveTank:posArray];
    }
    //経路を非表示
    [self removeChild:routeDisp];
}

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

@end
