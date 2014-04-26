//
//  Player.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/26.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "Player.h"


@implementation Player

CGSize winSize;
CCSpriteFrame *vFrame;
CCSpriteFrame *gFrame;
CCSprite *gSprite;

-(id)initWithPlayer{
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bear_default.plist"];
    vFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"v00.png"];
    gFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"g00.png"];

    //プレイヤータンク作成
    if(self=[super initWithSpriteFrame:vFrame]){
        
        winSize = [[CCDirector sharedDirector]viewSize];
        self.position = CGPointMake(winSize.width/2, self.contentSize.height);
        
        //砲塔の描画
        gSprite=[CCSprite spriteWithSpriteFrame:gFrame];
        gSprite.position=CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:gSprite];
        
    }
    return self;
}

+(id)createPlayer{

    return [[self alloc] initWithPlayer];
}

@end
