//
//  StageLevel_01.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/02.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "StageLevel_01.h"
#import "GameManager.h"
#import "ObjectManager.h"
#import "AnimalPlayer.h"
#import "AnimalEnemy.h"
#import "NaviLayer.h"
#import "CCScrollView.h"
#import "RouteGenerationLayer.h"
#import "BasicMath.h"
#import "PlayerSelection.h"
#import "InformationLayer.h"
#import "AchievementManeger.h"
#import "Fortress.h"
#import "CCParticleSystem.h"
#import "SoundManager.h"
#import "MessageLayer.h"

#import "IAdLayer.h"
#import "NendAdLayer.h"
#import "IMobileLayer.h"
#import "AdGenerLayer.h"

@implementation StageLevel_01

CGSize winSize;
CCSprite* bgSpLayer;
float offSetbgSpLayerY=0;
InformationLayer* infoLayer;

NSMutableArray* animalArray;
NSMutableArray* enemyArray;
RouteGenerationLayer* routeGeneLyer;
AnimalPlayer* touchPlayer;
AnimalEnemy* touchEnemy;

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

NSMutableArray* swampArray;

AdGenerLayer* adgSSP;

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
    swampArray=[[NSMutableArray alloc]init];
    playerParticle=nil;
    enemyParticle=nil;
    finishCount=0;
    offSetbgSpLayerY=0.0;
    
    //ゲーム状態セット
    [GameManager setPlaying:true];//プレイ中
    [GameManager setPauseing:false];
    [GameManager setPauseStateChange:false];
    
    //ステージレベル取得
    int stageLevel=[GameManager getStageLevel];
    
    //BGM
    [SoundManager playBGM];
    
    //レベルに応じた画面の大きさ
    [GameManager setWorldSize:CGSizeMake(winSize.width, 600+((stageLevel-1)*10))];

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
    bgSpLayer.position=CGPointMake(0, offSetbgSpLayerY);
    //bgSpLayer.position=CGPointMake(0, winSize.height-bgSpLayer.contentSize.height);
    [self addChild:scrollView z:0];
    
    //地面
    [self setGround];
    
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
    
    //iAdバナー表示 z:5
    //IAdLayer* iAd=[[IAdLayer alloc]init:1];
    //[self addChild:iAd z:5];

    //NendAdバナー表示
    //NendAdLayer* nAd=[[NendAdLayer alloc]init];
    //[self addChild:nAd];
    
    //iMobileバナー
    //IMobileLayer* iMAd=[[IMobileLayer alloc]init];
    //[self addChild:iMAd];
    
    //ADG-SSPバナー
    //AdGenerLayer* adgSSP=[[AdGenerLayer alloc]init];
    //[self addChild:adgSSP];

    // done
	return self;
}

- (void)dealloc
{
    //Ad削除
    [adgSSP removeLayer];
}

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    //要塞陣地 z:2
    [self createPlayerFortress];
    [self createEnemyFortress];
    //植樹 z:4
    [self setTreePlanting];
    //沼 z:1
    if([GameManager getStageLevel]>10){
        if([GameManager getStageLevel]%3==0){
            [self setSwamp];
        }
    }
    //オープニングスケジュール
    [self schedule:@selector(opening_Schedule:)interval:0.001 repeat:CCTimerRepeatForever delay:1.0];
    //審判スケジュール開始
    [self schedule:@selector(judgement_Schedule:)interval:0.1];
    //敵アニマル戦車登場
    enemyCount=1;
    [self schedule:@selector(createEnemy_Schedule:)interval:10.0 repeat:CCTimerRepeatForever delay:5.0];
    
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

-(void)opening_Schedule:(CCTime)dt
{
    offSetbgSpLayerY -= 1.0;
    bgSpLayer.position=CGPointMake(0, offSetbgSpLayerY);
    if(offSetbgSpLayerY <= winSize.height-bgSpLayer.contentSize.height){
        [self unschedule:@selector(opening_Schedule:)];
    }
}

-(void)setGround
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

-(void)setTreePlanting
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

-(void)setSwamp
{
    CGPoint swampPos;
    
    for(int i=[GameManager getWorldSize].height/5.0+130;i<[GameManager getWorldSize].height-270;i+=350)
    {
        swampPos.x = arc4random() % (int)winSize.width;
        swampPos.y = i;
        
        CCSprite* swamp=[CCSprite spriteWithImageNamed:@"swamp.png"];
        swamp.position=swampPos;
        swamp.scale=((arc4random()%7)+7)/10.0f;
        [bgSpLayer addChild:swamp z:1];
        [swampArray addObject:swamp];
    }
}

