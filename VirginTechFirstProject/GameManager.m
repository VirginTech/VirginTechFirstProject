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
bool isPauseStateChange;//変化があった

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

//GameCenterへスコアを送信
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
