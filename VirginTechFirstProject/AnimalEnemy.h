//
//  AnimalEnemy.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/02.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface AnimalEnemy : CCSprite {
    
    NSMutableArray* vFrameArray;
    NSMutableArray* gFrameArray;
    CCSprite *gSprite;
        
    bool stopFlg;
    bool enemySearchFlg;
    
    CGPoint targetPoint;
    float velocity;
}

@property bool stopFlg;

+(id)createEnemy;
-(id)initWithEnemy;

@end
