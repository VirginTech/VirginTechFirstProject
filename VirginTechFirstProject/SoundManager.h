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

+(void)playOpeningBGM;
+(void)playStageBGM:(int)stageNum;
+(void)stageStart;

+(void)playerSet:(int)type;
+(void)playerFireMissile:(int)type;
+(void)enemyDestruct;
+(void)stopBGM;

+(void)button_Click;

@end
