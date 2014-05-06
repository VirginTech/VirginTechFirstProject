//
//  AnimalEnemy.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/02.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "AnimalEnemy.h"
#import "BasicMath.h"

@implementation AnimalEnemy

@synthesize stopFlg;

CGSize winSize;
CGPoint oldPt;

//========================
//　　直進モード
//========================
-(void)straight_Schedule:(CCTime)dt{

    CGPoint nextPos;
    float targetAngle;
    float targetDistance;

    if(!stopFlg){
        
        //方角セット
        targetAngle = [BasicMath getAngle_To_Radian:self.position ePos:targetPoint];
        //総距離セット
        targetDistance = sqrtf(powf(self.position.x - targetPoint.x,2) + powf(self.position.y - targetPoint.y,2));
        //次位置セット
        nextPos=CGPointMake(velocity*cosf(targetAngle),velocity*sinf(targetAngle));
        self.position=CGPointMake(self.position.x+nextPos.x, self.position.y+nextPos.y);
        //画像角度セット
        self.rotation=[BasicMath getAngle_To_Degree:oldPt ePos:self.position];
        //差替画像セット
        if(self.rotationalSkewX==self.rotationalSkewY){
            [self getVehicleFrame:self.rotation];
        }
        //目標到達
        if(targetDistance < 5.0){
            [self unschedule:@selector(straight_Schedule:)];
        }
        oldPt=self.position;
        
    }else{
        
        [self unschedule:@selector(straight_Schedule:)];
        stopFlg=false;
    }
}

//========================
//方向(角度)における車体画像差替え
//========================
-(void)getVehicleFrame:(float)angle{
    
    if(angle<=22.5){
        [self setSpriteFrame:[vFrameArray objectAtIndex:0]];
    }else if(angle<=67.5){
        [self setSpriteFrame:[vFrameArray objectAtIndex:1]];
    }else if(angle<=112.5){
        [self setSpriteFrame:[vFrameArray objectAtIndex:2]];
    }else if(angle<=150.0){
        [self setSpriteFrame:[vFrameArray objectAtIndex:3]];
    }else if(angle<=215.0){
        [self setSpriteFrame:[vFrameArray objectAtIndex:4]];
    }else if(angle<=247.5){
        [self setSpriteFrame:[vFrameArray objectAtIndex:5]];
    }else if(angle<=292.5){
        [self setSpriteFrame:[vFrameArray objectAtIndex:6]];
    }else if(angle<=337.5){
        [self setSpriteFrame:[vFrameArray objectAtIndex:7]];
    }else if(angle<=360.0){
        [self setSpriteFrame:[vFrameArray objectAtIndex:0]];
    }
}

-(void)moveGun_Schedule:(CCTime)dt{
    
    float normalize;
    float realAngle;
    
    if(self.rotationalSkewX==self.rotationalSkewY){
        normalize = -self.rotation;
        realAngle = self.rotation;
    }
    
    if(enemySearchFlg){//敵捕捉状態
        gSprite.rotation = normalize;// normalize + 敵の角度
        
        if(gSprite.rotation<=normalize+22.5){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:0]];
        }else if(gSprite.rotation<=normalize+67.5){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:1]];
        }else if(gSprite.rotation<=normalize+112.5){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:2]];
        }else if(gSprite.rotation<=normalize+150.0){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:3]];
        }else if(gSprite.rotation<=normalize+215.0){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:4]];
        }else if(gSprite.rotation<=normalize+247.5){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:5]];
        }else if(gSprite.rotation<=normalize+292.5){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:6]];
        }else if(gSprite.rotation<=normalize+337.5){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:7]];
        }else if(gSprite.rotation<=normalize+360.0){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:0]];
        }
    }else{//通常走行
        if(realAngle<=22.5){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:0]];
        }else if(realAngle<=67.5){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:1]];
        }else if(realAngle<=112.5){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:2]];
        }else if(realAngle<=150.0){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:3]];
        }else if(realAngle<=215.0){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:4]];
        }else if(realAngle<=247.5){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:5]];
        }else if(realAngle<=292.5){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:6]];
        }else if(realAngle<=337.5){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:7]];
        }else if(realAngle<=360.0){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:0]];
        }
    }
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
        //目標セット
        targetPoint = CGPointMake(winSize.width/2, 50);
        //速度セット
        velocity=0.1;
        //直進スケジュール始動
        [self schedule:@selector(straight_Schedule:)interval:0.01];
        //停止フラグ
        stopFlg=false;
        //敵捕捉フラグ
        enemySearchFlg=false;
        //砲塔制御スケジュール開始
        [self schedule:@selector(moveGun_Schedule:)interval:0.1];
    }
    return self;
}

+(id)createEnemy{
    
    return [[self alloc] initWithEnemy];
}

@end
