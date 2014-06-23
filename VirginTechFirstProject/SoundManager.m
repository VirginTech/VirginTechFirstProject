//
//  SoundManager.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/06/19.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager

bool bgmSwitch;
bool effectSwitch;

float bgmValue;
float bgmMaxVolume;

float effectValue;
float playerSetVolume;
float playerFireMissileVolume;
float playerDestructVolume;

float enemySetVolume;
float enemyFireMissileVolume;
float enemyDestructVolume;

float fortressDestructVolume;
float endingEffectVolume;
float splashDownVolume;

float buttonClickVolume;
float playerSelectVolume;

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
    
    //スイッチ
    bgmSwitch=true;
    effectSwitch=true;
    
    //BGM音量初期値セット
    bgmValue=0.5;
    
    //BGM音量最大値セット
    bgmMaxVolume=0.4;
    
    //エフェクト音量初期値セット
    effectValue=0.5;
    
    //各種エフェクト最大値
    playerSetVolume=0.3;
    playerFireMissileVolume=0.5;
    playerDestructVolume=1.0;
    
    enemySetVolume=0.5;
    enemyFireMissileVolume=0.5;
    enemyDestructVolume=1.0;
    
    fortressDestructVolume=0.3;
    endingEffectVolume=0.3;
    splashDownVolume=3.0;
    
    buttonClickVolume=0.3;
    playerSelectVolume=1.0;
}
//===================
// スイッチ
//===================
+(void)setBgmSwitch:(bool)flg
{
    bgmSwitch=flg;
}
+(bool)getBgmSwitch
{
    return bgmSwitch;
}
+(void)setEffectSwitch:(bool)flg
{
    effectSwitch=flg;
}
+(bool)getEffectSwitch
{
    return effectSwitch;
}

//===================
// BGM
//===================
+(void)playBGM
{
    if(bgmSwitch){
        int num=arc4random()%9+1;
        NSString* name=[NSString stringWithFormat:@"toys%02d.mp3",num];
        [[OALSimpleAudio sharedInstance]setBgVolume:bgmMaxVolume*bgmValue];
        [[OALSimpleAudio sharedInstance]playBg:name loop:YES];
    }
}
+(void)stopBGM
{
    [[OALSimpleAudio sharedInstance]stopBg];
}
+(void)setBgmVolume:(float)value
{
    bgmValue=value;
    [[OALSimpleAudio sharedInstance]setBgVolume:bgmMaxVolume*bgmValue];
}
+(float)getBgmVolume
{
    return bgmValue;
}

//===================
// エフェクト音量セット
//===================
+(void)setEffectVolume:(float)value
{
    effectValue=value;
}

//===================
// エフェクト音量セット
//===================
+(float)getEffectVolume
{
    return effectValue;
}

//===================
// プレイヤー
//===================
+(void)playerSet:(int)type
{
    if(effectSwitch){
        NSString* name=[NSString stringWithFormat:@"player%02dset.mp3",type];
        [[OALSimpleAudio sharedInstance]setEffectsVolume:playerSetVolume*effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:name];
    }
}

+(void)playerFireMissile:(int)type
{
    if(effectSwitch){
        NSString* name=@"playerFire.mp3";
        [[OALSimpleAudio sharedInstance]setEffectsVolume:playerFireMissileVolume*effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:name];
    }
}

+(void)playerDestruct
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:playerDestructVolume*effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"playerDestruct.mp3"];
    }
}

//===================
// 敵
//===================
+(void)enemySet:(int)type
{
    if(effectSwitch){
        NSString* name=@"enemySet.mp3";
        [[OALSimpleAudio sharedInstance]setEffectsVolume:enemySetVolume*effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:name];
    }
}

+(void)enemyFireMissile:(int)type
{
    if(effectSwitch){
        NSString* name=@"enemyFire.mp3";
        [[OALSimpleAudio sharedInstance]setEffectsVolume:enemyFireMissileVolume*effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:name];
    }
}

+(void)enemyDestruct
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:enemyDestructVolume*effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"enemyDestruct.mp3"];
    }
}
//===================
// 要塞
//===================
+(void)fortressDestruct
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:fortressDestructVolume*effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"fortDestruct01.mp3"];
    }
}
//===================
// エンディング
//===================
+(void)endingEffect:(bool)flg //true:勝ち false:負け
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:endingEffectVolume*effectValue];
        if(flg){
            [[OALSimpleAudio sharedInstance]playEffect:@"end_Success.mp3"];
        }else{
            [[OALSimpleAudio sharedInstance]playEffect:@"end_Failed.mp3"];
        }
    }
}
//===================
// 着水
//===================
+(void)splashDown
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:splashDownVolume*effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"water01.mp3"];
    }
}
//===================
// UI
//===================
+(void)button_Click
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:buttonClickVolume*effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"button01_Click.mp3"];
    }
}
+(void)playerSelect
{
    if(effectSwitch){
        NSString* name=@"playerSelect.mp3";
        [[OALSimpleAudio sharedInstance]setEffectsVolume:playerSelectVolume*effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:name];
    }
}

@end
