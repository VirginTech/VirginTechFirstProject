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
#import <GameFeatKit/GFView.h>
#import <GameFeatKit/GFController.h>
#import <GameFeatKit/GFIconController.h>
#import <GameFeatKit/GFIconView.h>

@interface TitleScene : CCScene <GFViewDelegate> {
    
    LeaderboardView* lbv;
    GFIconController *gfIconController;
}

+ (TitleScene *)scene;
- (id)init;

@end
