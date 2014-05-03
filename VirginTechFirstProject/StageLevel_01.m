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
#import "RouteGenerationLayer.h"
#import "BasicMath.h"

@implementation StageLevel_01

CGSize winSize;
CCScrollView* scrollView;
CCSprite* bgSpLayer;
RouteGenerationLayer* routeGeneLyer;

NSMutableArray* animalArray;
AnimalPlayer* hitPlayer;
bool routeGeneFlg;

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
    
    //各種データ初期化
    routeGeneFlg=false;
    animalArray=[[NSMutableArray alloc]init];
    
    //スクロールビュー配置
    bgSpLayer=[CCSprite spriteWithImageNamed:@"bgLayer.png"];
    scrollView=[[CCScrollView alloc]initWithContentNode:bgSpLayer];
    scrollView.horizontalScrollEnabled=NO;
    bgSpLayer.position=CGPointMake(0, -bgSpLayer.contentSize.height);
    [self addChild:scrollView];
    
    //経路作成レイヤー
    routeGeneLyer=[[RouteGenerationLayer alloc]init];
    //[self addChild:routeGeneLyer];
    
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

+(BOOL)isAnimal:(CGPoint)touchLocation type:(int)type{
    
    BOOL flg=false;
    
    for(AnimalPlayer* _player in animalArray){
        if(type==0){//経路作成
            if([BasicMath RadiusContainsPoint:_player.position pointB:touchLocation radius:30]){
                hitPlayer=_player;
                flg=true;
            }
        }else if(type==1){//プレイヤー追加
            if([BasicMath RadiusContainsPoint:_player.position pointB:touchLocation radius:70]){
                hitPlayer=_player;
                flg=true;
            }
        }
    }
    return flg;
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint worldLocation;
    CGPoint touchLocation = [touch locationInNode:self];
    
    float offsetY = bgSpLayer.contentSize.height - winSize.height - scrollView.scrollPosition.y;
    worldLocation.x = touchLocation.x + scrollView.scrollPosition.x;
    worldLocation.y = touchLocation.y + offsetY;
    
    if([StageLevel_01 isAnimal:worldLocation type:0]){//経路作成
        if(!routeGeneFlg){
            scrollView.verticalScrollEnabled=NO;
            [self addChild:routeGeneLyer];
            routeGeneFlg=true;
        }
    }else if(![StageLevel_01 isAnimal:worldLocation type:1]){//プレイヤー追加
        if(worldLocation.y < 200){
            player=[AnimalPlayer createPlayer:worldLocation player:1];
            [animalArray addObject:player];
            [bgSpLayer addChild:player z:3];
        }
    }
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
    CGPoint touchLocation = [touch locationInNode:self];
    NSLog(@"X=%f : Y=%f",touchLocation.x,touchLocation.y);
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
}

@end
