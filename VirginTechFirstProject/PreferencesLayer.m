//
//  PreferencesLayer.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/14.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "PreferencesLayer.h"
#import "GameManager.h"
#import "SoundManager.h"

@implementation PreferencesLayer

CGSize winSize;
CCSlider* bgmSlider;
CCSlider* effectSlider;


+(PreferencesLayer *)scene
{
    return [[self alloc] init];
}

-(id)init
{
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    self.userInteractionEnabled = YES;

    //BGカラー
    CCNodeColor* background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    //閉じるボタン
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button_default.plist"];
    CCButton *closeButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                    [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"close.png"]];
    closeButton.positionType = CCPositionTypeNormalized;
    closeButton.position = ccp(0.9f, 0.95f); // Top Right of screen
    closeButton.scale=0.3;
    [closeButton setTarget:self selector:@selector(onCloseClicked:)];
    [self addChild:closeButton];
    
    //BGM音量スライダー
    CCLabelTTF* bgmLabel=[CCLabelTTF labelWithString:@"BGM:" fontName:@"Verdana-Bold" fontSize:20.0];
    bgmLabel.position=ccp(winSize.width/2-100,winSize.height/2+100);
    [self addChild:bgmLabel];
    
    bgmSlider=[[CCSlider alloc]initWithBackground:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"bgm_line.png"]
                        andHandleImage:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"handle_bgm.png"]];
    bgmSlider.position=ccp(winSize.width/2-bgmSlider.contentSize.width/2,bgmLabel.position.y-50);
    [bgmSlider setSliderValue:[SoundManager getBgmVolume]];
    bgmSlider.name=@"BGM-Volume";
    bgmSlider.handle.scale=0.7;
    [self addChild:bgmSlider];
    
    //エフェクト音量スライダー
    CCLabelTTF* effectLabel=[CCLabelTTF labelWithString:@"Effect:" fontName:@"Verdana-Bold" fontSize:20.0];
    effectLabel.position=ccp(winSize.width/2-100,bgmLabel.position.y-100);
    [self addChild:effectLabel];

    effectSlider=[[CCSlider alloc]initWithBackground:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"effect_line.png"]
                        andHandleImage:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"handle_effect.png"]];
    effectSlider.position=ccp(winSize.width/2-effectSlider.contentSize.width/2,bgmLabel.position.y-150);
    [effectSlider setSliderValue:[SoundManager getEffectVolume]];
    effectSlider.name=@"Effect-Volume";
    effectSlider.handle.scale=0.7;
    [self addChild:effectSlider];
    
    return self;
}

-(void)onCloseClicked:(id)sender
{
    [SoundManager button_Click];
    [GameManager setActive:true];
    [self removeFromParentAndCleanup:YES];
}

@end
