//
//  StageLevel_01.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/02.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "TutorialLevel.h"
#import "GameManager.h"
#import "ObjectManager.h"
#import "AnimalPlayer.h"
#import "AnimalEnemy.h"
#import "NaviLayer.h"
#import "CCScrollView.h"
#import "RouteGenerationLayer.h"
#import "BasicMath.h"
#import "PlayerSelection.h"
#import "IAdLayer.h"
#import "InformationLayer.h"
#import "AchievementManeger.h"
#import "Fortress.h"
#import "CCParticleSystem.h"
#import "CCDrawingPrimitives.h"
#import "SoundManager.h"
#import "NendAdLayer.h"

@implementation TutorialLevel

CGSize winSize;
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
Fortress* playerFortress;
Fortress* enemyFortress;
int enemyCount;

int finishCount;
CCParticleSystem* playerParticle;
CCParticleSystem* enemyParticle;

//審判用配列
NSMutableArray* removePlayerArray;
NSMutableArray* playerMissileArray;
NSMutableArray* removePlayerMissileArray;

NSMutableArray* removeEnemyArray;
NSMutableArray* enemyMissileArray;
NSMutableArray* removeEnemyMissileArray;

//チュートリアル用
CCSprite* finger;
CGPoint targetPos;
float velocity;

+(TutorialLevel*)scene
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
    playerParticle=nil;
    enemyParticle=nil;
    finishCount=0;
    
    //ゲーム状態セット
    [GameManager setPlaying:true];//プレイ中
    [GameManager setPauseing:false];
    [GameManager setPauseStateChange:false];
    
    //ステージレベル取得
    //int stageLevel=[GameManager getStageLevel];
    
    //基礎集計（ステージレヴェル達成率）セーブ：0ステージ(チュートリアル)を実行すればクリアとする
    if([GameManager load_Aggregate_Stage]<[GameManager getStageLevel]){
        [GameManager save_Aggregate_Stage:[GameManager getStageLevel]];
    }

    //BGM
    [SoundManager playBGM];
    
    //レベルに応じた画面の大きさ
    [GameManager setWorldSize:CGSizeMake(winSize.width, 570)];

    UIImage *image = [UIImage imageNamed:@"bgLayer.png"];
    UIGraphicsBeginImageContext(CGSizeMake(winSize.width,[GameManager getWorldSize].height));
    [image drawInRect:CGRectMake(0, 0, winSize.width,[GameManager getWorldSize].height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //スクロールビュー配置 z:0
    bgSpLayer=[CCSprite spriteWithCGImage:image.CGImage key:nil];
    scrollView=[[CCScrollView alloc]initWithContentNode:bgSpLayer];
    scrollView.horizontalScrollEnabled=NO;
    scrollView.mode=0;
    bgSpLayer.position=CGPointMake(0, winSize.height-bgSpLayer.contentSize.height);
    [self addChild:scrollView z:0];
    
    //地面
    [self t_setGround];
    
    //陣地ライン
    CCSprite* line=[CCSprite spriteWithImageNamed:@"position_line.png"];
    line.position=CGPointMake(winSize.width/2, [GameManager getWorldSize].height / 5.0f);
    [bgSpLayer addChild:line];
    
    //プレイヤー選択レイヤー z:1
    //playSelect=[[PlayerSelection alloc]init];

    //経路作成レイヤー z:2
    routeGeneLyer=[[RouteGenerationLayer alloc]init];
    
    //ポーズレイヤー z3
    NaviLayer* navi=[[NaviLayer alloc]init];
    [self addChild:navi z:3];
    
    //インフォメーション z:4
    infoLayer=[[InformationLayer alloc]init];
    [self addChild:infoLayer z:4];
    
    //チュートリアル
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"interface_default.plist"];
    finger=[CCSprite spriteWithSpriteFrame:
            [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"finger.png"]];
    finger.position=CGPointMake(winSize.width, winSize.height/2);
    finger.visible=false;
    [bgSpLayer addChild:finger z:4];
    
    targetPos=CGPointMake(winSize.width/2+finger.contentSize.width/2, 120);
    velocity = 1.5;
        
    if([GameManager getDevice]==3){//iPad
        //iAdバナー表示 z:5
        IAdLayer* iAd=[[IAdLayer alloc]init:1];
        [self addChild:iAd z:5];
    }else{
        //NendAdバナー表示
        NendAdLayer* nAd=[[NendAdLayer alloc]init];
        [self addChild:nAd];
    }
    
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
    //要塞陣地 z:2
    [self t_createPlayerFortress];
    [self t_createEnemyFortress];
    //植樹 z:4
    [self t_setTreePlanting];
    //審判スケジュール開始
    [self schedule:@selector(t_judgement_Schedule:)interval:0.1];
    //チュートリアル開始
    [self schedule:@selector(finger_Move_Schedule:)interval:0.01 repeat:CCTimerRepeatForever delay:1.0];
    //敵アニマル戦車登場
    enemyCount=1;
    //[self schedule:@selector(createEnemy_Schedule:)interval:20.0 repeat:CCTimerRepeatForever delay:20.0];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
}

