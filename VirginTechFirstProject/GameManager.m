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

//===========
// メモリ内
//===========
int deviceType;// 1:iPhone5 2:iPhone4 3:iPad2
int stageLevel;//ステージレベル
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
//ステージレベル取得／登録
+(void)setStageLevel:(int)level{
    stageLevel=level;
}
+(int)getStageLevel{
    return stageLevel;
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
//GameCenterへスコアを送信
//=========================================
+(void)submitScore_GameCenter:(NSInteger)score{
    
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:@"VirginTechFirstProject_Leaderboard"];
    NSInteger scoreR = score;
    scoreReporter.value = scoreR;
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (error != nil){
            NSLog(@"error %@",error);
        }
    }];
}

@end
