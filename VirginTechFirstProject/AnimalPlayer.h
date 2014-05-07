//
//  Player.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/26.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface AnimalPlayer : CCSprite {
    
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
    
    CCSprite* arrow;
}

@property int t;
@property NSMutableArray* inpolPosArray;
@property bool stopFlg;
@property bool state_PathMake_flg;

+(id)createPlayer:(CGPoint)playerPos playerNum:(int)playerNum;
-(id)initWithPlayer:(CGPoint)playerPos playerNum:(int)playerNum;

-(void)moveTank:(NSMutableArray*)posArray;
-(NSMutableArray*)lineInterpolation:(NSMutableArray*)posArray;
-(void)getVehicleFrame:(float)angle;

@end
