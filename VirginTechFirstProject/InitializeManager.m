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

@implementation InitializeManager

NSString *appDomain;
NSDictionary *dict;

+(void)initialize_All
{
    //各種能力の取得
    appDomain = [[NSBundle mainBundle] bundleIdentifier];
    dict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:appDomain];

    [InitializeManager initialize_Object];
    [InitializeManager initialize_Currency];
    [InitializeManager initialize_HighScore];
    [InitializeManager initialize_Aggregate];
}

+(void)initialize_Object
{
    //なければ(初回)とりあえず初期値をセーブ
    if([dict valueForKey:@"beartank1"]==nil){
        [ObjectManager save_Object_Ability:@"beartank1" level:1 attack:1.0 defense:20.0 traveling:0.2 build:1];
    }
    if([dict valueForKey:@"beartank2"]==nil){
        [ObjectManager save_Object_Ability:@"beartank2" level:1 attack:1.5 defense:15.0 traveling:0.2 build:2];
    }
    if([dict valueForKey:@"beartank3"]==nil){
        [ObjectManager save_Object_Ability:@"beartank3" level:1 attack:2.0 defense:10.0 traveling:0.15 build:3];
    }
    if([dict valueForKey:@"beartank4"]==nil){
        [ObjectManager save_Object_Ability:@"beartank4" level:1 attack:3.0 defense:10.0 traveling:0.15 build:4];
    }
    if([dict valueForKey:@"beartank5"]==nil){
        [ObjectManager save_Object_Ability:@"beartank5" level:1 attack:4.0 defense:8.0 traveling:0.1 build:5];
    }
}

+(void)initialize_Currency
{
    //なければ(初回)とりあえず初期値をセーブ
    if([dict valueForKey:@"Currency"]==nil){
        [GameManager save_Currency_All:1000 dia:10];
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
//0:キーID 1:達成値 2:達成率 3:報酬ポイント 4:支払Flg
//===================================
+(void)initialize_Achievement_Tank
{
    //なければ(初回)とりあえず初期値をセーブ
    if([dict valueForKey:@"Achievement_Tank"]==nil){
        NSMutableArray* array=[[NSMutableArray alloc]init];
        NSArray* tankArray;
        
        tankArray=[NSArray arrayWithObjects:@"",
                    [NSNumber numberWithInt:5],
                    [NSNumber numberWithFloat:0.0],
                    [NSNumber numberWithInt:1],
                    [NSNumber numberWithBool:false],nil];
        [array addObject:tankArray];
        
        tankArray=[NSArray arrayWithObjects:@"",
                   [NSNumber numberWithInt:5],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:1],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tankArray];

        tankArray=[NSArray arrayWithObjects:@"",
                   [NSNumber numberWithInt:5],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:1],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tankArray];

        tankArray=[NSArray arrayWithObjects:@"",
                   [NSNumber numberWithInt:5],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:1],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tankArray];

        tankArray=[NSArray arrayWithObjects:@"",
                   [NSNumber numberWithInt:5],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:1],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tankArray];

        tankArray=[NSArray arrayWithObjects:@"",
                   [NSNumber numberWithInt:5],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:1],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tankArray];

        tankArray=[NSArray arrayWithObjects:@"",
                   [NSNumber numberWithInt:5],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:1],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tankArray];

        tankArray=[NSArray arrayWithObjects:@"",
                   [NSNumber numberWithInt:5],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:1],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tankArray];

        tankArray=[NSArray arrayWithObjects:@"",
                   [NSNumber numberWithInt:5],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:1],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tankArray];

        tankArray=[NSArray arrayWithObjects:@"",
                   [NSNumber numberWithInt:5],
                   [NSNumber numberWithFloat:0.0],
                   [NSNumber numberWithInt:1],
                   [NSNumber numberWithBool:false],nil];
        [array addObject:tankArray];
        
        [GameManager save_Achievement_Tank_All:array];
    }
}

@end


