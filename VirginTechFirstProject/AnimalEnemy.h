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
#import "Fortress.h"
#import "CCParticleSystem.h"

@interface AnimalEnemy : CCSprite
{
    int enemyNum;

    //各種能力変数
    float ability_Defense ;
    float ability_Attack;
    float ability_Traveling;
    
    NSMutableArray* vFrameArray;
    NSMutableArray* gFrameArray;
    CCSprite *gSprite;
    CCSprite* waveSprite;
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
    Fortress* targetFortress;
    
    int modeFlg;//0=直進 1=追跡 2=回避
    float escapeAngle;

    CGPoint targetPlayerPos;
    EnemyMissile* eMissile;
    bool destCollectFlg;
    bool fortressFlg;
    bool waterFlg;
    
    CCParticleSystem* damageParticle;
}

@property int enemyNum;
@property float ability_Defense ;
@property float ability_Attack;
@property float ability_Traveling;
@property float maxLife;

@property bool stopFlg;
@property bool destCollectFlg;
@property bool fortressFlg;
@property bool waterFlg;

+(id)createEnemy;
-(id)initWithEnemy;

-(void)setTarget:(NSMutableArray*)targetArray;
-(void)onPause_To_Resume:(bool)flg;
-(void)resumeRunning;

//-(BOOL)isLevel:(AnimalPlayer*)player;
//-(BOOL)doEscape:(AnimalPlayer*)player;
//-(BOOL)isForward:(AnimalPlayer*)player;
//-(BOOL)isNear:(AnimalPlayer*)player;

@end
