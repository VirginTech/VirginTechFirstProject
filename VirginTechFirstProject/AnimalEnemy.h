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
    bool playerSearchFlg;
    float gunAngle;
    
    CGPoint targetPoint;
    float velocity;
    CGPoint oldPt;
    float oldRange;
    
    AnimalPlayer* targetPlayer;
    
    int modeFlg;//0=直進 1=追跡 2=回避
    float escapeAngle;

    int totalAbility;
}

@property int totalAbility;
@property bool stopFlg;

+(id)createEnemy;
-(id)initWithEnemy;

-(void)setTarget:(NSMutableArray*)targetArray;
-(void)onPause_To_Resume:(bool)flg;

//-(BOOL)isLevel:(AnimalPlayer*)player;
//-(BOOL)doEscape:(AnimalPlayer*)player;
//-(BOOL)isForward:(AnimalPlayer*)player;
//-(BOOL)isNear:(AnimalPlayer*)player;

@end
