//
//  GameManager.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/01.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import "GameManager.h"
#import <GameKit/GameKit.h>

@implementation GameManager

//==============
// グローバル定数
//==============
const int STAGE_LEVEL_MAX=100;//ステージレヴェル数
const int COIN_VAL=0;//コイン初期値(3000)
const int DIA_VAL=0;//ダイア初期値(5)

//===========
// メモリ内
//===========
int locale;//1:英語 2:日本語
int deviceType;// 1:iPhone5 2:iPhone4 3:iPad2
float osVersion;//OSバージョン
int stageLevel;//ステージレベル
CGSize worldSize;//ワールドサイズ

bool isPlaying;//プレイ中かどうか(true:プレイ中)
bool isPauseing;//ポーズ中か(true:ポーズ中)
bool isPauseStateChange;//ポーズに変化があった
bool isActive;//アクティブ状態か？

//デバイス取得／登録
+(void)setDevice:(int)type{
    deviceType=type;
}
+(int)getDevice{
    return deviceType;
}
//ロケール登録
+(void)setLocale:(int)value{
    locale=value;
}
+(int)getLocale{
    return locale;
}
//OSバージョン
+(void)setOsVersion:(float)version{
    osVersion=version;
}
+(float)getOsVersion{
    return osVersion;
}

//ステージレベル取得／登録
+(void)setStageLevel:(int)level{
    stageLevel=level;
}
+(int)getStageLevel{
    return stageLevel;
}
//ワールドサイズ
+(void)setWorldSize:(CGSize)size{
    worldSize=size;
}
+(CGSize)getWorldSize{
    return worldSize;
}

//プレイ中かどうか
+(void)setPlaying:(bool)flg{
    isPlaying=flg;
}
+(bool)getPlaying{
    return isPlaying;
}
//ポーズ中かどうか
+(void)setPauseing:(bool)flg{
    isPauseing=flg;
}
+(bool)getPauseing{
    return isPauseing;
}
+(void)setPauseStateChange:(bool)flg{
    isPauseStateChange=flg;
}
+(bool)getPauseStateChange{
    return isPauseStateChange;
}
//画面がアクティブかどうか
+(void)setActive:(bool)flg{
    isActive=flg;
}
+(bool)getActive{
    return isActive;
}

//=========================================
//　ハイスコアの取得
//=========================================
+(long)load_HighScore
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    long highScore=[[userDefault objectForKey:@"HighScore"]longValue];
    return highScore;
}
//=========================================
//　ハイスコアの保存
//=========================================
+(void)save_HighScore:(long)score
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSNumber* scoreNum=[NSNumber numberWithLong:score];
    [userDefault setObject:scoreNum forKey:@"HighScore"];
}

//=========================================
//通貨の取得（配列で一括） 0:コイン 1:ダイア
//=========================================
+(NSMutableArray*)load_Currency_All
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
	NSMutableArray *array = [[NSMutableArray alloc] init];
    array = [userDefault objectForKey:@"Currency"];
    return array;
}
//=========================================
//通貨のセーブ（一括保存） 0:コイン 1:ダイア
//=========================================
+(void)save_Currency_All:(int)coin dia:(int)dia
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSArray* array=[NSArray arrayWithObjects:[NSNumber numberWithInt:coin],[NSNumber numberWithInt:dia],nil];
    [userDefault setObject:array forKey:@"Currency"];
	[userDefault synchronize];
}
//=========================================
//　コインの取得
//=========================================
+(int)load_Currency_Coin
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    array=[self load_Currency_All];
    int coin=[[array objectAtIndex:0]intValue];
    return coin;
}
//=========================================
//　ダイアの取得
//=========================================
+(int)load_Currency_Dia
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    array=[self load_Currency_All];
    int dia=[[array objectAtIndex:1]intValue];
    return dia;
}
//=========================================
//　コインの保存
//=========================================
+(void)save_Currency_Coin:(int)coin
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    NSMutableArray* tmpArray=[[NSMutableArray alloc]init];
    tmpArray=[self load_Currency_All];
    for(int i=0;i<tmpArray.count;i++){//コピー
        [array addObject:[tmpArray objectAtIndex:i]];
    }
    [array replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:coin]];
    [self save_Currency_All:[[array objectAtIndex:0]intValue] dia:[[array objectAtIndex:1]intValue]];
}
//=========================================
//　ダイアの保存
//=========================================
+(void)save_Currency_Dia:(int)dia
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    NSMutableArray* tmpArray=[[NSMutableArray alloc]init];
    tmpArray=[self load_Currency_All];
    for(int i=0;i<tmpArray.count;i++){//コピー
        [array addObject:[tmpArray objectAtIndex:i]];
    }
    [array replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:dia]];
    [self save_Currency_All:[[array objectAtIndex:0]intValue] dia:[[array objectAtIndex:1]intValue]];
}
//=========================================
//　コインの入出力
//=========================================
+(void)in_Out_Coin:(int)quantity addFlg:(bool)addFlg //true:足す false:引く
{
    if(addFlg){
        [GameManager save_Currency_Coin:[GameManager load_Currency_Coin] + quantity];
    }else{
        [GameManager save_Currency_Coin:[GameManager load_Currency_Coin] - quantity];
    }
}
//=========================================
//　ダイアの入出力
//=========================================
+(void)in_Out_Dia:(int)quantity addFlg:(bool)addFlg //true:足す false:引く
{
    if(addFlg){
        [GameManager save_Currency_Dia:[GameManager load_Currency_Dia] + quantity];
    }else{
        [GameManager save_Currency_Dia:[GameManager load_Currency_Dia] - quantity];
    }
}

