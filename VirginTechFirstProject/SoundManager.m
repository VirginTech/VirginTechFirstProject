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
    
    //要塞
    [[OALSimpleAudio sharedInstance]preloadEffect:@"fortDestruct01.mp3"];
    
    //UI
    [[OALSimpleAudio sharedInstance]preloadEffect:@"button01_Click.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"playerSelect.mp3"];
    
    //着水
    [[OALSimpleAudio sharedInstance]preloadEffect:@"water01.mp3"];
    
    //エンディング
    [[OALSimpleAudio sharedInstance]preloadEffect:@"end_Success.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"end_Failed.mp3"];
}

//===================
// BGM
//===================
+(void)playBGM
{
    int num=arc4random()%9+1;
    NSString* name=[NSString stringWithFormat:@"toys%02d.mp3",num];
    [[OALSimpleAudio sharedInstance]setBgVolume:0.2];
    [[OALSimpleAudio sharedInstance]playBg:name loop:YES];
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
    [[OALSimpleAudio sharedInstance]setEffectsVolume:0.5];
    [[OALSimpleAudio sharedInstance]playEffect:name];
}

+(void)playerFireMissile:(int)type
{
    NSString* name=@"playerFire.mp3";
    [[OALSimpleAudio sharedInstance]setEffectsVolume:0.5];
    [[OALSimpleAudio sharedInstance]playEffect:name];
}

+(void)playerDestruct
{
    [[OALSimpleAudio sharedInstance]setEffectsVolume:1.0];
    [[OALSimpleAudio sharedInstance]playEffect:@"playerDestruct.mp3"];
}

//===================
// 敵
//===================
+(void)enemySet:(int)type
{
    NSString* name=@"enemySet.mp3";
    [[OALSimpleAudio sharedInstance]setEffectsVolume:0.5];
    [[OALSimpleAudio sharedInstance]playEffect:name];
}

+(void)enemyFireMissile:(int)type
{
    NSString* name=@"enemyFire.mp3";
    [[OALSimpleAudio sharedInstance]setEffectsVolume:0.5];
    [[OALSimpleAudio sharedInstance]playEffect:name];
}

+(void)enemyDestruct
{
    [[OALSimpleAudio sharedInstance]setEffectsVolume:1.0];
    [[OALSimpleAudio sharedInstance]playEffect:@"enemyDestruct.mp3"];
}
//===================
// 要塞
//===================
+(void)fortressDestruct
{
    [[OALSimpleAudio sharedInstance]setEffectsVolume:0.3];
    [[OALSimpleAudio sharedInstance]playEffect:@"fortDestruct01.mp3"];
}
//===================
// エンディング
//===================
+(void)endingEffect:(bool)flg //true:勝ち false:負け
{
    if(flg){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:0.3];
        [[OALSimpleAudio sharedInstance]playEffect:@"end_Success.mp3"];
    }else{
        [[OALSimpleAudio sharedInstance]setEffectsVolume:0.3];
        [[OALSimpleAudio sharedInstance]playEffect:@"end_Failed.mp3"];
    }
}
//===================
// 着水
//===================
+(void)splashdown
{
    [[OALSimpleAudio sharedInstance]setEffectsVolume:3.0];
    [[OALSimpleAudio sharedInstance]playEffect:@"water01.mp3"];
}
//===================
// UI
//===================
+(void)button_Click
{
    [[OALSimpleAudio sharedInstance]setEffectsVolume:0.3];
    [[OALSimpleAudio sharedInstance]playEffect:@"button01_Click.mp3"];
}
+(void)playerSelect
{
    NSString* name=@"playerSelect.mp3";
    [[OALSimpleAudio sharedInstance]setEffectsVolume:1.0];
    [[OALSimpleAudio sharedInstance]playEffect:name];
}

@end
