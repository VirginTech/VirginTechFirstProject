//
//  BgLowerLayer.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/28.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "BgLowerLayer.h"


@implementation BgLowerLayer

+ (BgLowerLayer *)scene{
    
    return [[self alloc] init];
}

- (id)init{
    
    self = [super init];
    if (!self) return(nil);
    
    /* 背景色レイヤー設定
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.3f green:0.5f blue:0.2f alpha:1.0f]];
    [self addChild:background z:0];
    */
    /*
    CCSprite* bg;
    NSString* bgFileName;
    bgFileName=@"ground_00.png";
    bg=[CCSprite spriteWithImageNamed:bgFileName];
    bg.anchorPoint = CGPointZero;
    [self addChild: bg];
    */
    
    int offsetX;
    int offsetY;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"地面_default.plist"];
    CCSprite* frame = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ground_00.png"]];

    CGSize winSize = [[CCDirector sharedDirector]viewSize];
    CGSize frameCount = CGSizeMake(winSize.width/frame.contentSize.width+1, winSize.height/frame.contentSize.height+1);
    
    for(int i=0;i<frameCount.width*frameCount.height;i++){
        
        frame=[self creatFrame:i];
        if(i==0){
            offsetX = frame.contentSize.width/2;
            offsetY = frame.contentSize.height/2;
        }else if(i%(int)frameCount.width==0){
            offsetX = frame.contentSize.width/2-1;
            offsetY = offsetY + frame.contentSize.height-1;
        }else{
            offsetX = offsetX + frame.contentSize.width-1;
        }
        frame.position = CGPointMake(offsetX,offsetY);
        [self addChild:frame];
    }
    return self;
}

-(CCSprite*)creatFrame:(int)num{
    
    CCSprite* frame = [CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ground_00.png"]];
    
    return frame;
}


@end
