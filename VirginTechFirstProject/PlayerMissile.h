//
//  PlayerMissile.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/10.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PlayerMissile : CCSprite {
    
    float velocity;
    float targetAngle;
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

+(id)createMissile:(CGPoint)playerPos enemyPos:(CGPoint)enemyPos;
-(id)initWithMissile:(CGPoint)playerPos enemyPos:(CGPoint)enemyPos;

@end
