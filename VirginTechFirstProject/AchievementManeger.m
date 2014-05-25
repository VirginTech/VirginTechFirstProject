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
//アチーブメント　一括保存 ArrayWithArray (0:キーID 1:達成値 2:達成率 3:報酬ポイント 4:報酬Flg)
//=========================================
+(void)save_Achievement_All:(NSMutableArray*)array forKey:(NSString*)forKey
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:array forKey:forKey];
	[userDefault synchronize];
}
//=========================================
//アチーブメント　一括取得 ArrayWithArray (0:キーID 1:達成値 2:達成率 3:報酬ポイント 4:報酬Flg)
//=========================================
+(NSMutableArray*)load_Achievement_All:(NSString*)forKey
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
	NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    tmpArray = [userDefault objectForKey:forKey];
    for(int i=0;i<[tmpArray count];i++){//コピー
		[array addObject:[tmpArray objectAtIndex:i]];
	}
    return array;
}
//=========================================
//アチーブメントindex番目の達成値(要素番号1)を取得
//=========================================
+(int)load_Achievement_Value:(int)index forKey:(NSString*)forKey
{
    int value;
    NSMutableArray* array=[[NSMutableArray alloc]init];
    array=[self load_Achievement_All:forKey];
    value=[[[array objectAtIndex:index]objectAtIndex:1]intValue];
    return value;
}
//=========================================
//アチーブメントindex番目の達成率(要素番号2)を取得
//=========================================
+(float)load_Achievement_Rate:(int)index forKey:(NSString*)forKey
{
    float rate;
    NSMutableArray* array=[[NSMutableArray alloc]init];
    array=[self load_Achievement_All:forKey];
    rate=[[[array objectAtIndex:index]objectAtIndex:2]floatValue];
    return rate;
}
//=========================================
//アチーブメントindex番目の達成率(要素番号2)を保存
//=========================================
+(void)save_Achievement_Rate:(int)index forKey:(NSString*)forKey
{
    float rate;
    if([forKey isEqualToString:@"Achievement_Tank"]){
        rate=((float)[GameManager load_Aggregate_Tank]/(float)[self load_Achievement_Value:index forKey:forKey])*100.0f;
    }else if([forKey isEqualToString:@"Achievement_Level"]){
        rate=((float)[GameManager load_Aggregate_Level]/(float)[self load_Achievement_Value:index forKey:forKey])*100.0f;
    }else if([forKey isEqualToString:@"Achievement_Fortress"]){
        rate=((float)[GameManager load_Aggregate_Fortress]/(float)[self load_Achievement_Value:index forKey:forKey])*100.0f;
    }else if([forKey isEqualToString:@"Achievement_Stage"]){
        rate=((float)[GameManager load_Aggregate_Stage]/(float)[self load_Achievement_Value:index forKey:forKey])*100.0f;
    }
    if(rate<=100){
        NSMutableArray* allArray=[[NSMutableArray alloc]init];
        NSMutableArray *indexArray = [[NSMutableArray alloc] init];
        allArray=[self load_Achievement_All:forKey];
        for(int i=0;i<[[allArray objectAtIndex:index]count];i++){//コピー
            [indexArray addObject:[[allArray objectAtIndex:index]objectAtIndex:i]];
        }
        [indexArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithFloat:rate]];
        [allArray replaceObjectAtIndex:index withObject:indexArray];
        [self save_Achievement_All:allArray forKey:forKey];
    }
}
//=========================================
//アチーブメント 全ての達成率(要素番号2)を保存
//=========================================
+(void)save_Achievement_All_Rate:(NSString*)forKey
{
    for(int i=0;i<[self load_Achievement_All:forKey].count;i++){
        [self save_Achievement_Rate:i forKey:forKey];
    }
}
//=========================================
//アチーブメント 全ての達成率(要素番号2)を保存　(推奨)
//=========================================
+(void)save_Achievement_All_Rate2:(NSString*)forKey
{
    float rate;
    NSMutableArray* allArray=[[NSMutableArray alloc]init];
    allArray=[self load_Achievement_All:forKey];
    for(int i=0;i<allArray.count;i++){
        if([forKey isEqualToString:@"Achievement_Tank"]){
            rate=((float)[GameManager load_Aggregate_Tank]/(float)[self load_Achievement_Value:i forKey:forKey])*100.0f;
        }else if([forKey isEqualToString:@"Achievement_Level"]){
            rate=((float)[GameManager load_Aggregate_Level]/(float)[self load_Achievement_Value:i forKey:forKey])*100.0f;
        }else if([forKey isEqualToString:@"Achievement_Fortress"]){
            rate=((float)[GameManager load_Aggregate_Fortress]/(float)[self load_Achievement_Value:i forKey:forKey])*100.0f;
        }else if([forKey isEqualToString:@"Achievement_Stage"]){
            rate=((float)[GameManager load_Aggregate_Stage]/(float)[self load_Achievement_Value:i forKey:forKey])*100.0f;
        }
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
    [self save_Achievement_All:allArray forKey:forKey];
}
//=========================================
//アチーブメントindex番目の報酬ポイント(要素番号3)を取得
//=========================================
+(int)load_Achievement_Point:(int)index forKey:(NSString*)forKey
{
    int point;
    NSMutableArray* array=[[NSMutableArray alloc]init];
    array=[self load_Achievement_All:forKey];
    point=[[[array objectAtIndex:index]objectAtIndex:3]intValue];
    return point;
}
//=========================================
//アチーブメントindex番目の報酬Flg(要素番号4)を取得
//=========================================
+(bool)load_Achievement_Reward:(int)index forKey:(NSString*)forKey
{
    bool reward;
    NSMutableArray* array=[[NSMutableArray alloc]init];
    array=[self load_Achievement_All:forKey];
    reward=[[[array objectAtIndex:index]objectAtIndex:4]boolValue];
    return reward;
}
//=========================================
//アチーブメントindex番目の報酬Flg(要素番号4)を保存
//=========================================
+(void)save_Achievement_Reward:(int)index reward:(bool)reward forKey:(NSString*)forKey
{
    NSMutableArray* allArray=[[NSMutableArray alloc]init];
    NSMutableArray *indexArray = [[NSMutableArray alloc] init];
    allArray=[self load_Achievement_All:forKey];
    for(int i=0;i<[[allArray objectAtIndex:index]count];i++){//コピー
        [indexArray addObject:[[allArray objectAtIndex:index]objectAtIndex:i]];
    }
    [indexArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithBool:reward]];
    [allArray replaceObjectAtIndex:index withObject:indexArray];
    [self save_Achievement_All:allArray forKey:forKey];
}

//=========================================
//GameCenterへアチーブメントを送信
//=========================================
+(void)reportAchievement_GameCenter:(float)percent identifier:(NSString*)identifier
{
    GKAchievement *achievement = [[GKAchievement alloc]initWithIdentifier:identifier];
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