-(void)createEnemy_Schedule:(CCTime)dt
{
    if(enemyCount<=[GameManager getStageLevel]*1){
        if(enemyCount%10==0){
            [StageLevel_01 createEnemy];
            [StageLevel_01 createEnemy];
            [StageLevel_01 createEnemy];
        }else{
            [StageLevel_01 createEnemy];
        }
    }
    enemyCount++;
}

-(void)judgement_Schedule:(CCTime)dt
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
    
    //プレイヤー水中判定
    for(AnimalPlayer* player in animalArray){
        player.zOrder=3;//便宜上ここでzOrderを戻す
        for(CCSprite* _swamp in swampArray){
            if([BasicMath RadiusIntersectsRadius:player.position pointB:_swamp.position
                                         radius1:10 radius2:(_swamp.contentSize.width*_swamp.scale)/2-(100*_swamp.scale)]){
                player.waterFlg=true;
                if(player.groupNum==1){
                    player.ability_Defense -= 0.1;
                    if(player.ability_Defense<=0){
                        [removePlayerArray addObject:player];
                        //パーティクル
                        [StageLevel_01 setPlayerParticle:0 pos:player.position fileName:@"playerDead.plist"];
                    }
                }
                break;
            }else{
                player.waterFlg=false;
            }
        }
    }
    //不要アイテム削除
    [self garbageDeletion];
    
    //敵水中判定
    for(AnimalEnemy* enemy in enemyArray){
        for(CCSprite* _swamp in swampArray){
            if([BasicMath RadiusIntersectsRadius:enemy.position pointB:_swamp.position
                                         radius1:10 radius2:(_swamp.contentSize.width*_swamp.scale)/2-(100*_swamp.scale)]){
                enemy.waterFlg=true;
                break;
            }else{
                enemy.waterFlg=false;
            }
        }
    }
    
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
                            player1.posArray=[[NSMutableArray alloc]init];
                            player1.moveCnt=0;
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
                        //効果音
                        //[SoundManager enemyDamage];
                        if(enemy.ability_Defense<=0){//敵撃破！
                            //効果音
                            [SoundManager enemyDestruct];
                            //パーティクル
                            [StageLevel_01 setEnemyParticle:0 pos:enemy.position fileName:@"enemyDead.plist"];
                            //コイン報酬
                            [GameManager in_Out_Coin:1 addFlg:true];
                            [InformationLayer update_CurrencyLabel];
                            //基礎集計（タンク撃破率）セーブ
                            [GameManager save_Aggregate_Tank:[GameManager load_Aggregate_Tank]+1];
                            //ハイスコア更新
                            [GameManager save_HighScore:[GameManager load_HighScore]+round(enemy.maxLife)];
                            [InformationLayer update_HighScoreLabel];
                            //リーダーボードテスト
                            [GameManager submitScore_GameCenter:[GameManager load_HighScore]];
                            //アチーブメント保存
                            [self setAchievement:@"Achievement_Tank"];
                            //アチーブメントラベル更新
                            [InformationLayer update_AchievementLabel];
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
                        //効果音
                        //[SoundManager playerDamage];
                        if(player.ability_Defense<=0){
                            [removePlayerArray addObject:player];
                            //効果音
                            [SoundManager playerDestruct];
                            //パーティクル
                            [StageLevel_01 setPlayerParticle:0 pos:player.position fileName:@"playerDead.plist"];
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
                    if(!enemyFortress.destCollectFlg){//多重判定防止
                        
                        enemyFortress.destCollectFlg=true;
                        //フィニッシュ
                        [self schedule:@selector(finish_Success_Schedule:)interval:0.2 repeat:7 delay:0.5];
                        [GameManager setPauseStateChange:true];
                        [GameManager setPauseing:true];
                        //ハイスコア更新
                        [GameManager save_HighScore:[GameManager load_HighScore]+[GameManager getStageLevel]*100];
                        [InformationLayer update_HighScoreLabel];
                        //リーダーボードテスト
                        [GameManager submitScore_GameCenter:[GameManager load_HighScore]];
                        //コイン報酬
                        [GameManager in_Out_Coin:10+(([GameManager getStageLevel]-1)*2) addFlg:true];
                        [InformationLayer update_CurrencyLabel];
                        //基礎集計（要塞撃破率）セーブ
                        [GameManager save_Aggregate_Fortress:[GameManager load_Aggregate_Fortress]+1];
                        //アチーブメント保存
                        [self setAchievement:@"Achievement_Fortress"];
                        //基礎集計（ステージレヴェル達成率）セーブ
                        if([GameManager load_Aggregate_Stage]<[GameManager getStageLevel]){
                            //[GameManager save_Aggregate_Stage:[GameManager load_Aggregate_Stage]+1];
                            [GameManager save_Aggregate_Stage:[GameManager getStageLevel]];
                        }
                        //アチーブメント保存
                        [self setAchievement:@"Achievement_Stage"];
                        //アチーブメントラベル更新
                        [InformationLayer update_AchievementLabel];

                        break;
                    }
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
                    [self schedule:@selector(finish_Failure_Schedule:)interval:0.2 repeat:7 delay:0.5];
                    [GameManager setPauseStateChange:true];
                    [GameManager setPauseing:true];
                    break;
                }else{
                    //画面を揺する
                    [self schedule:@selector(crisis_Schedule:)interval:0.1 repeat:3 delay:0.0];
                }
            }
        }
    }
    //不要アイテム削除
    [self garbageDeletion];
    
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
            //ADG-SSPバナー
            adgSSP=[[AdGenerLayer alloc]init];
            [self addChild:adgSSP];
            
        }else{
            
            [self schedule:@selector(createEnemy_Schedule:)interval:10.0 repeat:CCTimerRepeatForever delay:5.0];
            
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
            //Ad削除
            [adgSSP removeLayer];
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

-(void)finish_Failure_Schedule:(CCTime)dt
{
    finishCount++;
    [SoundManager stopBGM];
    
    //エフェクト
    [StageLevel_01 setPlayerParticle:1 pos:playerFortress.position fileName:@"playerDead.plist"];
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
        //アチーブメント送信（まだ）
        [AchievementManeger reportAchievement_All];
        
        //広告表示
        //[[NADInterstitial sharedInstance] showAd];
        [ImobileSdkAds showBySpotID:@"276556"];
        
        //ADG-SSPバナー
        adgSSP=[[AdGenerLayer alloc]init];
        [self addChild:adgSSP];
    }
}

