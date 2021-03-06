//
//  Fortress.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/26.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCParticleSystem.h"

@interface Fortress : CCSprite
{
    float ability_Defense ;
    bool destCollectFlg;
    
    CCSprite* lifeGauge1;
    CCSprite* lifeGauge2;
    float maxLife;
    float nowRatio;
    
    CCParticleSystem* damageParticle;
}

@property float ability_Defense;
@property float maxLife;
@property bool destCollectFlg;

-(id)initWithFortress:(CGPoint)pos type:(int)type;
+(id)createFortress:(CGPoint)pos type:(int)type;

@end
