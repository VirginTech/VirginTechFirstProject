//
//  Player.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/26.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Player : CCSprite {
    
    NSMutableArray* vFrameArray;
    NSMutableArray* gFrameArray;
    CCSprite *gSprite;
    
    int t;
    NSMutableArray* inpolPosArray;
    CGPoint oldPt;
}

+(id)createPlayer:(CGPoint)playerPos;
-(id)initWithPlayer:(CGPoint)playerPos;

-(void)moveTank:(NSMutableArray*)posArray;
+(NSMutableArray*)lineInterpolation:(NSMutableArray*)posArray;
+(float)getAngle:(CGPoint)sPos ePos:(CGPoint)ePos;
-(void)getSpriteFrame:(float)angle;

@end