- (void)onExit
{
    // always call super onExit last
    [super onExit];
    //[SoundManager stopBGM];
}

-(void)t_setGround
{
    float offsetX;
    float offsetY;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ground_default.plist"];
    CCSprite* frame = [CCSprite spriteWithSpriteFrame:
                                    [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ground_00.png"]];
    CGSize frameCount = CGSizeMake(winSize.width/frame.contentSize.width+2,
                                    [GameManager getWorldSize].height/frame.contentSize.height+1);
    NSString* bgName=[NSString stringWithFormat:@"ground_%02d.png",(arc4random()%10)];
    for(int i=0;i<frameCount.width*frameCount.height;i++)
    {
        frame = [CCSprite spriteWithSpriteFrame:
                                    [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:bgName]];
        if(i==0){
            offsetX = frame.contentSize.width/2-1;
            offsetY = frame.contentSize.height/2-1;
        }else if(i%(int)frameCount.width==0){
            offsetX = frame.contentSize.width/2-1;
            offsetY = offsetY + frame.contentSize.height-1;
        }else{
            offsetX = offsetX + frame.contentSize.width-1;
        }
        frame.position = CGPointMake(offsetX,offsetY);
        [bgSpLayer addChild:frame z:0];
    }
}

-(void)t_setTreePlanting
{
    CGPoint plantPos;
    NSString* leafName;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"leaf_default.plist"];

    for(int i=200;i<[GameManager getWorldSize].height-200;i+=150)
    {
        plantPos.x = arc4random() % (int)winSize.width;
        plantPos.y = (arc4random() % 150) + i;
        
        leafName=[NSString stringWithFormat:@"leaf%02d.png",(arc4random()%5)+1];
        CCSprite* leaf=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:leafName]];
        leaf.scale=((arc4random()%3)+3)/10.0f;
        leaf.position=plantPos;
        [bgSpLayer addChild:leaf z:4];
    }
}

-(void)t_createEnemy_Schedule:(CCTime)dt
{
    if(enemyCount<=2){
        [TutorialLevel t_createEnemy];
    }
    enemyCount++;
}

-(void)finger_Move_Schedule:(CCTime)dt
{
    CGPoint nextPos;
    float targetAngle;
    float targetDistance;
    
    finger.visible=true;
    
    //方角セット
    targetAngle = [BasicMath getAngle_To_Radian:finger.position ePos:targetPos];
    //総距離セット
    targetDistance = sqrtf(powf(finger.position.x - targetPos.x,2) + powf(finger.position.y - targetPos.y,2));
    //次位置セット
    nextPos=CGPointMake(velocity*cosf(targetAngle),velocity*sinf(targetAngle));
    finger.position=CGPointMake(finger.position.x+nextPos.x, finger.position.y+nextPos.y);
    
    if(targetDistance < 5.0){
        [self unschedule:@selector(finger_Move_Schedule:)];
        [self schedule:@selector(finger_Rotation_Schedule:)interval:0.01];
    }
}

-(void)finger_Drag_Schedule:(CCTime)dt
{
    CGPoint nextPos;
    float targetAngle;
    float targetDistance;
    
    finger.visible=true;
    
    //方角セット
    targetAngle = [BasicMath getAngle_To_Radian:finger.position ePos:targetPos];
    //総距離セット
    targetDistance = sqrtf(powf(finger.position.x - targetPos.x,2) + powf(finger.position.y - targetPos.y,2));
    //次位置セット
    nextPos=CGPointMake(velocity*cosf(targetAngle),velocity*sinf(targetAngle));
    finger.position=CGPointMake(finger.position.x+nextPos.x, finger.position.y+nextPos.y);
    //線描画
    CCDrawNode* drawNode=[CCDrawNode node];
    [drawNode drawDot:ccp(finger.position.x-finger.contentSize.width/2,finger.position.y-15.0f)
                                        radius:3.0 color:[CCColor whiteColor]];
    [bgSpLayer addChild:drawNode];

    if(targetDistance < 5.0){
        [self unschedule:@selector(finger_Drag_Schedule:)];
    }
}

