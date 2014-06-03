//
//  NaviLayer.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/02.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface NaviLayer : CCScene {
    
}

+ (NaviLayer *)scene;
- (id)init;

+(void)setStageEndingScreen:(bool)clearFlg rate:(int)rate;
+(void)setPauseScreen;

@end
