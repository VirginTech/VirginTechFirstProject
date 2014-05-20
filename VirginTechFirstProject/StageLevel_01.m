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
#import "IAdLayer.h"
#import "InformationLayer.h"

@implementation StageLevel_01


int maxHeight;
CGSize winSize;
CCScrollView* scrollView;
CCSprite* bgSpLayer;
InformationLayer* infoLayer;

NSMutableArray* animalArray;
NSMutableArray* enemyArray;
RouteGenerationLayer* routeGeneLyer;
AnimalPlayer* touchPlayer;

PlayerSelection* playSelect;
AnimalPlayer* creatPlayer;
AnimalEnemy* creatEnemy;

NSMutableArray* searchTarget;

//審判用配列
NSMutableArray* removePlayerArray;
NSMutableArray* playerMissileArray;
NSMutableArray* removePlayerMissileArray;

NSMutableArray* removeEnemyArray;
NSMutableArray* enemyMissileArray;
NSMutableArray* removeEnemyMissileArray;

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
    playerMissileArray=[[NSMutableArray alloc]init];
    enemyMissileArray=[[NSMutableArray alloc]init];
    
    //ゲーム状態セット
    [GameManager setPlaying:true];//プレイ中
    [GameManager setPauseing:false];
    [GameManager setPauseStateChange:false];
    
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
    
    //プレイヤー選択レイヤー z:2
    playSelect=[[PlayerSelection alloc]init];
    
    //ポーズレイヤー z3
    NaviLayer* navi=[[NaviLayer alloc]init];
    [self addChild:navi z:3];
    
    //インフォメーション z:4
    infoLayer=[[InformationLayer alloc]init];
    [self addChild:infoLayer z:4];
    
    //iAdバナー表示 z:5
    IAdLayer* iAd=[[IAdLayer alloc]init:1];
    [self addChild:iAd z:5];
    
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
    [self schedule:@selector(createEnemy_Schedule:)interval:20.0 repeat:CCTimerRepeatForever delay:5.0];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
}

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

-(void)createEnemy_Schedule:(CCTime)dt
{
    [StageLevel_01 createEnemy];
}

