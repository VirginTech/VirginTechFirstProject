//
//  SoundManager.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/06/19.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SoundManager : NSObject

+(void)soundPreload;

+(void)setBgmSwitch:(bool)flg;
+(bool)getBgmSwitch;
+(void)setEffectSwitch:(bool)flg;
+(bool)getEffectSwitch;

+(void)playBGM;
+(void)stopBGM;
+(void)setBgmVolume:(float)value;
+(float)getBgmVolume;

+(void)setEffectVolume:(float)value;
+(float)getEffectVolume;

+(void)playerSet:(int)type;
+(void)playerFireMissile:(int)type;
+(void)playerDestruct;
+(void)playerDamage;

+(void)enemySet:(int)type;
+(void)enemyFireMissile:(int)type;
+(void)enemyDestruct;
+(void)enemyDamage;

+(void)fortressDestruct;
+(void)fortressDamage;

+(void)endingEffect:(bool)flg;
+(void)splashDown;

+(void)button_Click;
+(void)playerSelect;

@end