-(void)finish_Success_Schedule:(CCTime)dt
{
    finishCount++;
    [SoundManager stopBGM];
    
    //エフェクト
    [StageLevel_01 setEnemyParticle:1 pos:enemyFortress.position fileName:@"enemyDead.plist"];
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
            if([GameManager load_StageClear_State:[GameManager getStageLevel]]<3){
                [GameManager save_StageClear_State:[GameManager getStageLevel] rate:3];
            }
        }else if(fortRemainPower>=50.0f){
            [NaviLayer setStageEndingScreen:true rate:2];
            if([GameManager load_StageClear_State:[GameManager getStageLevel]]<2){
                [GameManager save_StageClear_State:[GameManager getStageLevel] rate:2];
            }
        }else{
            [NaviLayer setStageEndingScreen:true rate:1];
            if([GameManager load_StageClear_State:[GameManager getStageLevel]]<1){
                [GameManager save_StageClear_State:[GameManager getStageLevel] rate:1];
            }
        }
        //アチーブメント送信（まだ）
        [AchievementManeger reportAchievement_All];
        
        //レビュー誘導
        if([GameManager getStageLevel]%10==0){
            UIAlertView *alert = [[UIAlertView alloc] init];
            alert.tag=1;
            alert.delegate = self;
            if([GameManager getStageLevel]==STAGE_LEVEL_MAX){
                alert.title = NSLocalizedString(@"Final",NULL);
                alert.message=NSLocalizedString(@"FinalMessage",NULL);
            }else{
                alert.title = NSLocalizedString(@"Rate",NULL);
                alert.message=NSLocalizedString(@"Message",NULL);
            }
            [alert addButtonWithTitle:NSLocalizedString(@"NoThanks",NULL)];
            [alert addButtonWithTitle:NSLocalizedString(@"RemindMeLater",NULL)];
            [alert addButtonWithTitle:NSLocalizedString(@"RateItNow",NULL)];
            [alert show];
        }
        //広告表示
        //[[NADInterstitial sharedInstance] showAd];
        [ImobileSdkAds showBySpotID:@"276556"];
        
        //ADG-SSPバナー
        adgSSP=[[AdGenerLayer alloc]init];
        [self addChild:adgSSP];
    }
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSURL* url;
    switch (buttonIndex){
    case 0:
        break;
    case 1:
        break;
    case 2:
        url = [NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=869207877&mt=8&type=Purple+Software"];
        [[UIApplication sharedApplication]openURL:url];
        break;
    }
}

-(void)crisis_Schedule:(CCTime)dt
{
    bgSpLayer.position = CGPointMake(bgSpLayer.position.x+10, bgSpLayer.position.y-10);
}