-(void)finger_Rotation_Schedule:(CCTime)dt
{
    if(finger.rotation<15){
        finger.rotation=finger.rotation+0.3;
    }else{
        finger.rotation=0;
    }
}

+(void)setFinger
{
    //finger.position=targetPos;
    finger.visible=true;
}

-(void)t_judgement_Schedule:(CCTime)dt
{
    removePlayerArray=[[NSMutableArray alloc]init];
    removeEnemyArray=[[NSMutableArray alloc]init];
    removePlayerMissileArray=[[NSMutableArray alloc]init];
    removeEnemyMissileArray=[[NSMutableArray alloc]init];
    
    /*/プレイヤー対プレイヤー衝突判定
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
    }*/
    
    //プレイヤー　対　敵要塞基地
    for(AnimalPlayer* player in animalArray){
        if([BasicMath RadiusIntersectsRadius:player.position pointB:enemyFortress.position
                                     radius1:20 radius2:30]){
            player.stopFlg=true;
        }
    }
    //敵　対　要塞基地
    for(AnimalEnemy* enemy in enemyArray){
        if([BasicMath RadiusIntersectsRadius:enemy.position pointB:playerFortress.position
                                     radius1:20 radius2:30]){
            enemy.stopFlg=true;
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
            if(![TutorialLevel t_isPlayerCollision:player]){//誰とも接触していなければ
                player.stopFlg=false;
                [player resumeRunning];//再稼働する
            }
        }
    }
    //敵アニマル再稼働
    for(AnimalEnemy* enemy in enemyArray){
        if(enemy.stopFlg){//停止中であって
            if(![TutorialLevel t_isEnemyCollision:enemy]){//誰とも接触していなければ
                enemy.stopFlg=false;
                [enemy resumeRunning];//再稼働する
            }
        }
    }
    
    if([GameManager getPauseing]){//ポーズ中
        searchTarget=[[NSMutableArray alloc]init];//ポーズ中であれば空
        for(AnimalPlayer* player in animalArray){
            [player setTarget:searchTarget];
        }
        for(AnimalEnemy* enemy in enemyArray){
            [enemy setTarget:searchTarget];
        }
        
    }else{
        //敵アニマル戦車の我要塞基地捕捉用レーダー
        for(AnimalEnemy* enemy in enemyArray){
            searchTarget=[[NSMutableArray alloc]init];
            if([BasicMath RadiusIntersectsRadius:enemy.position pointB:playerFortress.position
                                         radius1:120 radius2:30]){
                [searchTarget addObject:playerFortress];
                enemy.fortressFlg=true;//要塞攻撃モード
            }
            [enemy setTarget:searchTarget];
        }
        //敵アニマル戦車の我タンク捕捉用レーダー
        for(AnimalEnemy* enemy in enemyArray){
            if(!enemy.fortressFlg){
                searchTarget=[[NSMutableArray alloc]init];
                for(AnimalPlayer* player in animalArray){
                    if([BasicMath RadiusIntersectsRadius:enemy.position pointB:player.position
                                                 radius1:120 radius2:20]){
                        [searchTarget addObject:player];
                    }
                }
                [enemy setTarget:searchTarget];
            }
        }
        
        //我アニマル戦車の敵要塞基地捕捉用レーダー
        for(AnimalPlayer* player in animalArray){
            searchTarget=[[NSMutableArray alloc]init];
            if([BasicMath RadiusIntersectsRadius:player.position pointB:enemyFortress.position
                                         radius1:120 radius2:30]){
                [searchTarget addObject:enemyFortress];
                player.fortressFlg=true;//要塞攻撃モード
            }else{
                player.fortressFlg=false;//通常攻撃モード
            }
            [player setTarget:searchTarget];
        }
        //我アニマル戦車の敵タンク捕捉用レーダー
        for(AnimalPlayer* player in animalArray){
            if(!player.fortressFlg){
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
    }
    
    //フロッキング用リーダー監視
    for(AnimalPlayer* player1 in animalArray){
        player1.leaderPlayer=nil;
        if(!player1.leaderFlg && !player1.stopFlg){
            for(AnimalPlayer* player2 in animalArray){
                if(player1!=player2 && player1.groupNum==player2.groupNum){
                    if(player1.position.y<=player2.position.y){
                        if([BasicMath RadiusIntersectsRadius:player1.position pointB:player2.position
                                             radius1:80 radius2:20]){
                            player1.leaderPlayer=player2;
                            player1.leaderOldPos=player2.position;
                            break;
                        }
                    }
                }
            }
        }
    }

    //プレイヤーミサイル　対　敵
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
                        if(enemy.ability_Defense<=0){//敵撃破！
                            //効果音
                            [SoundManager enemyDestruct];
                            //パーティクル
                            [TutorialLevel t_setEnemyParticle:0 pos:enemy.position fileName:@"enemyDead.plist"];
                            //敵削除配列へ
                            [removeEnemyArray addObject:enemy];
                        }
                        break;//二重判定防止
                    }
                }
            }
        }
    }
    //敵ミサイル　対　プレイヤー
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
                            //効果音
                            [SoundManager playerDestruct];
                            //パーティクル
                            [TutorialLevel t_setPlayerParticle:0 pos:player.position fileName:@"playerDead.plist"];
                        }
                        break;//二重判定防止
                    }
                }
            }
        }
    }
    //不要アイテム削除
    [self garbageDeletion];
    
    //プレイヤーミサイル　対　敵要塞
    for(PlayerMissile* missile in playerMissileArray){
        //時限切れミサイル削除
        if(missile.timeFlg){
            [removePlayerMissileArray addObject:missile];
        }else{
            if([BasicMath RadiusIntersectsRadius:missile.position pointB:enemyFortress.position radius1:10 radius2:30]){
                //効果音
                [SoundManager fortressDamage];
                
                [removePlayerMissileArray addObject:missile];
                enemyFortress.ability_Defense -= missile.ability_Attack;
                if(enemyFortress.ability_Defense<=0){
                    //フィニッシュ
                    [self schedule:@selector(t_finish_Success_Schedule_t:)interval:0.2 repeat:7 delay:0.5];
                    [GameManager setPauseStateChange:true];
                    [GameManager setPauseing:true];
                    
                    break;
                }
            }
        }
    }
    //敵ミサイル　対　要塞
    for(EnemyMissile* missile in enemyMissileArray){
        //時限切れミサイル削除
        if(missile.timeFlg){
            [removeEnemyMissileArray addObject:missile];
        }else{
            if([BasicMath RadiusIntersectsRadius:missile.position pointB:playerFortress.position radius1:10 radius2:30]){
                //効果音
                [SoundManager fortressDamage];
                
                [removeEnemyMissileArray addObject:missile];
                playerFortress.ability_Defense -= missile.ability_Attack;
                if(playerFortress.ability_Defense<=0){
                    //フィニッシュ
                    [self schedule:@selector(t_finish_Failure_Schedule_t:)interval:0.2 repeat:7 delay:0.5];
                    [GameManager setPauseStateChange:true];
                    [GameManager setPauseing:true];
                    break;
                }else{
                    //画面を揺する
                    [self schedule:@selector(t_crisis_Schedule:)interval:0.1 repeat:3 delay:0.0];
                }
            }
        }
    }
    //不要アイテム削除
    [self garbageDeletion];
    
    //ポーズ監視
    if([GameManager getPauseStateChange]){
        if([GameManager getPauseing]){
            
            [self unschedule:@selector(t_createEnemy_Schedule:)];
            
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
            
            [self schedule:@selector(t_createEnemy_Schedule:)interval:10.0 repeat:CCTimerRepeatForever delay:5.0];
            
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

-(void)garbageDeletion
{
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

    removePlayerArray=[[NSMutableArray alloc]init];
    removeEnemyArray=[[NSMutableArray alloc]init];
    removePlayerMissileArray=[[NSMutableArray alloc]init];
    removeEnemyMissileArray=[[NSMutableArray alloc]init];
}

-(void)t_finish_Failure_Schedule_t:(CCTime)dt
{
    finishCount++;
    [SoundManager stopBGM];
    
    //エフェクト
    [TutorialLevel t_setPlayerParticle:1 pos:playerFortress.position fileName:@"playerDead.plist"];
    bgSpLayer.position = CGPointMake(bgSpLayer.position.x+10, bgSpLayer.position.y-10);
    if(finishCount%2==0){
        [SoundManager fortressDestruct];
    }
    if(finishCount>=7){
        //エンディングサウンド
        [SoundManager endingEffect:false];
        
        [self unscheduleAllSelectors];
        [bgSpLayer removeChild:playerFortress cleanup:YES];
        [NaviLayer setStageEndingScreen:false rate:0];
    }
}

-(void)t_finish_Success_Schedule_t:(CCTime)dt
{
    finishCount++;
    [SoundManager stopBGM];
    
    //エフェクト
    [TutorialLevel t_setEnemyParticle:1 pos:enemyFortress.position fileName:@"enemyDead.plist"];
    bgSpLayer.position = CGPointMake(bgSpLayer.position.x-10, bgSpLayer.position.y+10);
    if(finishCount%2==0){
        [SoundManager fortressDestruct];
    }
    if(finishCount>=7){
        //エンディングサウンド
        [SoundManager endingEffect:true];

        [self unscheduleAllSelectors];
        [bgSpLayer removeChild:enemyFortress cleanup:YES];
        //ステージクリア状態のセーブ
        float fortRemainPower=(100/playerFortress.maxLife)*playerFortress.ability_Defense;
        if(fortRemainPower>=80.0f){
            [NaviLayer setStageEndingScreen:true rate:3];
        }else if(fortRemainPower>=50.0f){
            [NaviLayer setStageEndingScreen:true rate:2];
        }else{
            [NaviLayer setStageEndingScreen:true rate:1];
        }
    }
}

-(void)t_crisis_Schedule:(CCTime)dt
{
    bgSpLayer.position = CGPointMake(bgSpLayer.position.x+10, bgSpLayer.position.y-10);
}

//============================
// タッチしたアニマル戦車を特定する
//============================
+(BOOL)t_isAnimal:(CGPoint)touchLocation type:(int)type{
    
    BOOL flg=false;
    
    for(AnimalPlayer* _player in animalArray){
        if(type==0){//経路作成
            if([BasicMath RadiusContainsPoint:_player.position pointB:touchLocation radius:30]){
                touchPlayer=_player;
                routeGeneLyer.player=_player;
                flg=true;
            }
        }else if(type==1){//プレイヤー追加
            if([BasicMath RadiusContainsPoint:_player.position pointB:touchLocation radius:10]){
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
+(BOOL)t_isPlayerCollision:(AnimalPlayer*)player
{
    bool flg=false;
    /*
    for(AnimalPlayer* _player in animalArray){
        if([BasicMath RadiusIntersectsRadius:player.position pointB:_player.position radius1:20 radius2:20]){
            if(player!=_player){
                flg=true;
            }
        }
    }*/
    for(AnimalEnemy* _enemy in enemyArray){
        if([BasicMath RadiusIntersectsRadius:player.position pointB:_enemy.position radius1:20 radius2:20]){
            flg=true;
        }
    }
    if([BasicMath RadiusIntersectsRadius:player.position pointB:enemyFortress.position radius1:20 radius2:30]){
        flg=true;
    }
    return flg;
}
//===================================
// 選択した敵が衝突継続中かどうか
//===================================
+(BOOL)t_isEnemyCollision:(AnimalEnemy*)enemy
{    
    bool flg=false;
    /*
    for(AnimalEnemy* _enemy in enemyArray){
        if([BasicMath RadiusIntersectsRadius:enemy.position pointB:_enemy.position radius1:20 radius2:20]){
            if(enemy!=_enemy){
                flg=true;
            }
        }
    }*/
    for(AnimalPlayer* _player in animalArray){
        if([BasicMath RadiusIntersectsRadius:enemy.position pointB:_player.position radius1:20 radius2:20]){
            flg=true;
        }
    }
    if([BasicMath RadiusIntersectsRadius:enemy.position pointB:playerFortress.position radius1:20 radius2:30]){
        flg=true;
    }
    return flg;
}

//============================
// プレイヤーアニマルセット
//============================
+(void)t_createPlayer:(CGPoint)playerPos playerNum:(int)playerNum
{
    //効果音
    [SoundManager playerSet:playerNum];
    
    creatPlayer=[AnimalPlayer createPlayer:playerPos playerNum:playerNum];
    [animalArray addObject:creatPlayer];
    [bgSpLayer addChild:creatPlayer z:3];
    //パーティクル
    [self t_setPlayerParticle:0 pos:playerPos fileName:@"playerAdding.plist"];
}
//============================
// 敵アニマルセット
//============================
+(void)t_createEnemy
{
    creatEnemy=[AnimalEnemy createEnemy];
    [enemyArray addObject:creatEnemy];
    [bgSpLayer addChild:creatEnemy z:2];
    
    //効果音
    [SoundManager enemySet:creatEnemy.enemyNum];
}

//============================
// プレイヤーミサイルセット
//============================
+(void)t_setPlayerMissile:(PlayerMissile*)missile zOrder:(int)zOrder type:(int)type
{
    //効果音
    [SoundManager playerFireMissile:type];

    [bgSpLayer addChild:missile z:zOrder];
    [playerMissileArray addObject:missile];
}

//============================
// 敵ミサイルセット
//============================
+(void)t_setEnemyMissile:(EnemyMissile*)missile zOrder:(int)zOrder type:(int)type
{
    //効果音
    [SoundManager enemyFireMissile:type];
    
    [bgSpLayer addChild:missile z:zOrder];
    [enemyMissileArray addObject:missile];
}
//============================
// プレイヤー要塞セット
//============================
-(void)t_createPlayerFortress
{
    playerFortress=[Fortress createFortress:ccp(winSize.width/2, 30) type:0];
    [bgSpLayer addChild:playerFortress z:2];
}
//============================
// 敵要塞セット
//============================
-(void)t_createEnemyFortress
{
    enemyFortress=[Fortress createFortress:ccp(winSize.width/2,[GameManager getWorldSize].height-30) type:1];
    [bgSpLayer addChild:enemyFortress z:2];
}
//============================
// パーティクルセット(プレイヤー)
//============================
+(void)t_setPlayerParticle:(int)type pos:(CGPoint)pos fileName:(NSString*)fileName
{
    if(playerParticle!=nil){//その都度削除
        [bgSpLayer removeChild:playerParticle cleanup:YES];
    }
    playerParticle=[[CCParticleSystem alloc]initWithFile:fileName];
    playerParticle.position=pos;
    if(type==0){//タンク
        playerParticle.scale=0.3;
    }else if(type==1){//要塞
        playerParticle.scale=1.0;
    }
    [bgSpLayer addChild:playerParticle z:3];
}
//============================
// パーティクルセット(敵)
//============================
+(void)t_setEnemyParticle:(int)type pos:(CGPoint)pos fileName:(NSString*)fileName
{
    if(enemyParticle!=nil){//その都度削除
        [bgSpLayer removeChild:enemyParticle cleanup:YES];
    }
    enemyParticle=[[CCParticleSystem alloc]initWithFile:fileName];
    enemyParticle.position=pos;
    if(type==0){//タンク
        enemyParticle.scale=0.3;
    }else if(type==1){//要塞
        enemyParticle.scale=1.0;
    }
    [bgSpLayer addChild:enemyParticle z:3];
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    scrollView.scrollViewDeacceleration=0.3;
}

//-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
//
//}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if([GameManager getPauseing]){
        return;
    }
    
    CGPoint worldLocation;
    CGPoint touchLocation = [touch locationInNode:self];
    
    float offsetY = bgSpLayer.contentSize.height - winSize.height - scrollView.scrollPosition.y;
    worldLocation.x = touchLocation.x + scrollView.scrollPosition.x;
    worldLocation.y = touchLocation.y + offsetY;
    
    if([TutorialLevel t_isAnimal:worldLocation type:0]){//経路作成レイヤー表示
        if(![TutorialLevel t_isPlayerCollision:touchPlayer]){//タッチした戦車が衝突継続中でなければ経路作成可能
            routeGeneLyer.offsetY=offsetY;
            [self addChild:routeGeneLyer z:2];
            touchPlayer.state_PathMake_flg=true;
            
            [self unschedule:@selector(finger_Rotation_Schedule:)];
            targetPos=CGPointMake(enemyFortress.position.x+finger.contentSize.width/2, enemyFortress.position.y-50);
            [self schedule:@selector(finger_Drag_Schedule:)interval:0.01 repeat:CCTimerRepeatForever delay:1.0];
            [self schedule:@selector(t_createEnemy_Schedule:)interval:10.0 repeat:CCTimerRepeatForever delay:5.0];
            
        }
        
    }else if(![TutorialLevel t_isAnimal:worldLocation type:1]){//プレイヤー追加
        if(worldLocation.y < [GameManager getWorldSize].height / 5.0f){
            //効果音
            [SoundManager playerSelect];

            finger.visible=false;
            
            playSelect=[[PlayerSelection alloc]init];
            [self addChild:playSelect z:1];
            playSelect.createPlayerPos=worldLocation;
            [playSelect setArrowVisible:offsetY];
        }
    }
}

@end
