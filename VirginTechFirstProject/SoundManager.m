//
//  SoundManager.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/06/19.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager


+(void)soundPreload
{
    //BGMプリロード
    [[OALSimpleAudio sharedInstance]preloadBg:@"opening.mp3"];
    
    [[OALSimpleAudio sharedInstance]preloadBg:@"jungle01.mp3"];
    [[OALSimpleAudio sharedInstance]preloadBg:@"jungle02.mp3"];
    [[OALSimpleAudio sharedInstance]preloadBg:@"jungle03.mp3"];
    [[OALSimpleAudio sharedInstance]preloadBg:@"jungle04.mp3"];
    [[OALSimpleAudio sharedInstance]preloadBg:@"jungle05.mp3"];
    
    [[OALSimpleAudio sharedInstance]preloadBg:@"swamp01.mp3"];
    [[OALSimpleAudio sharedInstance]preloadBg:@"swamp02.mp3"];
    [[OALSimpleAudio sharedInstance]preloadBg:@"swamp03.mp3"];
    [[OALSimpleAudio sharedInstance]preloadBg:@"swamp04.mp3"];
    [[OALSimpleAudio sharedInstance]preloadBg:@"swamp05.mp3"];
    
    //プレイヤーセット
    [[OALSimpleAudio sharedInstance]preloadEffect:@"player01set.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"player02set.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"player03set.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"player04set.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"player05set.mp3"];
    //効果音プリロード
    [[OALSimpleAudio sharedInstance]preloadEffect:@"enemyDestruct.mp3"];
    //ボタン効果音プリロード
    [[OALSimpleAudio sharedInstance]preloadEffect:@"button_Click.mp3"];
}

+(void)playOpeningBGM
{
    [[OALSimpleAudio sharedInstance]playBg:@"opening.mp3" loop:NO];
    [[OALSimpleAudio sharedInstance]setBgVolume:0.2];
}

+(void)playStageBGM:(int)stageNum
{
    int num=arc4random()%5+1;
    NSString* name;
    
    if(stageNum==0 || stageNum%3!=0){
        name=[NSString stringWithFormat:@"jungle%02d.mp3",num];
        [[OALSimpleAudio sharedInstance]playBg:name loop:YES];
        [[OALSimpleAudio sharedInstance]setBgVolume:0.2];
    }else{
        name=[NSString stringWithFormat:@"swamp%02d.mp3",num];
        [[OALSimpleAudio sharedInstance]playBg:name loop:YES];
        [[OALSimpleAudio sharedInstance]setBgVolume:0.2];
    }
}

+(void)stopBGM
{
    [[OALSimpleAudio sharedInstance]stopBg];
}

+(void)stageStart
{
    [[OALSimpleAudio sharedInstance]playEffect:@"opening.mp3"];
}

+(void)playerSet:(int)type
{
    NSString* name=[NSString stringWithFormat:@"player%02dset.mp3",type];
    [[OALSimpleAudio sharedInstance]playEffect:name];
    [[OALSimpleAudio sharedInstance]setEffectsVolume:0.5];
}

+(void)playerFireMissile:(int)type
{
    NSString* name=[NSString stringWithFormat:@"player%02dset.mp3",type];
    [[OALSimpleAudio sharedInstance]playEffect:name];
    [[OALSimpleAudio sharedInstance]setEffectsVolume:0.5];
}

+(void)enemyDestruct
{
    [[OALSimpleAudio sharedInstance]playEffect:@"enemyDestruct.mp3"];
    [[OALSimpleAudio sharedInstance]setEffectsVolume:1.0];
}

+(void)button_Click
{
    [[OALSimpleAudio sharedInstance]playEffect:@"button_Click.mp3"];
    [[OALSimpleAudio sharedInstance]setEffectsVolume:0.3];
}

@end
