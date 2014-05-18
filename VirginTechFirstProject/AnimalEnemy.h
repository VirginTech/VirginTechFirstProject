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
#import "EnemyMissile.h"

@interface AnimalEnemy : CCSprite
{    
    //各種能力変数
    float ability_Defense ;
    float ability_Attack;
    float ability_Traveling;
    
    NSMutableArray* vFrameArray;
    NSMutableArray* gFrameArray;
    CCSprite *gSprite;
    CCSprite* lifeGauge1;
    CCSprite* lifeGauge2;
    float maxLife;
    float nowRatio;
    
    bool stopFlg;
    bool playerSearchFlg;
    float gunAngle;
    
    CGPoint targetPoint;
    float velocity;
    CGPoint oldPt;
    float oldRange;
    
    AnimalPlayer* targetPlayer;
    
    int modeFlg;//0=直進 1=追跡 2=回避
    float escapeAngle;

    CGPoint targetPlayerPos;
    EnemyMissile* eMissile;
    bool destCollectFlg;
}

@property float ability_Defense ;
@property float ability_Attack;
@property float ability_Traveling;

@property bool stopFlg;
@property bool destCollectFlg;

+(id)createEnemy;
-(id)initWithEnemy;

-(void)setTarget:(NSMutableArray*)targetArray;
-(void)onPause_To_Resume:(bool)flg;

//-(BOOL)isLevel:(AnimalPlayer*)player;
//-(BOOL)doEscape:(AnimalPlayer*)player;
//-(BOOL)isForward:(AnimalPlayer*)player;
//-(BOOL)isNear:(AnimalPlayer*)player;

@end
