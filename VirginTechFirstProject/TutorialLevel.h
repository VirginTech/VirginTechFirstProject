//
//  TutorialLevel.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/02.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "PlayerMissile.h"
#import "EnemyMissile.h"

@interface TutorialLevel : CCScene
{
    CCScrollView* scrollView;
}

+(TutorialLevel *)scene;
-(id)init;

+(void)t_createPlayer:(CGPoint)playerPos playerNum:(int)playerNum;
+(void)t_createEnemy;
+(void)t_setPlayerMissile:(PlayerMissile*)missile zOrder:(int)zOrder type:(int)type;
+(void)t_setEnemyMissile:(EnemyMissile*)missile zOrder:(int)zOrder type:(int)type;

+(void)setFinger;

@end
