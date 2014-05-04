//
//  RouteGenerationLayer.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/03.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AnimalPlayer.h"

@interface RouteGenerationLayer : CCScene {
    
    AnimalPlayer* player;
    float offsetY;
}

@property AnimalPlayer* player;
@property float offsetY;

+ (RouteGenerationLayer *)scene;
- (id)init;

@end
