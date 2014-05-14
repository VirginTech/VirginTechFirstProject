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

@synthesize totalAbility;
@synthesize stopFlg;

CGSize winSize;

//========================
//　　逃避モード
//========================
-(void)escape_Schedule:(CCTime)dt{
    
    CGPoint nextPos;
    float targetAngle;
    float targetDistance;
    
    if(!stopFlg){
        
        if(modeFlg==0){//直進
            [self unschedule:@selector(escape_Schedule:)];
            [self schedule:@selector(straight_Schedule:)interval:0.01];
        }else if(modeFlg==1){//追跡
            [self unschedule:@selector(escape_Schedule:)];
            [self schedule:@selector(chase_Schedule:)interval:0.01];
        }else if(modeFlg==2){//回避

        }
        //方角セット
        targetAngle = escapeAngle;
        //総距離セット
        targetDistance = sqrtf(powf(self.position.x - targetPlayer.position.x,2) +
                                                        powf(self.position.y - targetPlayer.position.y,2));
        //次位置セット
        nextPos=CGPointMake(velocity*cosf(targetAngle),velocity*sinf(targetAngle));
        self.position=CGPointMake(self.position.x+nextPos.x, self.position.y+nextPos.y);
        //画像角度セット
        self.rotation=[BasicMath getAngle_To_Degree:oldPt ePos:self.position];
        //差替画像セット
        if(self.rotationalSkewX==self.rotationalSkewY){
            [self getVehicleFrame:self.rotation];
        }
        oldPt=self.position;
        
    }else{
        
        [self unschedule:@selector(escape_Schedule:)];
        stopFlg=false;
    }
}

//========================
//　　追跡モード
//========================
-(void)chase_Schedule:(CCTime)dt{

    CGPoint nextPos;
    float targetAngle;
    float targetDistance;
    
    if(!stopFlg){
        
        if(modeFlg==0){//直進
            [self unschedule:@selector(chase_Schedule:)];
            [self schedule:@selector(straight_Schedule:)interval:0.01];
        }else if(modeFlg==1){//追跡
            
        }else if(modeFlg==2){//回避
            [self unschedule:@selector(chase_Schedule:)];
            [self schedule:@selector(escape_Schedule:)interval:0.01];
        }

        //方角セット
        targetAngle = [BasicMath getAngle_To_Radian:self.position ePos:targetPlayer.position];
        //総距離セット
        targetDistance = sqrtf(powf(self.position.x - targetPlayer.position.x,2) +
                                                            powf(self.position.y - targetPlayer.position.y,2));
        //次位置セット
        nextPos=CGPointMake(velocity*cosf(targetAngle),velocity*sinf(targetAngle));
        self.position=CGPointMake(self.position.x+nextPos.x, self.position.y+nextPos.y);
        //画像角度セット
        self.rotation=[BasicMath getAngle_To_Degree:oldPt ePos:self.position];
        //差替画像セット
        if(self.rotationalSkewX==self.rotationalSkewY){
            [self getVehicleFrame:self.rotation];
        }
        oldPt=self.position;
        
    }else{
        
        [self unschedule:@selector(chase_Schedule:)];
        stopFlg=false;
    }

}

