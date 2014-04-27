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
    
}

+(id)createPlayer;
-(id)initWithPlayer;

-(void)moveTank:(NSMutableArray*)posArray;
+(NSMutableArray*)lineInterpolation:(NSMutableArray*)posArray;
+(float)getAngle:(CGPoint)sPos ePos:(CGPoint)ePos;
-(void)setSpriteFrame2:(float)angle;

@end
