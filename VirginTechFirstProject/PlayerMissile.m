//
//  PlayerMissile.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/10.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "PlayerMissile.h"
#import "BasicMath.h"

@implementation PlayerMissile

@synthesize timeFlg;

-(void)missile_Move:(CCTime)dt {
    
    t += interval;//経過時間
    
    if(dirFlg){//右だったら
        vfx -= vix;//左へ等速度運動
    }else{//左だったら
        vfx += vix;//右へ等速度運動
    }
    
    vfy += -g * t + viy;//平行時におけるY変化量
    vfy += velocity * sinf(targetAngle);//Yに角度分を足す
    
    //回転運動
    self.rotation += 5.0;
    
    self.position = ccp(self.position.x + vfx * interval, self.position.y + vfy * interval);
    
    if(t > 1.5){
        timeFlg=true;
        [self unschedule:@selector(missile_Move:)];
    }
    
}

-(id)initWithMissile:(CGPoint)playerPos enemyPos:(CGPoint)enemyPos{
    
    if(self=[super initWithImageNamed:@"rock.png"]){

        //初期化
        t = 0;
        vfx = 0;
        vfy = 0;
        timeFlg=false;
        
        interval = 0.01;//0.01秒間隔
        g = 9.8;//重力加速度
        angle = 65.0;//投射角度

        //右にいるのか左にいるのか
        if(playerPos.x > enemyPos.x){
            dirFlg = true;
        }else{
            dirFlg = false;
        }
        
        //初速度算出
        velocity = 6.0;//初速度(m/s)
        targetRange = [BasicMath getPosDistance:playerPos pos2:enemyPos];//敵との距離
        targetAngle = [BasicMath getAngle_To_Radian:playerPos ePos:enemyPos];//敵との相対角度
        //velocity = sqrtf((g*targetRange)/(2*sinf(targetAngle)*cosf(targetAngle))) * interval;

        vi = velocity * interval;//初速度変換
        vix = vi * CC_RADIANS_TO_DEGREES(cosf(CC_DEGREES_TO_RADIANS(angle)));//X軸初速度
        viy = vi * CC_RADIANS_TO_DEGREES(sinf(CC_DEGREES_TO_RADIANS(angle)));//Y軸初速度
        
        self.position=playerPos;
        
        [self schedule:@selector(missile_Move:) interval:interval];
    }
    return self;
}

+(id)createMissile:(CGPoint)playerPos enemyPos:(CGPoint)enemyPos{
    
    return [[self alloc] initWithMissile:playerPos enemyPos:enemyPos];
}

@end
