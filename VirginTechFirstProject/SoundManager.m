//
//  SoundManager.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/06/19.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager

//===================
//BGM・効果音プリロード
//===================
+(void)soundPreload
{
    //BGM
    [[OALSimpleAudio sharedInstance]preloadBg:@"toys01.mp3"];
    [[OALSimpleAudio sharedInstance]preloadBg:@"toys02.mp3"];
    [[OALSimpleAudio sharedInstance]preloadBg:@"toys03.mp3"];
    [[OALSimpleAudio sharedInstance]preloadBg:@"toys04.mp3"];
    [[OALSimpleAudio sharedInstance]preloadBg:@"toys05.mp3"];
    [[OALSimpleAudio sharedInstance]preloadBg:@"toys06.mp3"];
    [[OALSimpleAudio sharedInstance]preloadBg:@"toys07.mp3"];
    [[OALSimpleAudio sharedInstance]preloadBg:@"toys08.mp3"];
    [[OALSimpleAudio sharedInstance]preloadBg:@"toys09.mp3"];
    
    //プレイヤ
    [[OALSimpleAudio sharedInstance]preloadEffect:@"player01set.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"player02set.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"player03set.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"player04set.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"player05set.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"playerFire.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"playerDestruct.mp3"];
    
    //敵
    [[OALSimpleAudio sharedInstance]preloadEffect:@"enemySet.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"enemyFire.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"enemyDestruct.mp3"];
    
    //ボタン
    [[OALSimpleAudio sharedInstance]preloadEffect:@"button01_Click.mp3"];
}

//===================
// BGM
//===================
+(void)playBGM
{
    int num=arc4random()%9+1;
    NSString* name=[NSString stringWithFormat:@"toys%02d.mp3",num];
    [[OALSimpleAudio sharedInstance]playBg:name loop:YES];
    [[OALSimpleAudio sharedInstance]setBgVolume:0.2];
}

+(void)stopBGM
{
    [[OALSimpleAudio sharedInstance]stopBg];
}

//===================
// プレイヤー
//===================
+(void)playerSet:(int)type
{
    NSString* name=[NSString stringWithFormat:@"player%02dset.mp3",type];
    [[OALSimpleAudio sharedInstance]playEffect:name];
    [[OALSimpleAudio sharedInstance]setEffectsVolume:0.5];
}

+(void)playerFireMissile:(int)type
{
    NSString* name=@"playerFire.mp3";
    [[OALSimpleAudio sharedInstance]playEffect:name];
    [[OALSimpleAudio sharedInstance]setEffectsVolume:0.5];
}

+(void)playerDestruct
{
    [[OALSimpleAudio sharedInstance]playEffect:@"playerDestruct.mp3"];
    [[OALSimpleAudio sharedInstance]setEffectsVolume:1.0];
}

//===================
// 敵
//===================
+(void)enemySet:(int)type
{
    NSString* name=@"enemySet.mp3";
    [[OALSimpleAudio sharedInstance]playEffect:name];
    [[OALSimpleAudio sharedInstance]setEffectsVolume:0.5];
}

+(void)enemyFireMissile:(int)type
{
    NSString* name=@"enemyFire.mp3";
    [[OALSimpleAudio sharedInstance]playEffect:name];
    [[OALSimpleAudio sharedInstance]setEffectsVolume:0.5];
}

+(void)enemyDestruct
{
    [[OALSimpleAudio sharedInstance]playEffect:@"enemyDestruct.mp3"];
    [[OALSimpleAudio sharedInstance]setEffectsVolume:1.0];
}

//===================
// UI
//===================
+(void)button_Click
{
    [[OALSimpleAudio sharedInstance]playEffect:@"button01_Click.mp3"];
    [[OALSimpleAudio sharedInstance]setEffectsVolume:0.3];
}

@end
