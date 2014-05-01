//
//  Level_00.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/26.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "StageLevel_00.h"
#import "TitleScene.h"
#import "RouteDispLayer.h"
#import "BgHigherLayer.h"
#import "BgLowerLayer.h"
#import "BasicMath.h"
#import "InformationLayer.h"
#import "PlayerSelection.h"

@implementation StageLevel_00

CGSize winSize;
NSMutableArray* posArray;
CGPoint oldPos;
RouteDispLayer* routeDisp;
NSMutableArray* animalArray;

bool routeDispFlg;
AnimalPlayer* hitPlayer;

PlayerSelection* playSelect;
CGPoint createPlayerPos;
bool createPlayerFlg;
int selectPlayerNum;//種類番号
CCSprite* arrow;

+ (StageLevel_00 *)scene
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
    createPlayerFlg=false;
    animalArray=[[NSMutableArray alloc]init];
    
    //各種画像初期化
    arrow=[CCSprite spriteWithImageNamed:@"arrow.png"];
    [self addChild:arrow z:5];
    arrow.visible=false;
    
    //地面レイヤー
    BgLowerLayer* bgLayer1 = [[BgLowerLayer alloc]init];
    [self addChild:bgLayer1 z:0];

    //インフォメーションレイヤー
    InformationLayer* infoLayer=[[InformationLayer alloc]init];
    [self addChild:infoLayer z:1];
    
    //経路表示レイヤー z:2、プレイヤー z:3
    routeDisp=[[RouteDispLayer alloc]init];
    [self addChild:routeDisp z:2];
    routeDisp.visible=false;

    //背景レイヤー
    BgHigherLayer* bgLayer2 = [[BgHigherLayer alloc]init];
    [self addChild:bgLayer2 z:4];

    //プレイヤー選択レイヤー z:5
    playSelect=[[PlayerSelection alloc]init];
    [self addChild:playSelect z:5];
    playSelect.visible=false;
    
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
    
    //各種判定スケジュール開始
    [self schedule:@selector(judgement:)interval:0.1];
}

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

+(void)setCreatePlayerFlg:(bool)flg{
    createPlayerFlg=flg;
}
+(bool)getCreatePlayerFlg{
    return createPlayerFlg;
}

+(void)setSelectPlayerNum:(int)num{
    selectPlayerNum=num;
}
+(int)getSelectPlayerNum{
    return selectPlayerNum;
}

-(void)judgement:(CCTime)dt{
    
    //表示
    if(!playSelect.visible){
        arrow.visible=false;
    }
    
    //プレイヤー対プレイヤー衝突判定
    for(AnimalPlayer* player1 in animalArray){
        for(AnimalPlayer* player2 in animalArray){
            if([BasicMath RadiusIntersectsRadius:player1.position pointB:player2.position
                                                                            radius1:20 radius2:20]){
                if(player1!=player2){
                    player1.stopFlg=true;
                    player2.stopFlg=true;
                }
            }
        }
    }
    
    //プレイヤー生成
    if(createPlayerFlg){
        player=[AnimalPlayer createPlayer:createPlayerPos player:selectPlayerNum];
        [animalArray addObject:player];
        [self addChild:player z:3];
        createPlayerFlg=false;
    }
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
    
    CGPoint touchLocation = [touch locationInNode:self];
    
    if([StageLevel_00 isAnimal:touchLocation type:0]){//経路作成
        
        posArray=[[NSMutableArray alloc]init];
        routeDisp.posArray=[[NSMutableArray alloc]init];

        NSValue *value=[NSValue valueWithCGPoint:hitPlayer.position];
        [posArray addObject:value];
        [routeDisp.posArray addObject:value];
        
        //[self addChild:routeDisp z:2];//経路を表示
        routeDisp.visible=true;
        routeDispFlg=true;
        
        hitPlayer.stopFlg=false;
        
    }else if(![StageLevel_00 isAnimal:touchLocation type:1]){//プレイヤー追加
        //陣地内だったら
        if(winSize.height/4 > touchLocation.y){
            //プレイヤー選択レイヤー表示
            playSelect.visible=true;
            createPlayerPos=touchLocation;
            arrow.position=CGPointMake(createPlayerPos.x, createPlayerPos.y+30);
            arrow.visible=true;
        }
    }
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
    CGPoint touchLocation = [touch locationInNode:self];
    if(routeDispFlg){
        if(![BasicMath RadiusContainsPoint:hitPlayer.position pointB:touchLocation radius:30]){
            NSValue *value=[NSValue valueWithCGPoint:touchLocation];
            [posArray addObject:value];
            [routeDisp.posArray addObject:value];
        }
    }
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
    //プレイヤー移動
    if(routeDispFlg){
        //[self removeChild:routeDisp];//経路を非表示
        routeDisp.visible=false;
        if(posArray.count>1){//座標が2点以上なら
            [hitPlayer moveTank:posArray];
        }
        routeDispFlg=false;
    }
}

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];

    //[[CCDirector sharedDirector] replaceScene:[TitleScene scene]withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

@end
