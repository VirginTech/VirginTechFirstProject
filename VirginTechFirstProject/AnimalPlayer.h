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
    NSMutableArray* inpolPosArray;
    CGPoint oldPt;
    
    bool stopFlg;
    bool state_PathMake_flg;
    
    CCSprite* arrow;
}

@property bool stopFlg;
@property bool state_PathMake_flg;

+(id)createPlayer:(CGPoint)playerPos player:(int)num;
-(id)initWithPlayer:(CGPoint)playerPos player:(int)num;

-(void)moveTank:(NSMutableArray*)posArray;
+(NSMutableArray*)lineInterpolation:(NSMutableArray*)posArray;
-(void)getVehicleFrame:(float)angle;

@end
