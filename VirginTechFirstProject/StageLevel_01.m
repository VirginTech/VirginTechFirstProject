//
//  StageLevel_01.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/02.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "StageLevel_01.h"
#import "NaviLayer.h"
#import "CCScrollView.h"

@implementation StageLevel_01

CGSize winSize;
CCScrollView* sView;
CCSprite* bg;


+ (StageLevel_01 *)scene
{
    return [[self alloc] init];
}

- (id)init{
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    self.userInteractionEnabled = YES;
    
    //スクロールビュー配置
    bg=[CCSprite spriteWithImageNamed:@"bgLayer.png"];
    sView=[[CCScrollView alloc]initWithContentNode:bg];
    sView.horizontalScrollEnabled=NO;
    bg.position=CGPointMake(0, -bg.contentSize.height);
    sView.bounces = NO;
    [self addChild:sView];
    
    //ボタン配置レイヤー
    NaviLayer* navi=[[NaviLayer alloc]init];
    [self addChild:navi z:5];
    
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

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    float offsetY;
    CGPoint touchLocation = [touch locationInNode:self];

    touchLocation.x += sView.scrollPosition.x;
    offsetY = bg.contentSize.height - winSize.height - sView.scrollPosition.y;
    touchLocation.y += offsetY;
    
    //NSLog(@"X=%f : Y=%f",touchLocation.x,touchLocation.y);
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
    //CGPoint touchLocation = [touch locationInNode:self];
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
}

@end
