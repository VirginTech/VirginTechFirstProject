//
//  Player.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/26.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PlayerMissile.h"
#import "CCParticleSystem.h"

@interface AnimalPlayer : CCSprite {
    
    //アニマルダンス用
    float g;//重力加速度
    float vi;//初速度
    float vf;//現在速度
    float vt;//落下時間
    float y;//落下距離
    CGPoint nextPos;
    float offAngle;
    
    //各種能力変数
    NSString* objName;
    int ability_Level;
    float ability_Defense ;
    float ability_Attack;
    float ability_Traveling;
    int ability_Build;
    
    NSMutableArray* vFrameArray;
    NSMutableArray* gFrameArray;
    CCSprite *gSprite;
    CCSprite* lifeGauge1;
    CCSprite* lifeGauge2;
    float maxLife;
    float nowRatio;
    
    int t;
    float velocity;
    NSMutableArray* inpolPosArray;
    CGPoint oldPt;
    
    bool stopFlg;
    bool enemySearchFlg;
    bool state_PathMake_flg;
    
    float enemyAngle;
    CCSprite* arrow;

    PlayerMissile* pMissile;
    CGPoint targetEnemyPos;
    bool destCollectFlg;
    bool fortressFlg;
    
    AnimalPlayer* leaderPlayer;
    bool leaderFlg;
    CGPoint leaderOldPos;
    int groupNum;
    
    CCParticleSystem* damageParticle;
}

@property int ability_Level;
@property float ability_Defense ;
@property float ability_Attack;
@property float ability_Traveling;
@property int ability_Build;

@property int t;
@property NSMutableArray* inpolPosArray;
@property bool stopFlg;
@property bool state_PathMake_flg;
@property bool destCollectFlg;
@property bool fortressFlg;

@property AnimalPlayer* leaderPlayer;
@property bool leaderFlg;
@property CGPoint leaderOldPos;
@property int groupNum;

+(id)createPlayer:(CGPoint)playerPos playerNum:(int)playerNum;
-(id)initWithPlayer:(CGPoint)playerPos playerNum:(int)playerNum;

-(void)moveTank:(NSMutableArray*)posArray;
-(NSMutableArray*)lineInterpolation:(NSMutableArray*)posArray;
-(void)getVehicleFrame:(float)angle;
-(void)setTarget:(NSMutableArray*)targetArray;

-(void)onPause_To_Resume:(bool)flg;
-(void)resumeRunning;

@end
