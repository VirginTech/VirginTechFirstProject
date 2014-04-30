//
//  BackgroundLayer.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/28.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "BgHigherLayer.h"

@implementation BgHigherLayer

CGSize winSize;

CCSprite* tree;
CCSprite* sakura;
CCSprite* sakura2;

+ (BgHigherLayer *)scene{
    
    return [[self alloc] init];
}

- (id)init{
    
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"花_default.plist"];
    
    tree=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"tree01.png"]];
    tree.position=CGPointMake(tree.contentSize.width/2, winSize.height-winSize.height/3);
    [self addChild:tree];

    tree=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"tree01.png"]];
    tree.position=CGPointMake(tree.contentSize.width/2+70, winSize.height-winSize.height/3);
    [self addChild:tree];

    tree=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"tree01.png"]];
    tree.position=CGPointMake(tree.contentSize.width/2+25, winSize.height-winSize.height/3+50);
    [self addChild:tree];

    sakura2=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"sakura2.png"]];
    sakura2.position=CGPointMake(winSize.width-sakura2.contentSize.width/2-30, sakura2.contentSize.height*2+60);
    [self addChild:sakura2];

    sakura2=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"sakura2.png"]];
    sakura2.position=CGPointMake(winSize.width-sakura2.contentSize.width/2-30-30, sakura2.contentSize.height*2+60+30);
    [self addChild:sakura2];

    sakura=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"sakura.png"]];
    sakura.position=CGPointMake(winSize.width-sakura.contentSize.width/2-30, sakura.contentSize.height*2+60+50);
    [self addChild:sakura];

    sakura=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"sakura.png"]];
    sakura.position=CGPointMake(winSize.width-sakura.contentSize.width/2-30-50, sakura.contentSize.height*2+50);
    [self addChild:sakura];

    sakura=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"sakura2.png"]];
    sakura.position=CGPointMake(winSize.width-sakura.contentSize.width/2-10, winSize.height-sakura.contentSize.height/2-50);
    [self addChild:sakura];

    return self;
}

@end
