//
//  AchievementManeger.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/24.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import "AchievementManeger.h"
#import "GameManager.h"
#import <GameKit/GameKit.h>

@implementation AchievementManeger

//=========================================
//アチーブメント(戦車撃破)　一括保存 ArrayWithArray (0:キーID 1:達成値 2:達成率 3:報酬ポイント 4:報酬Flg)
//=========================================
+(void)save_Achievement_Tank_All:(NSMutableArray*)array
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:array forKey:@"Achievement_Tank"];
	[userDefault synchronize];
}
//=========================================
//アチーブメント(戦車撃破)　一括取得 ArrayWithArray (0:キーID 1:達成値 2:達成率 3:報酬ポイント 4:報酬Flg)
//=========================================
+(NSMutableArray*)load_Achievement_Tank_All
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
	NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    tmpArray = [userDefault objectForKey:@"Achievement_Tank"];
    for(int i=0;i<[tmpArray count];i++){//コピー
		[array addObject:[tmpArray objectAtIndex:i]];
	}
    return array;
}
//=========================================
//アチーブメント(戦車撃破)index番目の達成値(要素番号1)を取得
//=========================================
+(int)load_Achievement_Tank_Value:(int)index
{
    int value;
    NSMutableArray* array=[[NSMutableArray alloc]init];
    array=[self load_Achievement_Tank_All];
    value=[[[array objectAtIndex:index]objectAtIndex:1]intValue];
    return value;
}
//=========================================
//アチーブメント(戦車撃破)index番目の達成率(要素番号2)を取得
//=========================================
+(float)load_Achievement_Tank_Rate:(int)index
{
    float rate;
    NSMutableArray* array=[[NSMutableArray alloc]init];
    array=[self load_Achievement_Tank_All];
    rate=[[[array objectAtIndex:index]objectAtIndex:2]floatValue];
    return rate;
}
//=========================================
//アチーブメント(戦車撃破)index番目の達成率(要素番号2)を保存
//=========================================
+(void)save_Achievement_Tank_Rate:(int)index
{
    float rate=((float)[GameManager load_Aggregate_Tank]/(float)[self load_Achievement_Tank_Value:index])*100.0f;
    if(rate<=100){
        NSMutableArray* allArray=[[NSMutableArray alloc]init];
        NSMutableArray *indexArray = [[NSMutableArray alloc] init];
        allArray=[self load_Achievement_Tank_All];
        for(int i=0;i<[[allArray objectAtIndex:index]count];i++){//コピー
            [indexArray addObject:[[allArray objectAtIndex:index]objectAtIndex:i]];
        }
        [indexArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithFloat:rate]];
        [allArray replaceObjectAtIndex:index withObject:indexArray];
        [self save_Achievement_Tank_All:allArray];
    }
}
//=========================================
//アチーブメント(戦車撃破) 全ての達成率(要素番号2)を保存
//=========================================
+(void)save_Achievement_All_Tank_Rate
{
    for(int i=0;i<[self load_Achievement_Tank_All].count;i++){
        [self save_Achievement_Tank_Rate:i];
    }
}
//=========================================
//アチーブメント(戦車撃破) 全ての達成率(要素番号2)を保存　(推奨)
//=========================================
+(void)save_Achievement_All_Tank_Rate2
{
    NSMutableArray* allArray=[[NSMutableArray alloc]init];
    allArray=[self load_Achievement_Tank_All];
    for(int i=0;i<allArray.count;i++){
        float rate=((float)[GameManager load_Aggregate_Tank]/(float)[self load_Achievement_Tank_Value:i])*100.0f;
        if(rate<=100){
            NSMutableArray* tmpArray=[[NSMutableArray alloc]init];
            NSMutableArray* indexArray=[[NSMutableArray alloc]init];
            tmpArray=[allArray objectAtIndex:i];
            for(int j=0;j<tmpArray.count;j++){//コピー
                [indexArray addObject:[tmpArray objectAtIndex:j]];
            }
            [indexArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithFloat:rate]];
            [allArray replaceObjectAtIndex:i withObject:indexArray];
        }
    }
    [self save_Achievement_Tank_All:allArray];
}
//=========================================
//アチーブメント(戦車撃破)index番目の報酬ポイント(要素番号3)を取得
//=========================================
+(int)load_Achievement_Tank_Point:(int)index
{
    int point;
    NSMutableArray* array=[[NSMutableArray alloc]init];
    array=[self load_Achievement_Tank_All];
    point=[[[array objectAtIndex:index]objectAtIndex:3]intValue];
    return point;
}
//=========================================
//アチーブメント(戦車撃破)index番目の報酬Flg(要素番号4)を取得
//=========================================
+(bool)load_Achievement_Tank_Reward:(int)index
{
    bool reward;
    NSMutableArray* array=[[NSMutableArray alloc]init];
    array=[self load_Achievement_Tank_All];
    reward=[[[array objectAtIndex:index]objectAtIndex:4]boolValue];
    return reward;
}
//=========================================
//アチーブメント(戦車撃破)index番目の報酬Flg(要素番号4)を保存
//=========================================
+(void)save_Achievement_Tank_Reward:(int)index reward:(bool)reward
{
    NSMutableArray* allArray=[[NSMutableArray alloc]init];
    NSMutableArray *indexArray = [[NSMutableArray alloc] init];
    allArray=[self load_Achievement_Tank_All];
    for(int i=0;i<[[allArray objectAtIndex:index]count];i++){//コピー
        [indexArray addObject:[[allArray objectAtIndex:index]objectAtIndex:i]];
    }
    [indexArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithBool:reward]];
    [allArray replaceObjectAtIndex:index withObject:indexArray];
    [self save_Achievement_Tank_All:allArray];
}


//=========================================
//GameCenterへアチーブメントを送信
//=========================================
+(void)reportAchievement_GameCenter:(float)percent
{
    GKAchievement *achievement = [[GKAchievement alloc]initWithIdentifier:
                                  @"VirginTechFirstProject_Achievement_01"];
    if (achievement){
        achievement.percentComplete = percent;
        [achievement reportAchievementWithCompletionHandler:^(NSError *error){
            if (error != nil){
                NSLog(@"Error in reporting achievements: %@", error);
            }
        }];
    }
}

@end
