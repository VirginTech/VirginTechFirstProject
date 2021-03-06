//
//  StageLevel_01.h
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

@interface StageLevel_01 : CCScene
{
    CCScrollView* scrollView;
}

+(StageLevel_01 *)scene;
-(id)init;

+(void)createPlayer:(CGPoint)playerPos playerNum:(int)playerNum;
+(void)createEnemy;
+(void)setPlayerMissile:(PlayerMissile*)missile zOrder:(int)zOrder type:(int)type;
+(void)setEnemyMissile:(EnemyMissile*)missile zOrder:(int)zOrder type:(int)type;

@end
