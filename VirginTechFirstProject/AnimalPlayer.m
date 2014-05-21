//
//  Player.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/26.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "AnimalPlayer.h"
#import "BasicMath.h"
#import "StageLevel_01.h"
#import "AnimalEnemy.h"
#import "ObjectManager.h"

@implementation AnimalPlayer

@synthesize ability_Level;
@synthesize ability_Attack;
@synthesize ability_Defense;
@synthesize ability_Traveling;
@synthesize ability_Build;

@synthesize t;
@synthesize inpolPosArray;
@synthesize stopFlg;
@synthesize state_PathMake_flg;
@synthesize destCollectFlg;

CGSize winSize;

-(void)moveTank:(NSMutableArray*)posArray{
    
    t=0;
    stopFlg=false;
    inpolPosArray=[[NSMutableArray alloc]init];
    
    //補間座標を作成(取得)
    inpolPosArray=[self lineInterpolation:posArray];
    
    [self schedule:@selector(moveVehicle_Schedule:) interval:0.01];
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
        normalize = -self.rotation;//正面０度
        realAngle = self.rotation;
    }
    
    if(enemySearchFlg){//敵捕捉状態
        gSprite.rotation = normalize + enemyAngle; // normalize + 敵の角度
        
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

- (void)moveVehicle_Schedule:(CCTime)dt{
    
    if(!stopFlg){
        if(inpolPosArray.count>0){
           if(inpolPosArray.count>t){
            
                NSValue *value=[inpolPosArray objectAtIndex:t];
                CGPoint pt=[value CGPointValue];
                //位置設定
                self.position=CGPointMake(pt.x, pt.y);
                //方向設定(度)
                self.rotation=[BasicMath getAngle_To_Degree:oldPt ePos:pt];
                //差替画像設定
                if(self.rotationalSkewX==self.rotationalSkewY){
                    [self getVehicleFrame:self.rotation];
                }
                //移動終了
                if(inpolPosArray.count-1==t){
                    [self unschedule:@selector(moveVehicle_Schedule:)];
                }
                oldPt=pt;
                t++;
           }
        }
    }else{
        [self unschedule:@selector(moveVehicle_Schedule:)];
        
        //位置を戻す
        /*if(t>=10){
            NSValue *value=[inpolPosArray objectAtIndex:t-10];
            CGPoint pt=[value CGPointValue];
            self.position=CGPointMake(pt.x, pt.y);
        }*/
        //stopFlg=false;
    }
}

//========================
//     直線補間
//========================
-(NSMutableArray*)lineInterpolation:(NSMutableArray*)posArray{
    
    NSValue *value1;
    NSValue *value2;
    CGPoint pt1;
    CGPoint pt2;
    float er,dr;//最終距離、補間距離(途中経過の)
    
    float angle;
    CGPoint inpolPos;//補間座標
    NSValue *inpolVal;
    
    NSMutableArray* tmpArray;
    tmpArray=[[NSMutableArray alloc]init];
    
    //座標間補完
    for(int i=1;i<posArray.count;i++){
        
        value1=[posArray objectAtIndex:i-1];
        value2=[posArray objectAtIndex:i];
        pt1 = [value1 CGPointValue];
        pt2 = [value2 CGPointValue];
        
        //斜辺角度
        angle=[BasicMath getAngle_To_Radian:pt1 ePos:pt2];
        //斜辺距離(er)
        er=sqrtf(powf(pt2.x-pt1.x,2)+powf(pt2.y-pt1.y,2));
        dr=0.0;
        
        while(er>dr){
            
            inpolPos = CGPointMake(dr*cosf(angle),dr*sinf(angle));
            //pt1から補間分(inpolPos)を加える
            inpolPos.x=pt1.x+inpolPos.x;
            inpolPos.y=pt1.y+inpolPos.y;
            
            inpolVal = [NSValue valueWithCGPoint:inpolPos];
            [tmpArray addObject:inpolVal];
            
            dr=dr+velocity;
        }
    }
    return tmpArray;
}

-(void)status_Schedule:(CCTime)dt
{
    //経路作成マーク
    if(state_PathMake_flg){
        if(!arrow.visible){
            arrow.position=CGPointMake(self.contentSize.width/2, self.contentSize.height/2 - arrow.contentSize.height/2);
            arrow.visible=true;
        }else{
            arrow.visible=false;
        }
        state_PathMake_flg=false;
    }
    //ライフゲージ
    if(self.rotationalSkewX==self.rotationalSkewY){
        lifeGauge1.rotation=-self.rotation;//常に０度を維持
    }
    nowRatio=(100/maxLife)*ability_Defense;
    lifeGauge2.scaleX=nowRatio*0.01;
    lifeGauge2.position=CGPointMake((nowRatio*0.01)*(lifeGauge2.contentSize.width/2), lifeGauge2.contentSize.height/2);
}

-(void)setTarget:(NSMutableArray*)targetArray{
    float range;
    float nearRange=500;
    
    if(targetArray.count>0){
        for(AnimalEnemy* target in targetArray){
            //一番近いターゲットを取得
            range = [BasicMath getPosDistance:self.position pos2:target.position];
            if(range < nearRange){
                nearRange = range;
                targetEnemyPos = target.position;//ターゲットポジション取得
                //砲塔旋回
                enemySearchFlg=true;
                enemyAngle=[BasicMath getAngle_To_Degree:self.position ePos:target.position];
            }
        }
    }else{
        enemySearchFlg=false;
    }
}

//====================
//　ミサイル発射！
//====================
-(void)pFireMissile_Schedule:(CCTime)dt{
    
    if(enemySearchFlg){
        g=9.8;
        vi = 5;
        vt=0;
        y=0;
        vf=vi;
        
        int zOrder;
        pMissile = [PlayerMissile createMissile:self.position enemyPos:targetEnemyPos];
        pMissile.ability_Attack = ability_Attack;//攻撃力を付与
        if(self.position.y<targetEnemyPos.y){
            zOrder=1;
        }else{
            zOrder=3;
        }
        [StageLevel_01 setPlayerMissile:pMissile zOrder:zOrder];
        
        //タンクアニメーション
        [self schedule:@selector(animalDance_Schedule:)interval:0.01];
    }
}

-(void)animalDance_Schedule:(CCTime)dt {
    
    vt += 0.1;
    vf=-g*vt+vi;
    y=((vi+vf)*vt)/2;
    
    //gSprite.position = ccp(gSprite.position.x, gSprite.position.y + y);
    
    if(self.rotationalSkewX==self.rotationalSkewY){
        offAngle = 360-self.rotation;
    }
    nextPos = CGPointMake(y*cosf(offAngle),y*sinf(offAngle));
    gSprite.position = CGPointMake(gSprite.position.x + nextPos.x, gSprite.position.y + nextPos.y);

    //if(gSprite.position.y < self.contentSize.height/2){
    if(vt>2.0){
        [self unschedule:@selector(animalDance_Schedule:)];
        gSprite.position=CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    }
}

-(void)onPause_To_Resume:(bool)flg{
    
    if(flg){
        [self unschedule:@selector(moveVehicle_Schedule:)];//移動スケジュール
        [self unschedule:@selector(moveGun_Schedule:)];//砲塔制御スケジュール開始
        [self unschedule:@selector(status_Schedule:)];//状態スケジュール
        [self unschedule:@selector(pFireMissile_Schedule:)];//ミサイル発射制御スケジュール
        [self unschedule:@selector(animalDance_Schedule:)];//タンクアニメーション
    }else{
        [self schedule:@selector(moveVehicle_Schedule:) interval:0.01];//移動スケジュール
        [self schedule:@selector(moveGun_Schedule:)interval:0.1];//砲塔制御スケジュール開始
        [self schedule:@selector(status_Schedule:)interval:0.1];//状態スケジュール
        [self schedule:@selector(pFireMissile_Schedule:)interval:1.5];//ミサイル発射制御スケジュール
    }
}

-(void)resumeRunning
{
    [self schedule:@selector(moveVehicle_Schedule:) interval:0.01];//移動スケジュール
}

//====================
//　プレイヤータンク作成
//====================
-(id)initWithPlayer:(CGPoint)playerPos playerNum:(int)playerNum{
    
    //初期化
    vFrameArray=[[NSMutableArray alloc]init];
    gFrameArray=[[NSMutableArray alloc]init];
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    
    //画像を配列に格納
    if(playerNum==1){
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bear_default.plist"];
        objName=@"beartank1";
    }else if(playerNum==2){
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bear2_default.plist"];
        objName=@"beartank2";
    }else if(playerNum==3){
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bear3_default.plist"];
        objName=@"beartank3";
    }else if(playerNum==4){
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bear4_default.plist"];
        objName=@"beartank4";
    }else if(playerNum==5){
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bear5_default.plist"];
        objName=@"beartank5";
    }
    
    for(int i=0;i<8;i++){
        [vFrameArray addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"v%02d.png",i]]];
        [gFrameArray addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"g%02d.png",i]]];
    }
    
    if(self=[super initWithSpriteFrame:[vFrameArray objectAtIndex:0]]){
        
        winSize = [[CCDirector sharedDirector]viewSize];
        self.position = playerPos;
        
        //各種能力の取得
        ability_Level=[ObjectManager load_Object_Ability_Level:objName];
        ability_Attack=[ObjectManager load_Object_Ability_Attack:objName];
        ability_Defense=[ObjectManager load_Object_Ability_Defense:objName];
        ability_Traveling=[ObjectManager load_Object_Ability_Traveling:objName];
        ability_Build=[ObjectManager load_Object_Ability_Build:objName];

        //ライフ初期値
        maxLife=ability_Defense;

        //砲塔の描画
        gSprite=[CCSprite spriteWithSpriteFrame:[gFrameArray objectAtIndex:0]];
        gSprite.position=CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:gSprite];
        
        //体力ゲージ描画
        lifeGauge1=[CCSprite spriteWithImageNamed:@"lifegauge1.png"];
        lifeGauge1.position=CGPointMake(self.contentSize.width/2, self.contentSize.height/2 - 25);
        //CCColor* color=[CCColor colorWithCcColor3b:ccc3(1.0, 1.0, 1.0)];
        //[lifeGauge1 setColor:color];
        [self addChild:lifeGauge1];
        
        lifeGauge2=[CCSprite spriteWithImageNamed:@"lifegauge2.png"];
        nowRatio=(100/maxLife)*ability_Defense;
        lifeGauge2.scaleX=nowRatio*0.01;
        lifeGauge2.position=CGPointMake((nowRatio*0.01)*(lifeGauge2.contentSize.width/2), lifeGauge2.contentSize.height/2);
        [lifeGauge1 addChild:lifeGauge2];
        
        //速度セット
        velocity = ability_Traveling;//補間間隔(速さの調整に使用する)
        //停止フラグ
        stopFlg=false;
        //敵捕捉フラグ
        enemySearchFlg=false;
        //経路作成フラグ
        state_PathMake_flg=false;
        //経路作成マーク
        arrow = [CCSprite spriteWithImageNamed:@"arrow.png"];
        arrow.rotation=180;
        [self addChild:arrow];
        arrow.visible=false;
        //撃破回収フラグ
        destCollectFlg=false;
        //砲塔制御スケジュール開始
        [self schedule:@selector(moveGun_Schedule:)interval:0.1];
        //状態スケジュール
        [self schedule:@selector(status_Schedule:)interval:0.1];
        //ミサイル発射制御スケジュール
        [self schedule:@selector(pFireMissile_Schedule:)interval:1.5];
    }
    return self;
}

+(id)createPlayer:(CGPoint)playerPos playerNum:(int)playerNum{

    return [[self alloc] initWithPlayer:playerPos playerNum:playerNum];
}

@end
