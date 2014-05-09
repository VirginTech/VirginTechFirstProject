//
//  StageLevel_01.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/02.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "StageLevel_01.h"
#import "GameManager.h"
#import "AnimalPlayer.h"
#import "AnimalEnemy.h"
#import "NaviLayer.h"
#import "CCScrollView.h"
#import "RouteGenerationLayer.h"
#import "BasicMath.h"
#import "PlayerSelection.h"

@implementation StageLevel_01


int maxHeight;
CGSize winSize;
CCScrollView* scrollView;
CCSprite* bgSpLayer;

NSMutableArray* animalArray;
NSMutableArray* enemyArray;
RouteGenerationLayer* routeGeneLyer;
AnimalPlayer* hitPlayer;

PlayerSelection* playSelect;
AnimalPlayer* player;
AnimalEnemy* enemy;

NSMutableArray* searchTarget;

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
    animalArray=[[NSMutableArray alloc]init];
    enemyArray =[[NSMutableArray alloc]init];
    
    //ステージレベル取得
    int stageLevel=[GameManager getStageLevel];
    
    //レベルに応じた画面の大きさ
    if(stageLevel==1){//Level1
        maxHeight=600;
    }else{
        maxHeight=600;
    }
    UIImage *image = [UIImage imageNamed:@"bgLayer.png"];
    UIGraphicsBeginImageContext(CGSizeMake(winSize.width, maxHeight));
    [image drawInRect:CGRectMake(0, 0, winSize.width, maxHeight)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //スクロールビュー配置 z:0
    bgSpLayer=[CCSprite spriteWithCGImage:image.CGImage key:nil];
    scrollView=[[CCScrollView alloc]initWithContentNode:bgSpLayer];
    scrollView.horizontalScrollEnabled=NO;
    bgSpLayer.position=CGPointMake(0, -bgSpLayer.contentSize.height);
    [self addChild:scrollView z:0];
    
    //陣地ライン
    CCSprite* line=[CCSprite spriteWithImageNamed:@"position_line.png"];
    line.position=CGPointMake(0, 200);
    [bgSpLayer addChild:line];
    
    //経路作成レイヤー z:1
    routeGeneLyer=[[RouteGenerationLayer alloc]init];
    //[self addChild:routeGeneLyer];
    
    //ボタン配置レイヤー z2
    NaviLayer* navi=[[NaviLayer alloc]init];
    [self addChild:navi z:2];
    
    //プレイヤー選択レイヤー z:3
    playSelect=[[PlayerSelection alloc]init];
    [self addChild:playSelect z:3];
    playSelect.visible=false;
    
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
    //審判スケジュール開始
    [self schedule:@selector(judgement_Schedule:)interval:0.1];
    //敵アニマル戦車登場
    [StageLevel_01 createEnemy];
    //[StageLevel_01 createEnemy];
    //[StageLevel_01 createEnemy];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
}

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

-(void)judgement_Schedule:(CCTime)dt{
    
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
    //プレイヤー　対　敵
    for(AnimalPlayer* player in animalArray){
        for(AnimalEnemy* enemy in enemyArray){
            if([BasicMath RadiusIntersectsRadius:enemy.position pointB:player.position
                                         radius1:20 radius2:20]){
                enemy.stopFlg=true;
                player.stopFlg=true;
            }
        }
    }
    //敵アニマル戦車の捕捉用レーダー
    for(AnimalEnemy* enemy in enemyArray){
        searchTarget=[[NSMutableArray alloc]init];
        for(AnimalPlayer* player in animalArray){
            if([BasicMath RadiusIntersectsRadius:enemy.position pointB:player.position
                                         radius1:120 radius2:20]){
                [searchTarget addObject:player];
            }
        }
        [enemy setTarget:searchTarget];
    }
    //我アニマル戦車の捕捉用レーダー
    for(AnimalPlayer* player in animalArray){
        searchTarget=[[NSMutableArray alloc]init];
        for(AnimalEnemy* enemy in enemyArray){
            if([BasicMath RadiusIntersectsRadius:player.position pointB:enemy.position
                                         radius1:120 radius2:20]){
                [searchTarget addObject:enemy];
            }
        }
        [player setTarget:searchTarget];
    }
}

//============================
// タッチしたアニマル戦車を特定する
//============================
+(BOOL)isAnimal:(CGPoint)touchLocation type:(int)type{
    
    BOOL flg=false;
    
    for(AnimalPlayer* _player in animalArray){
        if(type==0){//経路作成
            if([BasicMath RadiusContainsPoint:_player.position pointB:touchLocation radius:30]){
                hitPlayer=_player;
                routeGeneLyer.player=_player;
                flg=true;
            }
        }else if(type==1){//プレイヤー追加
            if([BasicMath RadiusContainsPoint:_player.position pointB:touchLocation radius:70]){
                hitPlayer=_player;
                routeGeneLyer.player=_player;
                flg=true;
            }
        }
    }
    return flg;
}

//===================================
// タッチしたアニマル戦車が衝突継続中かどうか
//===================================
+(BOOL)isCollision:(AnimalPlayer*)hitPlayer{
    
    bool flg=false;
    
    for(AnimalPlayer* _player in animalArray){
        if([BasicMath RadiusIntersectsRadius:hitPlayer.position pointB:_player.position radius1:20 radius2:20]){
            if(hitPlayer!=_player){
                flg=true;
            }
        }
    }
    for(AnimalEnemy* _enemy in enemyArray){
        if([BasicMath RadiusIntersectsRadius:hitPlayer.position pointB:_enemy.position radius1:20 radius2:20]){
            flg=true;
        }
    }
    return flg;
}

+(void)createPlayer:(CGPoint)playerPos playerNum:(int)playerNum{
    
    player=[AnimalPlayer createPlayer:playerPos playerNum:playerNum];
    [animalArray addObject:player];
    [bgSpLayer addChild:player];
}

+(void)createEnemy{
    
    enemy=[AnimalEnemy createEnemy];
    [enemyArray addObject:enemy];
    [bgSpLayer addChild:enemy];
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{

    CGPoint worldLocation;
    CGPoint touchLocation = [touch locationInNode:self];
    
    float offsetY = bgSpLayer.contentSize.height - winSize.height - scrollView.scrollPosition.y;
    worldLocation.x = touchLocation.x + scrollView.scrollPosition.x;
    worldLocation.y = touchLocation.y + offsetY;
    
    if([StageLevel_01 isAnimal:worldLocation type:0]){//経路作成レイヤー表示
        if(![StageLevel_01 isCollision:hitPlayer]){//タッチした戦車が衝突継続中でなければ経路作成可能
            routeGeneLyer.offsetY=offsetY;
            [self addChild:routeGeneLyer z:1];
            hitPlayer.state_PathMake_flg=true;
        }
        
    }else if(![StageLevel_01 isAnimal:worldLocation type:1]){//プレイヤー追加
        if(worldLocation.y < 200){
            playSelect.visible=true;
            playSelect.createPlayerPos=worldLocation;
            [playSelect setArrowVisible:offsetY];
        }
    }
}

@end
