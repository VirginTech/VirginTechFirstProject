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

+(void)playBGM;
+(void)stopBGM;
+(void)setBgmVolume:(float)value;
+(float)getBgmVolume;

+(void)setEffectVolume:(float)value;
+(float)getEffectVolume;

+(void)playerSet:(int)type;
+(void)playerFireMissile:(int)type;
+(void)playerDestruct;

+(void)enemySet:(int)type;
+(void)enemyFireMissile:(int)type;
+(void)enemyDestruct;

+(void)fortressDestruct;
+(void)endingEffect:(bool)flg;

+(void)splashDown;

+(void)button_Click;
+(void)playerSelect;

@end
