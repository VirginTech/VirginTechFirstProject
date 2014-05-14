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

@interface AnimalPlayer : CCSprite {
    
    //アニマルダンス用
    float g;//重力加速度
    float vi;//初速度
    float vf;//現在速度
    float vt;//落下時間
    float y;//落下距離
    CGPoint nextPos;
    float offAngle;
    
    NSMutableArray* vFrameArray;
    NSMutableArray* gFrameArray;
    CCSprite *gSprite;
    
    int t;
    float velocity;
    NSMutableArray* inpolPosArray;
    CGPoint oldPt;
    
    bool stopFlg;
    bool enemySearchFlg;
    bool state_PathMake_flg;
    
    float enemyAngle;
    CCSprite* arrow;
    int totalAbility;

    PlayerMissile* pMissile;
    CGPoint targetEnemyPos;
    //bool fireFlg;
}

@property int t;
@property NSMutableArray* inpolPosArray;
@property bool stopFlg;
@property bool state_PathMake_flg;
@property int totalAbility;
//@property bool fireFlg;

+(id)createPlayer:(CGPoint)playerPos playerNum:(int)playerNum;
-(id)initWithPlayer:(CGPoint)playerPos playerNum:(int)playerNum;

-(void)moveTank:(NSMutableArray*)posArray;
-(NSMutableArray*)lineInterpolation:(NSMutableArray*)posArray;
-(void)getVehicleFrame:(float)angle;
-(void)setTarget:(NSMutableArray*)targetArray;

-(void)onPause_To_Resume:(bool)flg;

@end
