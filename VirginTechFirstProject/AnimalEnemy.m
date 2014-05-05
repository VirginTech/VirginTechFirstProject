//
//  AnimalEnemy.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/02.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "AnimalEnemy.h"


@implementation AnimalEnemy

@synthesize stopFlg;

CGSize winSize;

-(void)targetSetting{
    
    //方角セット
    
    //距離セット
    
}

//====================
//　敵アニマルタンク作成
//====================
-(id)initWithEnemy{
    
    //初期化
    vFrameArray=[[NSMutableArray alloc]init];
    gFrameArray=[[NSMutableArray alloc]init];
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    
    //画像
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"enemy_default.plist"];
    
    for(int i=0;i<8;i++){
        [vFrameArray addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"v%02d.png",i]]];
        [gFrameArray addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"g%02d.png",i]]];
    }
    if(self=[super initWithSpriteFrame:[vFrameArray objectAtIndex:4]]){
        
        winSize = [[CCDirector sharedDirector]viewSize];
        
        self.rotation=180;
        
        //ポジション設定
        int minX = self.contentSize.width/2;
        int maxX = winSize.width-self.contentSize.width/2;
        int rangeX = maxX - minX;
        int actualX =(arc4random()% rangeX) + minX;
        self.position = CGPointMake(actualX, 550);
        
        //砲塔の描画
        gSprite=[CCSprite spriteWithSpriteFrame:[gFrameArray objectAtIndex:4]];
        gSprite.position=CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:gSprite];
        
        //停止フラグ
        stopFlg=false;
        //敵捕捉フラグ
        enemySearchFlg=false;
        
    }
    return self;
}

+(id)createEnemy{
    
    return [[self alloc] initWithEnemy];
}

@end
