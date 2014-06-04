//
//  EnemyMissile.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/18.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EnemyMissile : CCSprite {
    
    float ability_Attack;
    
    float velocity;
    float targetAngle;
    float targetRange;
    float timeFlg;
    
    bool dirFlg;//true=右 false=左
    
    float interval;//時間間隔
    
    float vi;//初速度
    float g;//重力加速度
    float angle;//角度
    
    float vix;//水平方向の初速度
    float viy;//垂直方向の初速度
    float vfx;//水平方向の現在速度
    float vfy;//垂直方向の現在速度
    
    float dfx;//水平方向の現在位置
    float dfy;//垂直方向の現在位置
    
    float t;//時間
}

@property float ability_Attack;
@property float timeFlg;

+(id)createMissile:(CGPoint)enemyPos playerPos:(CGPoint)playerPos enemyNum:(int)enemyNum;
-(id)initWithMissile:(CGPoint)enemyPos playerPos:(CGPoint)playerPos enemyNum:(int)enemyNum;

-(void)onPause_To_Resume:(bool)flg;

@end