-(void)judgement_Schedule:(CCTime)dt
{
    removePlayerArray=[[NSMutableArray alloc]init];
    removeEnemyArray=[[NSMutableArray alloc]init];
    removePlayerMissileArray=[[NSMutableArray alloc]init];
    removeEnemyMissileArray=[[NSMutableArray alloc]init];
    
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
    //敵　対　敵　衝突判定
    for(AnimalEnemy* enemy1 in enemyArray){
        for(AnimalEnemy* enemy2 in enemyArray){
            if([BasicMath RadiusIntersectsRadius:enemy1.position pointB:enemy2.position
                                         radius1:20 radius2:20]){
                if(enemy1!=enemy2){
                    enemy1.stopFlg=true;
                    enemy2.stopFlg=true;
                }
            }
        }
    }
    //プレイヤー　対　敵
    for(AnimalPlayer* player in animalArray){
        player.destCollectFlg=false;//便宜上ここで初期化
        for(AnimalEnemy* enemy in enemyArray){
            enemy.destCollectFlg=false;//便宜上ここで初期化
            if([BasicMath RadiusIntersectsRadius:enemy.position pointB:player.position
                                                                            radius1:20 radius2:20]){
                enemy.stopFlg=true;
                player.stopFlg=true;
            }
        }
    }
    //プレイヤー再稼働
    for(AnimalPlayer* player in animalArray){
        if(player.stopFlg){//停止中であって
            if(![StageLevel_01 isPlayerCollision:player]){//誰とも接触していなければ
                player.stopFlg=false;
                [player resumeRunning];//再稼働する
            }
        }
    }
    //敵アニマル再稼働
    for(AnimalEnemy* enemy in enemyArray){
        if(enemy.stopFlg){//停止中であって
            if(![StageLevel_01 isEnemyCollision:enemy]){//誰とも接触していなければ
                enemy.stopFlg=false;
                [enemy resumeRunning];//再稼働する
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
    //プレイヤーミサイル当たり判定
    for(PlayerMissile* missile in playerMissileArray){
        //時限切れミサイル削除
        if(missile.timeFlg){
            [removePlayerMissileArray addObject:missile];
        }else{
            for(AnimalEnemy* enemy in enemyArray){
                if([BasicMath RadiusIntersectsRadius:missile.position pointB:enemy.position radius1:10 radius2:20]){
                    if(!enemy.destCollectFlg){//多重判定防止
                        enemy.destCollectFlg=true;
                        [removePlayerMissileArray addObject:missile];
                        //敵ダメージ
                        enemy.ability_Defense -= missile.ability_Attack;
                        if(enemy.ability_Defense<=0){
                            [removeEnemyArray addObject:enemy];
                        }
                        break;//二重判定防止
                    }
                }
            }
        }
    }
    //敵ミサイル当たり判定
    for(EnemyMissile* missile in enemyMissileArray){
        //時限切れミサイル削除
        if(missile.timeFlg){
            [removeEnemyMissileArray addObject:missile];
        }else{
            for(AnimalPlayer* player in animalArray){
                if([BasicMath RadiusIntersectsRadius:missile.position pointB:player.position radius1:10 radius2:20]){
                    if(!player.destCollectFlg){//多重判定防止
                        player.destCollectFlg=true;
                        [removeEnemyMissileArray addObject:missile];
                        //プレイヤーダメージ
                        player.ability_Defense -= missile.ability_Attack;
                        if(player.ability_Defense<=0){
                            [removePlayerArray addObject:player];
                        }
                        break;//二重判定防止
                    }
                }
            }
        }
    }

    //当たり判定ミサイル削除
    for(PlayerMissile* missile in removePlayerMissileArray){
        [playerMissileArray removeObject:missile];
        [bgSpLayer removeChild:missile cleanup:YES];
    }
    for(EnemyMissile* missile in removeEnemyMissileArray){
        [enemyMissileArray removeObject:missile];
        [bgSpLayer removeChild:missile cleanup:YES];
    }
    //消滅プレイヤー削除
    for(AnimalPlayer* player in removePlayerArray){
        [animalArray removeObject:player];
        [bgSpLayer removeChild:player cleanup:YES];
    }
    //消滅「敵」削除
    for(AnimalEnemy* enemy in removeEnemyArray){
        [enemyArray removeObject:enemy];
        [bgSpLayer removeChild:enemy cleanup:YES];
    }
    
    //ポーズ監視
    if([GameManager getPauseStateChange]){
        if([GameManager getPauseing]){
            
            [self unschedule:@selector(createEnemy_Schedule:)];
            
            for(AnimalPlayer* player in animalArray){
                [player onPause_To_Resume:true];
            }
            for(PlayerMissile* missile in playerMissileArray){
                [missile onPause_To_Resume:true];
            }
            for(AnimalEnemy* enemy in enemyArray){
                [enemy onPause_To_Resume:true];
            }
            for(EnemyMissile* missile in enemyMissileArray){
                [missile onPause_To_Resume:true];
            }
        }else{
            
            [self schedule:@selector(createEnemy_Schedule:)interval:20.0 repeat:CCTimerRepeatForever delay:5.0];
            
            for(AnimalPlayer* player in animalArray){
                [player onPause_To_Resume:false];
            }
            for(PlayerMissile* missile in playerMissileArray){
                [missile onPause_To_Resume:false];
            }
            for(AnimalEnemy* enemy in enemyArray){
                [enemy onPause_To_Resume:false];
            }
            for(EnemyMissile* missile in enemyMissileArray){
                [missile onPause_To_Resume:false];
            }
        }
        [GameManager setPauseStateChange:false];
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
                touchPlayer=_player;
                routeGeneLyer.player=_player;
                flg=true;
            }
        }else if(type==1){//プレイヤー追加
            if([BasicMath RadiusContainsPoint:_player.position pointB:touchLocation radius:70]){
                touchPlayer=_player;
                routeGeneLyer.player=_player;
                flg=true;
            }
        }
    }
    return flg;
}

//===================================
// 選択したプレイヤーが衝突継続中かどうか
//===================================
+(BOOL)isPlayerCollision:(AnimalPlayer*)player
{
    bool flg=false;
    
    for(AnimalPlayer* _player in animalArray){
        if([BasicMath RadiusIntersectsRadius:player.position pointB:_player.position radius1:20 radius2:20]){
            if(player!=_player){
                flg=true;
            }
        }
    }
    for(AnimalEnemy* _enemy in enemyArray){
        if([BasicMath RadiusIntersectsRadius:player.position pointB:_enemy.position radius1:20 radius2:20]){
            flg=true;
        }
    }
    return flg;
}
//===================================
// 選択した敵が衝突継続中かどうか
//===================================
+(BOOL)isEnemyCollision:(AnimalEnemy*)enemy
{    
    bool flg=false;
    
    for(AnimalEnemy* _enemy in enemyArray){
        if([BasicMath RadiusIntersectsRadius:enemy.position pointB:_enemy.position radius1:20 radius2:20]){
            if(enemy!=_enemy){
                flg=true;
            }
        }
    }
    for(AnimalPlayer* _player in animalArray){
        if([BasicMath RadiusIntersectsRadius:enemy.position pointB:_player.position radius1:20 radius2:20]){
            flg=true;
        }
    }
    return flg;
}

//============================
// プレイヤーアニマルセット
//============================
+(void)createPlayer:(CGPoint)playerPos playerNum:(int)playerNum{
    
    creatPlayer=[AnimalPlayer createPlayer:playerPos playerNum:playerNum];
    [animalArray addObject:creatPlayer];
    [bgSpLayer addChild:creatPlayer z:2];

    infoLayer.coin -= playerNum;//コイン数減
    [GameManager save_Currency_Coin:infoLayer.coin];//コインセーブ
    [infoLayer updateCurrencyLabel];//インフォレイヤーにコインを反映
}
//============================
// 敵アニマルセット
//============================
+(void)createEnemy
{
    creatEnemy=[AnimalEnemy createEnemy];
    [enemyArray addObject:creatEnemy];
    [bgSpLayer addChild:creatEnemy z:0];
}

//============================
// プレイヤーミサイルセット
//============================
+(void)setPlayerMissile:(PlayerMissile*)missile zOrder:(int)zOrder
{
    [bgSpLayer addChild:missile z:zOrder];
    [playerMissileArray addObject:missile];
}

//============================
// 敵ミサイルセット
//============================
+(void)setEnemyMissile:(EnemyMissile*)missile zOrder:(int)zOrder
{
    [bgSpLayer addChild:missile z:zOrder];
    [enemyMissileArray addObject:missile];
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

}

//-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
//
//}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{

    if([GameManager getPauseing]){
        return;
    }
    
    CGPoint worldLocation;
    CGPoint touchLocation = [touch locationInNode:self];
    
    float offsetY = bgSpLayer.contentSize.height - winSize.height - scrollView.scrollPosition.y;
    worldLocation.x = touchLocation.x + scrollView.scrollPosition.x;
    worldLocation.y = touchLocation.y + offsetY;
    
    if([StageLevel_01 isAnimal:worldLocation type:0]){//経路作成レイヤー表示
        if(![StageLevel_01 isPlayerCollision:touchPlayer]){//タッチした戦車が衝突継続中でなければ経路作成可能
            routeGeneLyer.offsetY=offsetY;
            [self addChild:routeGeneLyer z:1];
            touchPlayer.state_PathMake_flg=true;
        }
        
    }else if(![StageLevel_01 isAnimal:worldLocation type:1]){//プレイヤー追加
        if(worldLocation.y < 200){
            //playSelect.visible=true;
            [self addChild:playSelect z:2];
            playSelect.createPlayerPos=worldLocation;
            [playSelect setArrowVisible:offsetY];
        }
    }
}

@end