//=========================================
//基礎集計 一括保存（0:タンク撃破数 1:敵要塞撃破数 2:最高レベル数 3:ステージ数）
//=========================================
+(void)save_Aggregate_All:(int)tank fortress:(int)fortress level:(int)level stage:(int)stage
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSArray* array=[NSArray arrayWithObjects:[NSNumber numberWithInt:tank],
                                                        [NSNumber numberWithInt:fortress],
                                                        [NSNumber numberWithInt:level],
                                                        [NSNumber numberWithInt:stage],nil];
    [userDefault setObject:array forKey:@"Aggregate"];
	[userDefault synchronize];
}
//=========================================
//基礎集計 一括取得（0:タンク撃破数 1:敵要塞撃破数 2:最高レベル数 3:ステージ数）
//=========================================
+(NSMutableArray*)load_Aggregate_All
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
	NSMutableArray *array = [[NSMutableArray alloc] init];
    array = [userDefault objectForKey:@"Aggregate"];
    return array;
}
//=========================================
//　タンク撃破数の取得
//=========================================
+(int)load_Aggregate_Tank
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    array=[self load_Aggregate_All];
    int tank=[[array objectAtIndex:0]intValue];
    return tank;
}
//=========================================
//　要塞撃破数の取得
//=========================================
+(int)load_Aggregate_Fortress
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    array=[self load_Aggregate_All];
    int fortress=[[array objectAtIndex:1]intValue];
    return fortress;
}
//=========================================
//　最高レベルアップ数の取得
//=========================================
+(int)load_Aggregate_Level
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    array=[self load_Aggregate_All];
    int level=[[array objectAtIndex:2]intValue];
    return level;
}
//=========================================
//　ステージクリア数の取得
//=========================================
+(int)load_Aggregate_Stage
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    array=[self load_Aggregate_All];
    int stage=[[array objectAtIndex:3]intValue];
    return stage;
}
//=========================================
//　タンク撃破数の保存
//=========================================
+(void)save_Aggregate_Tank:(int)tank
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    NSMutableArray* tmpArray=[[NSMutableArray alloc]init];
    tmpArray=[self load_Aggregate_All];
    for(int i=0;i<tmpArray.count;i++){//コピー
        [array addObject:[tmpArray objectAtIndex:i]];
    }
    [array replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:tank]];
    [self save_Aggregate_All:[[array objectAtIndex:0]intValue]
                                    fortress:[[array objectAtIndex:1]intValue]
                                    level:[[array objectAtIndex:2]intValue]
                                    stage:[[array objectAtIndex:3]intValue]];
}
//=========================================
//　要塞撃破数の保存
//=========================================
+(void)save_Aggregate_Fortress:(int)fortress
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    NSMutableArray* tmpArray=[[NSMutableArray alloc]init];
    tmpArray=[self load_Aggregate_All];
    for(int i=0;i<tmpArray.count;i++){//コピー
        [array addObject:[tmpArray objectAtIndex:i]];
    }
    [array replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:fortress]];
    [self save_Aggregate_All:[[array objectAtIndex:0]intValue]
                                    fortress:[[array objectAtIndex:1]intValue]
                                    level:[[array objectAtIndex:2]intValue]
                                    stage:[[array objectAtIndex:3]intValue]];
}
//=========================================
//　最高レベルアップ数の保存
//=========================================
+(void)save_Aggregate_Level:(int)level
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    NSMutableArray* tmpArray=[[NSMutableArray alloc]init];
    tmpArray=[self load_Aggregate_All];
    for(int i=0;i<tmpArray.count;i++){//コピー
        [array addObject:[tmpArray objectAtIndex:i]];
    }
    [array replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:level]];
    [self save_Aggregate_All:[[array objectAtIndex:0]intValue]
                                    fortress:[[array objectAtIndex:1]intValue]
                                    level:[[array objectAtIndex:2]intValue]
                                    stage:[[array objectAtIndex:3]intValue]];
}
//=========================================
//　ステージクリア数の保存
//=========================================
+(void)save_Aggregate_Stage:(int)stage
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    NSMutableArray* tmpArray=[[NSMutableArray alloc]init];
    tmpArray=[self load_Aggregate_All];
    for(int i=0;i<tmpArray.count;i++){//コピー
        [array addObject:[tmpArray objectAtIndex:i]];
    }
    [array replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:stage]];
    [self save_Aggregate_All:[[array objectAtIndex:0]intValue]
                                    fortress:[[array objectAtIndex:1]intValue]
                                    level:[[array objectAtIndex:2]intValue]
                                    stage:[[array objectAtIndex:3]intValue]];
}
//=========================================
//ステージクリア状態の保存(0:未達成 1:星1つ 2:星2つ 3:星3つ)
//=========================================
+(void)save_StageClear_State:(int)stageNum rate:(int)rate
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
	NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray* tmpArray=[[NSMutableArray alloc]init];
    tmpArray = [userDefault objectForKey:@"StageClearState"];
    for(int i=0;i<tmpArray.count;i++){//コピー
        [array addObject:[tmpArray objectAtIndex:i]];
    }
    [array replaceObjectAtIndex:stageNum-1 withObject:[NSNumber numberWithInt:rate]];
    [userDefault setObject:array forKey:@"StageClearState"];
    [userDefault synchronize];
}
//=========================================
//ステージクリア状態の取得(0:未達成 1:星1つ 2:星2つ 3:星3つ)
//=========================================
+(int)load_StageClear_State:(int)stageNum
{
    int rate;
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
	NSMutableArray *array = [[NSMutableArray alloc] init];
    array = [userDefault objectForKey:@"StageClearState"];
    rate=[[array objectAtIndex:stageNum-1]intValue];
    return rate;
}

