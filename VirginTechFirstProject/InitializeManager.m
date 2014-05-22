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

+(void)initializeObject
{
    //各種能力の取得
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:appDomain];
    
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

+(void)initializeCurrency
{
    //各種通貨の取得
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:appDomain];
    
    //なければ(初回)とりあえず初期値をセーブ
    if([dict valueForKey:@"Currency"]==nil){
        [GameManager save_Currency_All:1000 dia:10];
    }
}

+(void)initializeHighScore
{
    //各種通貨の取得
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:appDomain];
    
    //なければ(初回)とりあえず初期値をセーブ
    if([dict valueForKey:@"HighScore"]==nil){
        [GameManager save_HighScore:0];
    }
}

@end


