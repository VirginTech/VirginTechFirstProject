//
//  Fortress.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/26.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "Fortress.h"
#import "GameManager.h"

@implementation Fortress

@synthesize ability_Defense;
@synthesize maxLife;

CGSize winSize;

-(void)status_Schedule:(CCTime)dt
{
    //ライフゲージ
    nowRatio=(100/maxLife)*ability_Defense;
    lifeGauge2.scaleX=nowRatio*0.01;
    lifeGauge2.position=CGPointMake((nowRatio*0.01)*(lifeGauge2.contentSize.width/2), lifeGauge2.contentSize.height/2);
}

-(id)initWithFortress:(CGPoint)pos
{
    winSize=[[CCDirector sharedDirector]viewSize];
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"fortress_default.plist"];

    if(self=[super initWithSpriteFrame:
                    [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"fortress.png" ]])
    {
        self.position=pos;
        ability_Defense=10.0f+(([GameManager getStageLevel]-1)*3);
        //体力ゲージ描画
        maxLife=ability_Defense;
        lifeGauge1=[CCSprite spriteWithSpriteFrame:
                            [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"lifegauge1.png"]];
        lifeGauge1.position=CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:lifeGauge1];
        
        lifeGauge2=[CCSprite spriteWithSpriteFrame:
                            [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"lifegauge2.png"]];
        nowRatio=(100/maxLife)*ability_Defense;
        lifeGauge2.scaleX=nowRatio*0.01;
        lifeGauge2.position=CGPointMake((nowRatio*0.01)*(lifeGauge2.contentSize.width/2), lifeGauge2.contentSize.height/2);
        [lifeGauge1 addChild:lifeGauge2];
        
        //状態スケジュール
        [self schedule:@selector(status_Schedule:)interval:0.1];
    }
    return self;
}

+(id)createFortress:(CGPoint)pos
{
    return [[self alloc] initWithFortress:pos];
}

@end
