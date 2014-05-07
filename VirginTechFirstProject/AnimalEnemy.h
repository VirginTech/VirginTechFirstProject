//
//  AnimalEnemy.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/02.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AnimalPlayer.h"

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

-(void)setTarget:(NSMutableArray*)targetArray;
-(BOOL)isLevel:(AnimalPlayer*)player;
-(BOOL)doEscape:(AnimalPlayer*)player;
-(BOOL)isForward:(AnimalPlayer*)player;
-(BOOL)isNear:(AnimalPlayer*)player;

@end
