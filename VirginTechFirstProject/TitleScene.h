//
//  StartScene.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/26.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "LeaderboardView.h"

@interface TitleScene : CCScene
{    
    LeaderboardView* lbv;
}

+ (TitleScene *)scene;
- (id)init;

@end