//=====================
//　アチーブメント保存
//=====================
-(void)setAchievement:(NSString*)forKey
{
    //アチーブメント（タンク撃破率）セーブ
    [AchievementManeger save_Achievement_All_Rate2:forKey];
    //達成報酬付与
    NSMutableArray* achiveArray=[[NSMutableArray alloc]init];
    achiveArray=[AchievementManeger load_Achievement_All:forKey];
    for(int i=0;i<achiveArray.count;i++){
        if([[[achiveArray objectAtIndex:i]objectAtIndex:2]floatValue]>=100){//100%以上だったら
            if(![[[achiveArray objectAtIndex:i]objectAtIndex:4]boolValue]){
                //フラグを立てる（報酬済み）
                [AchievementManeger save_Achievement_Reward:i reward:true forKey:forKey];
                //ダイア付与
                [GameManager in_Out_Dia:
                        [AchievementManeger load_Achievement_Point:i forKey:forKey] addFlg:true];
                //ダイア表示更新
                [InformationLayer update_CurrencyLabel];
                //メッセージボックス
                NSString* messageTitle;
                NSString* messageText;
                if([forKey isEqualToString:@"Achievement_Tank"]){
                    messageTitle = [NSString stringWithFormat:@"%@\n %d %@",
                                                NSLocalizedString(@"Tank",NULL),
                                                [AchievementManeger load_Achievement_Value:i forKey:forKey],
                                                NSLocalizedString(@"Achievement",NULL)];
                    
                }else if([forKey isEqualToString:@"Achievement_Fortress"]){
                    messageTitle = [NSString stringWithFormat:@"%@\n %d %@",
                                                NSLocalizedString(@"Fortress",NULL),
                                                [AchievementManeger load_Achievement_Value:i forKey:forKey],
                                                NSLocalizedString(@"Achievement",NULL)];
                    
                }else if([forKey isEqualToString:@"Achievement_Stage"]){
                    messageTitle = [NSString stringWithFormat:@"%@\n %d %@",
                                                NSLocalizedString(@"Stage",NULL),
                                                [AchievementManeger load_Achievement_Value:i forKey:forKey],
                                                NSLocalizedString(@"Achievement",NULL)];
                }
                
                messageText=[NSString stringWithFormat:@"%@ %d %@",
                                                NSLocalizedString(@"Diamond",NULL),
                                                [AchievementManeger load_Achievement_Point:i forKey:forKey],
                                                NSLocalizedString(@"Get",NULL)];
                /*
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:messageTitle
                        message:[NSString stringWithFormat:@"%@ %d %@",
                                            NSLocalizedString(@"Diamond",NULL),
                                            [AchievementManeger load_Achievement_Point:i forKey:forKey],
                                            NSLocalizedString(@"Get",NULL)]
                        delegate:nil
                        cancelButtonTitle:nil
                        otherButtonTitles:NSLocalizedString(@"OK",NULL), nil];
                [alert show];
                */
                MessageLayer* msgbox=[[MessageLayer alloc]init:0];
                [msgbox setMessageBox:messageTitle message:messageText];
                [self addChild:msgbox z:10];
            }
        }
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
            if([BasicMath RadiusContainsPoint:_player.position pointB:touchLocation radius:10]){
                touchPlayer=_player;
                routeGeneLyer.player=_player;
                flg=true;
            }
        }
    }
    return flg;
}
//============================
// タッチした敵タンクを特定する
//============================
+(BOOL)isEnemy:(CGPoint)touchLocation
{
    BOOL flg=false;
    for(AnimalEnemy* _enemy in enemyArray){
        if([BasicMath RadiusContainsPoint:_enemy.position pointB:touchLocation radius:30]){
            touchEnemy=_enemy;
            flg=true;
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
+(BOOL)isEnemyCollision:(AnimalEnemy*)enemy
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
+(void)createPlayer:(CGPoint)playerPos playerNum:(int)playerNum
{
    //効果音
    [SoundManager playerSet:playerNum];

    creatPlayer=[AnimalPlayer createPlayer:playerPos playerNum:playerNum];
    [animalArray addObject:creatPlayer];
    [bgSpLayer addChild:creatPlayer z:3];
    //パーティクル
    [self setPlayerParticle:0 pos:playerPos fileName:@"playerAdding.plist"];
    
    [GameManager in_Out_Coin:playerNum addFlg:false];//コイン減
    [InformationLayer update_CurrencyLabel];
}
//============================
// 敵アニマルセット
//============================
+(void)createEnemy
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
+(void)setPlayerMissile:(PlayerMissile*)missile zOrder:(int)zOrder type:(int)type
{
    //効果音
    [SoundManager playerFireMissile:type];

    [bgSpLayer addChild:missile z:zOrder];
    [playerMissileArray addObject:missile];
}

//============================
// 敵ミサイルセット
//============================
+(void)setEnemyMissile:(EnemyMissile*)missile zOrder:(int)zOrder type:(int)type
{
    //効果音
    [SoundManager enemyFireMissile:type];
    
    [bgSpLayer addChild:missile z:zOrder];
    [enemyMissileArray addObject:missile];
}
//============================
// プレイヤー要塞セット
//============================
-(void)createPlayerFortress
{
    playerFortress=[Fortress createFortress:ccp(winSize.width/2, 30) type:0];
    [bgSpLayer addChild:playerFortress z:2];
}
//============================
// 敵要塞セット
//============================
-(void)createEnemyFortress
{
    enemyFortress=[Fortress createFortress:ccp(winSize.width/2,[GameManager getWorldSize].height-30) type:1];
    [bgSpLayer addChild:enemyFortress z:2];
}
//============================
// パーティクルセット(プレイヤー)
//============================
+(void)setPlayerParticle:(int)type pos:(CGPoint)pos fileName:(NSString*)fileName
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
+(void)setEnemyParticle:(int)type pos:(CGPoint)pos fileName:(NSString*)fileName
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
    
    CGPoint worldLocation;
    CGPoint touchLocation = [touch locationInNode:self];
    
    float offsetY = bgSpLayer.contentSize.height - winSize.height - scrollView.scrollPosition.y;
    worldLocation.x = touchLocation.x + scrollView.scrollPosition.x;
    worldLocation.y = touchLocation.y + offsetY;

    if(worldLocation.y > [GameManager getWorldSize].height / 5.0f){
        
        if([StageLevel_01 isEnemy:worldLocation]){

            CCSprite* enemyImg;
            NSString* messageTitle;
            NSString* messageText;
            
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"interface_default.plist"];

            if(touchEnemy.enemyNum==1){//ノーマル（サソリ）
                messageTitle = NSLocalizedString(@"Scorpion",NULL);
                enemyImg=[CCSprite spriteWithSpriteFrame:
                                 [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"enemy01.png"]];
            }else if(touchEnemy.enemyNum==2){//移動大：攻撃弱い（カエル）
                messageTitle = NSLocalizedString(@"Frog",NULL);
                enemyImg=[CCSprite spriteWithSpriteFrame:
                                 [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"enemy02.png"]];
            }else if(touchEnemy.enemyNum==3){//移動小：攻撃強い（ワニ）
                messageTitle = NSLocalizedString(@"Crocodile",NULL);
                enemyImg=[CCSprite spriteWithSpriteFrame:
                                 [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"enemy03.png"]];
            }
            
            messageText  = [NSString stringWithFormat:
                            @"\n    %@:%.2f \n    %@:%.2f \n    %@:%.2f \n    %@:%.2f",
                            
                            NSLocalizedString(@"Attack",NULL),
                            touchEnemy.ability_Attack*100,
                            
                            NSLocalizedString(@"Defense",NULL),
                            touchEnemy.ability_Defense*100,
                            
                            NSLocalizedString(@"Move",NULL),
                            touchEnemy.ability_Traveling*100,
                            
                            NSLocalizedString(@"Underwater",NULL),
                            touchEnemy.ability_Traveling*100*0.3];
            
            MessageLayer* msgbox=[[MessageLayer alloc]init:0];
            enemyImg.scale=0.4;
            enemyImg.position=ccp(msgbox.contentSize.width/2,msgbox.contentSize.height/2+60);
            [msgbox addChild:enemyImg];
            [msgbox setMessageBox:messageTitle message:messageText];
            [self addChild:msgbox z:10];
        }
    }
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
    
    if([StageLevel_01 isAnimal:worldLocation type:0]){//経路作成レイヤー表示
        if(![StageLevel_01 isPlayerCollision:touchPlayer]){//タッチした戦車が衝突継続中でなければ経路作成可能
            routeGeneLyer.offsetY=offsetY;
            [self addChild:routeGeneLyer z:2];
            touchPlayer.state_PathMake_flg=true;
            touchPlayer.zOrder=10;
        }
        
    //}else if(![StageLevel_01 isAnimal:worldLocation type:1]){//プレイヤー追加
    }else{
        if(worldLocation.y < [GameManager getWorldSize].height / 5.0f){
            //効果音
            [SoundManager playerSelect];
            
            playSelect=[[PlayerSelection alloc]init];
            [self addChild:playSelect z:1];
            playSelect.createPlayerPos=worldLocation;
            [playSelect setArrowVisible:offsetY];
        }
    }
}

@end