//========================
//　　直進モード
//========================
-(void)straight_Schedule:(CCTime)dt{

    CGPoint nextPos;
    float targetAngle;
    float targetDistance;

    if(!stopFlg){
        
        if(modeFlg==0){//直進
            
        }else if(modeFlg==1){//追跡
            [self unschedule:@selector(straight_Schedule:)];
            [self schedule:@selector(chase_Schedule:)interval:0.01];
        }else if(modeFlg==2){//回避
            int r = arc4random() % 2;
            if(r==0){
                targetDistance=-(500 - sqrtf(powf(self.position.x - targetPlayer.position.x,2)
                                       + powf(self.position.y - targetPlayer.position.y,2)));
            }else{
                targetDistance= (500 - sqrtf(powf(self.position.x - targetPlayer.position.x,2)
                                       + powf(self.position.y - targetPlayer.position.y,2)));
            }
            escapeAngle = [BasicMath getAngle_To_Radian:self.position ePos:
                           CGPointMake(targetPlayer.position.x + targetDistance, targetPlayer.position.y)];
            [self unschedule:@selector(straight_Schedule:)];
            [self schedule:@selector(escape_Schedule:)interval:0.01];
        }
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
    }else if(angle<=157.5){
        [self setSpriteFrame:[vFrameArray objectAtIndex:3]];
    }else if(angle<=202.5){
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
    
    if(playerSearchFlg){//敵捕捉状態
        gSprite.rotation = normalize + gunAngle;// normalize + 敵の角度
        
        if(gSprite.rotation<=normalize+22.5){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:0]];
        }else if(gSprite.rotation<=normalize+67.5){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:1]];
        }else if(gSprite.rotation<=normalize+112.5){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:2]];
        }else if(gSprite.rotation<=normalize+157.5){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:3]];
        }else if(gSprite.rotation<=normalize+202.5){
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
        gSprite.rotation=0;
        
        if(realAngle<=22.5){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:0]];
        }else if(realAngle<=67.5){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:1]];
        }else if(realAngle<=112.5){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:2]];
        }else if(realAngle<=157.5){
            [gSprite setSpriteFrame:[gFrameArray objectAtIndex:3]];
        }else if(realAngle<=202.5){
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

-(void)setTarget:(NSMutableArray*)targetArray{
    
    float range;
    float nearRange=500;
    
    if(targetArray.count>0){
        for(AnimalPlayer* target in targetArray){
            //一番近いターゲットを取得
            range = [BasicMath getPosDistance:self.position pos2:target.position];
            if(range < nearRange){
                nearRange = range;
                targetPlayer = target;
                if([self isLevel:target]){//自分が強ければ追跡モード
                    modeFlg=1;
                }else{                          //相手が強ければ逃避モード
                    if([self doEscape:target]){ //回避の必要性
                        modeFlg=2;//あり
                    }
                }
                //砲塔旋回
                playerSearchFlg=true;
                gunAngle=[BasicMath getAngle_To_Degree:self.position ePos:target.position];
                //ミサイル発射
                
            }
        }
    }else{                                      //相手がいなければ直進モード
        modeFlg=0;
        playerSearchFlg=false;
    }
}

-(BOOL)doEscape:(AnimalPlayer*)player{
    
    bool flg=false;//回避行動必要なし
    if([self isForward:player]){//相手が相対前方に位置しているか？
        if([self isNear:player]){//互いに接近しているのか？
            flg=true;//回避行動必要あり
        }
    }
    return  flg;
}

-(BOOL)isNear:(AnimalPlayer*)player{
    
    bool flg=false;//離反
    float newRange=[BasicMath getPosDistance:self.position pos2:player.position];
    
    if(oldRange > newRange){
        flg=true;//接近中
    }
    if(player.t > 0){
        NSValue* value=[player.inpolPosArray objectAtIndex:player.t-1];
        oldRange=[BasicMath getPosDistance:self.position pos2:[value CGPointValue]];
    }
    return flg;
}

-(BOOL)isForward:(AnimalPlayer*)player{
    
    bool flg=false;//後方

    float playerAngle=[BasicMath getAngle_To_Degree:self.position ePos:player.position];
    float leftAngleLimit = self.rotation - 90;
    float rightAngleLimit = self.rotation + 90;

    if(leftAngleLimit<0){
        leftAngleLimit = 360 - leftAngleLimit;
    }
    if(rightAngleLimit>360){
        rightAngleLimit = rightAngleLimit - 360;
    }
    
    //左限界 以上 右限界 以内 だったら前方にいる
    if(leftAngleLimit<playerAngle && playerAngle<rightAngleLimit){
        flg=true;//前方
    }
    return flg;
}

-(BOOL)isLevel:(AnimalPlayer*)player{
    
    bool flg=false;//自分は弱い
    
    if(targetPlayer.totalAbility < self.totalAbility){
        flg=true;//自分が強い
    }
    return  flg;
}

-(void)onPause_To_Resume:(bool)flg{
    
    if(flg){

        if(modeFlg==0){
            [self unschedule:@selector(straight_Schedule:)];
        }else if(modeFlg==1){
            [self unschedule:@selector(chase_Schedule:)];
        }else if(modeFlg==2){
            [self unschedule:@selector(escape_Schedule:)];
        }
        
        [self unschedule:@selector(moveGun_Schedule:)];
        
    }else{
        
        if(modeFlg==0){
            [self schedule:@selector(straight_Schedule:)interval:0.01];//直進スケジュール
        }else if(modeFlg==1){
            [self schedule:@selector(chase_Schedule:)interval:0.01];//追跡スケジュール
        }else if(modeFlg==2){
            [self schedule:@selector(escape_Schedule:)interval:0.01];//回避スケジュール
        }
        
        [self schedule:@selector(moveGun_Schedule:)interval:0.1];//砲塔制御スケジュール
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
        //停止フラグ
        stopFlg=false;
        //敵捕捉フラグ
        playerSearchFlg=false;
        //モードフラグ 0=直進 1=追跡 2=回避
        modeFlg=0;
        //総合能力
        totalAbility=3;
        //直進スケジュール始動
        [self schedule:@selector(straight_Schedule:)interval:0.01];
        //砲塔制御スケジュール開始
        [self schedule:@selector(moveGun_Schedule:)interval:0.1];
    }
    return self;
}

+(id)createEnemy{
    
    return [[self alloc] initWithEnemy];
}

@end
