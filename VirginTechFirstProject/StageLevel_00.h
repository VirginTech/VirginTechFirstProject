//
//  Level_00.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/26.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "AnimalPlayer.h"

@interface StageLevel_00 : CCScene {
    
    AnimalPlayer* player;
}

+ (StageLevel_00 *)scene;
- (id)init;
+(BOOL)isAnimal:(CGPoint)animalPos;

@end
