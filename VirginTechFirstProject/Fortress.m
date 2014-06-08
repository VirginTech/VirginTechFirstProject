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
NSString* fileName;

-(void)status_Schedule:(CCTime)dt
{
    //ライフゲージ
    nowRatio=(100/maxLife)*ability_Defense;
    lifeGauge2.scaleX=nowRatio*0.01;
    lifeGauge2.position=CGPointMake((nowRatio*0.01)*(lifeGauge2.contentSize.width/2), lifeGauge2.contentSize.height/2);
    
    if(nowRatio<50){
        damageParticle.visible=true;
    }
}

-(id)initWithFortress:(CGPoint)pos type:(int)type
{
    winSize=[[CCDirector sharedDirector]viewSize];
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"fortress_default.plist"];

    if(type==0){//我
        fileName=@"fortress02.png";
    }else{//敵
        fileName=@"fortress01.png";
    }
    
    if(self=[super initWithSpriteFrame:
                    [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:fileName]])
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
        
        //ダメージパーティクルセット
        damageParticle=[[CCParticleSystem alloc]initWithFile:@"damage.plist"];
        damageParticle.position=ccp(self.contentSize.width/2,self.contentSize.height/2);
        damageParticle.scale=0.2;
        damageParticle.visible=false;
        [self addChild:damageParticle];
        
        //状態スケジュール
        [self schedule:@selector(status_Schedule:)interval:0.1];
    }
    return self;
}

+(id)createFortress:(CGPoint)pos type:(int)type
{
    return [[self alloc] initWithFortress:pos type:type];
}

@end
