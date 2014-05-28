//
//  InitializeManager.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/20.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import "InitializeManager.h"
#import "GameManager.h"
#import "ObjectManager.h"
#import "AchievementManeger.h"

@implementation InitializeManager

NSString *appDomain;
NSDictionary *dict;

+(void)initialize_All
{
    //各種能力の取得
    appDomain = [[NSBundle mainBundle] bundleIdentifier];
    dict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:appDomain];

    [self initialize_Object];
    [self initialize_Currency];
    [self initialize_HighScore];
    [self initialize_Aggregate];
    [self initialize_Achievement_Tank];
    [self initialize_Achievement_Level];
}

+(void)initialize_Object
{
    //なければ(初回)とりあえず初期値をセーブ
    if([dict valueForKey:@"player01"]==nil){
        [ObjectManager save_Object_Ability_All:@"player01" level:1 attack:1.0 defense:15.0 traveling:0.20 build:1];
    }
    if([dict valueForKey:@"player02"]==nil){
        [ObjectManager save_Object_Ability_All:@"player02" level:1 attack:1.0 defense:10.0 traveling:0.25 build:2];
    }
    if([dict valueForKey:@"player03"]==nil){
        [ObjectManager save_Object_Ability_All:@"player03" level:1 attack:1.5 defense:15.0 traveling:0.15 build:3];
    }
    if([dict valueForKey:@"player04"]==nil){
        [ObjectManager save_Object_Ability_All:@"player04" level:1 attack:2.0 defense:20.0 traveling:0.10 build:4];
    }
    if([dict valueForKey:@"player05"]==nil){
        [ObjectManager save_Object_Ability_All:@"player05" level:1 attack:3.0 defense:25.0 traveling:0.05 build:5];
    }
}

+(void)initialize_Currency
{
    //なければ(初回)とりあえず初期値をセーブ
    if([dict valueForKey:@"Currency"]==nil){
        [GameManager save_Currency_All:100 dia:5];
    }
}

+(void)initialize_HighScore
{
    //なければ(初回)とりあえず初期値をセーブ
    if([dict valueForKey:@"HighScore"]==nil){
        [GameManager save_HighScore:0];
    }
}

+(void)initialize_Aggregate
{
    //なければ(初回)とりあえず初期値をセーブ
    if([dict valueForKey:@"Aggregate"]==nil){
        [GameManager save_Aggregate_All:0 fortress:0 level:0 stage:0];
    }
}

//===================================
//アチーブメント(戦車撃破) 0:キーID 1:達成値 2:達成率 3:報酬ポイント 4:報酬Flg
//===================================
+(void)initialize_Achievement_Tank
{
    //なければ(初回)とりあえず初期値をセーブ
    if([dict valueForKey:@"Achievement_Tank"]==nil){
        NSMutableArray* array=[[NSMutableArray alloc]init];
        NSArray* tankArray;
        
        tankArray=[NSArray arrayWithObjects:@"FirstProject_Achievement_Tank_005",
                    [NSNumber numberWithInt:5],
                    [NSNumber numberWithFloat:0.0],
                    [NSNumber numberWithInt:1],
                    [NSNumber numberWithBool:false],nil];
        [array addObject:tankArray];
        
        tankArray=[NSArray arrayWithObjects:@"FirstProject_Achievement_Tank_010",
                   [NSNumber numberWithInt:10],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:1],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tankArray];

        tankArray=[NSArray arrayWithObjects:@"FirstProject_Achievement_Tank_020",
                   [NSNumber numberWithInt:20],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:2],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tankArray];

        tankArray=[NSArray arrayWithObjects:@"FirstProject_Achievement_Tank_050",
                   [NSNumber numberWithInt:50],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:3],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tankArray];

        tankArray=[NSArray arrayWithObjects:@"FirstProject_Achievement_Tank_070",
                   [NSNumber numberWithInt:70],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:3],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tankArray];

        tankArray=[NSArray arrayWithObjects:@"FirstProject_Achievement_Tank_100",
                   [NSNumber numberWithInt:100],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:5],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tankArray];

        tankArray=[NSArray arrayWithObjects:@"FirstProject_Achievement_Tank_150",
                   [NSNumber numberWithInt:150],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:5],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tankArray];

        tankArray=[NSArray arrayWithObjects:@"FirstProject_Achievement_Tank_200",
                   [NSNumber numberWithInt:200],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:5],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tankArray];

        tankArray=[NSArray arrayWithObjects:@"FirstProject_Achievement_Tank_250",
                   [NSNumber numberWithInt:250],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:5],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tankArray];

        tankArray=[NSArray arrayWithObjects:@"FirstProject_Achievement_Tank_300",
                   [NSNumber numberWithInt:300],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:10],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tankArray];
        
        tankArray=[NSArray arrayWithObjects:@"FirstProject_Achievement_Tank_400",
                   [NSNumber numberWithInt:400],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:10],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tankArray];
        
        tankArray=[NSArray arrayWithObjects:@"FirstProject_Achievement_Tank_500",
                   [NSNumber numberWithInt:500],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:10],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tankArray];

        [AchievementManeger save_Achievement_All:array forKey:@"Achievement_Tank"];
    }
}

//===================================
//アチーブメント(レベルアップ) 0:キーID 1:達成値 2:達成率 3:報酬ポイント 4:報酬Flg
//===================================
+(void)initialize_Achievement_Level
{
    //なければ(初回)とりあえず初期値をセーブ
    if([dict valueForKey:@"Achievement_Level"]==nil){
        NSMutableArray* array=[[NSMutableArray alloc]init];
        NSArray* tmpArray;
        
        tmpArray=[NSArray arrayWithObjects:@"FirstProject_Achievement_Level_002",
                   [NSNumber numberWithInt:1],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:1],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tmpArray];
        
        tmpArray=[NSArray arrayWithObjects:@"FirstProject_Achievement_Level_005",
                   [NSNumber numberWithInt:4],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:2],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tmpArray];
        
        tmpArray=[NSArray arrayWithObjects:@"FirstProject_Achievement_Level_010",
                   [NSNumber numberWithInt:9],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:3],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tmpArray];
        
        tmpArray=[NSArray arrayWithObjects:@"FirstProject_Achievement_Level_020",
                   [NSNumber numberWithInt:19],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:5],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tmpArray];
        
        tmpArray=[NSArray arrayWithObjects:@"FirstProject_Achievement_Level_030",
                   [NSNumber numberWithInt:29],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:5],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tmpArray];
        
        tmpArray=[NSArray arrayWithObjects:@"FirstProject_Achievement_Level_040",
                   [NSNumber numberWithInt:39],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:5],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tmpArray];

        tmpArray=[NSArray arrayWithObjects:@"FirstProject_Achievement_Level_050",
                  [NSNumber numberWithInt:49],
                  [NSNumber numberWithFloat:0.0],
                  [NSNumber numberWithInt:10],
                  [NSNumber numberWithBool:false],nil];
        [array addObject:tmpArray];

        [AchievementManeger save_Achievement_All:array forKey:@"Achievement_Level"];
    }
}

@end


