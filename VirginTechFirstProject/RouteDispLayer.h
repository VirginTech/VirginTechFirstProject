//
//  RouteDispLayer.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/26.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface RouteDispLayer : CCScene {
    
    NSMutableArray* posArray;
}

@property(retain,readwrite) NSMutableArray* posArray;

+ (RouteDispLayer *)scene;
- (id)init;

@end