//=========================================
//　ログイン日の取得
//=========================================
+(NSDate*)load_Login_Date
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSDate* date =[userDefault objectForKey:@"LoginDate"];
    return date;
}

//=========================================
//　ログイン日の保存
//=========================================
+(void)save_login_Date:(NSDate*)date
{
    //日付のみに変換
    NSCalendar *calen = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *comps = [calen components:unitFlags fromDate:date];
    //[comps setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];//GMTで貫く
    NSDate *date_ = [calen dateFromComponents:comps];
    
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:date_ forKey:@"LoginDate"];
}


//=========================================
//GameCenterへスコアを送信
//=========================================
+(void)submitScore_GameCenter:(NSInteger)score
{
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:@"VirginTechFirstProject_Leaderboard_2"];
    NSInteger scoreR = score;
    scoreReporter.value = scoreR;
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (error != nil){
            NSLog(@"Error in reporting score %@",error);
        }
    }];
}
//=========================================
//GameCenterからハイスコアを取得
//=========================================
+(void)get_HighScore_GameCenter
{
    NSArray* playerID = [[NSArray alloc] initWithObjects:[GKLocalPlayer localPlayer].playerID, nil];
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] initWithPlayerIDs:playerID];
    
    if (leaderboardRequest != nil) {
        leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
        leaderboardRequest.category = @"VirginTechFirstProject_Leaderboard";
        leaderboardRequest.range = NSMakeRange(1,1);//ハイスコア
        [leaderboardRequest loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
            if (error != nil) {
                NSLog(@"error %@",error);
            }
            NSInteger highScore;
            if (scores != nil) {
                highScore = ((GKScore *)[scores objectAtIndex:0]).value;
            } else {
                highScore = 0;// 初回プレイ
            }
        }];
    }
}

@end
