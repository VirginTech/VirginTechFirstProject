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
}

@property bool stopFlg;

+(id)createPlayer:(CGPoint)playerPos player:(int)num;
-(id)initWithPlayer:(CGPoint)playerPos player:(int)num;

-(void)moveTank:(NSMutableArray*)posArray;
+(NSMutableArray*)lineInterpolation:(NSMutableArray*)posArray;
+(float)getAngle:(CGPoint)sPos ePos:(CGPoint)ePos;
-(void)getVehicleFrame:(float)angle;

@end
