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
#import "IAdLayer.h"
#import "InformationLayer.h"
#import "AchievementManeger.h"
#import "Fortress.h"

@implementation StageLevel_01

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
Fortress* playerFortress;
Fortress* enemyFortress;
int enemyCount;

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
    [GameManager setWorldSize:CGSizeMake(winSize.width, 600+((stageLevel-1)*30))];

    UIImage *image = [UIImage imageNamed:@"bgLayer.png"];
    UIGraphicsBeginImageContext(CGSizeMake(winSize.width,[GameManager getWorldSize].height));
    [image drawInRect:CGRectMake(0, 0, winSize.width,[GameManager getWorldSize].height)];
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
    line.position=CGPointMake(0, [GameManager getWorldSize].height / 5.0f);
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
    //要塞陣地
    [self createPlayerFortress];
    [self createEnemyFortress];
    //植樹
    [self setTreePlanting];
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
        [bgSpLayer addChild:leaf z:3];
    }
}

-(void)createEnemy_Schedule:(CCTime)dt
{
    if(enemyCount<=[GameManager getStageLevel]*3){
        if(enemyCount%3==0){
            [StageLevel_01 createEnemy];
            [StageLevel_01 createEnemy];
        }else if(enemyCount%5==0){
            [StageLevel_01 createEnemy];
            [StageLevel_01 createEnemy];
            [StageLevel_01 createEnemy];
        }else if(enemyCount%19==0){
            [StageLevel_01 createEnemy];
            [StageLevel_01 createEnemy];
            [StageLevel_01 createEnemy];
            [StageLevel_01 createEnemy];
        }else if(enemyCount%29==0){
            [StageLevel_01 createEnemy];
            [StageLevel_01 createEnemy];
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
                [removePlayerMissileArray addObject:missile];
                enemyFortress.ability_Defense -= missile.ability_Attack;
                if(enemyFortress.ability_Defense<=0){
                    [bgSpLayer removeChild:enemyFortress cleanup:YES];
                    [self unscheduleAllSelectors];
                    [GameManager setPauseStateChange:true];
                    [GameManager setPauseing:true];
                    [NaviLayer setStageEndingScreen:true];
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
                        [GameManager save_Aggregate_Stage:[GameManager load_Aggregate_Stage]+1];
                    }
                    //アチーブメント保存
                    [self setAchievement:@"Achievement_Stage"];
                    //ステージクリア状態のセーブ
                    float fortRemainPower=(100/playerFortress.maxLife)*playerFortress.ability_Defense;
                    if(fortRemainPower>=80.0f){
                        if([GameManager load_StageClear_State:[GameManager getStageLevel]]<3){
                            [GameManager save_StageClear_State:[GameManager getStageLevel] rate:3];
                        }
                    }else if(fortRemainPower>=50.0f){
                        if([GameManager load_StageClear_State:[GameManager getStageLevel]]<2){
                            [GameManager save_StageClear_State:[GameManager getStageLevel] rate:2];
                        }
                    }else{
                        if([GameManager load_StageClear_State:[GameManager getStageLevel]]<1){
                            [GameManager save_StageClear_State:[GameManager getStageLevel] rate:1];
                        }
                    }
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
                [removeEnemyMissileArray addObject:missile];
                playerFortress.ability_Defense -= missile.ability_Attack;
                if(playerFortress.ability_Defense<=0){
                    [bgSpLayer removeChild:playerFortress cleanup:YES];
                    [self unscheduleAllSelectors];
                    [GameManager setPauseStateChange:true];
                    [GameManager setPauseing:true];
                    [NaviLayer setStageEndingScreen:false];
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
                if([forKey isEqualToString:@"Achievement_Tank"]){
                    messageTitle = [NSString stringWithFormat:@"敵タンク %d 撃破達成！",
                                                [AchievementManeger load_Achievement_Value:i forKey:forKey]];
                }else if([forKey isEqualToString:@"Achievement_Fortress"]){
                    messageTitle = [NSString stringWithFormat:@"敵要塞 %d 撃破達成！",
                                                [AchievementManeger load_Achievement_Value:i forKey:forKey]];
                }else if([forKey isEqualToString:@"Achievement_Stage"]){
                    messageTitle = [NSString stringWithFormat:@"ステージレヴェル %d 達成！",
                                                [AchievementManeger load_Achievement_Value:i forKey:forKey]];
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:messageTitle
                        message:[NSString stringWithFormat:@"ダイヤモンドを %d 入手しました！",
                                            [AchievementManeger load_Achievement_Point:i forKey:forKey]]
                        delegate:nil
                        cancelButtonTitle:nil
                        otherButtonTitles:@"O K", nil];
                [alert show];
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
            if([BasicMath RadiusContainsPoint:_player.position pointB:touchLocation radius:50]){
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
+(void)createPlayer:(CGPoint)playerPos playerNum:(int)playerNum{
    
    creatPlayer=[AnimalPlayer createPlayer:playerPos playerNum:playerNum];
    [animalArray addObject:creatPlayer];
    [bgSpLayer addChild:creatPlayer z:2];

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
//============================
// プレイヤー要塞セット
//============================
-(void)createPlayerFortress
{
    playerFortress=[Fortress createFortress:ccp(winSize.width/2, 30)];
    [bgSpLayer addChild:playerFortress z:0];
}
//============================
// 敵要塞セット
//============================
-(void)createEnemyFortress
{
    enemyFortress=[Fortress createFortress:ccp(winSize.width/2,[GameManager getWorldSize].height-30)];
    [bgSpLayer addChild:enemyFortress z:0];
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{

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
            [self addChild:routeGeneLyer z:1];
            touchPlayer.state_PathMake_flg=true;
        }
        
    }else if(![StageLevel_01 isAnimal:worldLocation type:1]){//プレイヤー追加
        if(worldLocation.y < [GameManager getWorldSize].height / 5.0f){
            playSelect=[[PlayerSelection alloc]init];
            [self addChild:playSelect z:2];
            playSelect.createPlayerPos=worldLocation;
            [playSelect setArrowVisible:offsetY];
        }
    }
}

@end
