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

int t;
NSMutableArray* inpolPosArray;

-(void)moveTank:(NSMutableArray*)posArray{
    
    t=0;
    inpolPosArray=[[NSMutableArray alloc]init];
    
    //補間座標を取得
    inpolPosArray=[Player lineInterpolation:posArray];
    
    [self schedule:@selector(nextFrame:) interval:0.01];
}

- (void)nextFrame:(CCTime)dt{
    
    NSValue *value=[inpolPosArray objectAtIndex:t];
    CGPoint pt=[value CGPointValue];
    
    self.position=CGPointMake(pt.x, pt.y);
    
    if(inpolPosArray.count-1==t){
        [self unschedule:@selector(nextFrame:)];
    }
    t++;
}

//========================
//     直線補間関数
//========================
+(NSMutableArray*)lineInterpolation:(NSMutableArray*)posArray{
    
    float speed=0.5;//補間間隔(速さの調整に使用できるから"speed")
    
    NSValue *value1;
    NSValue *value2;
    CGPoint pt1;
    CGPoint pt2;
    float dx,dy;//差分距離ベクトル
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
        
        dx = pt2.x-pt1.x;
        dy = pt2.y-pt1.y;
        
        //斜辺角度
        angle=atanf(dy/dx);
        
        if(dx<0 && dy>0){//座標左上
            angle=M_PI+angle;
        }else if(dx<0 && dy<0){//座標左下
            angle=M_PI+angle;
        }else if(dx>0 && dy<0){//座標右下
            angle=M_PI*2+angle;
        }else{//座標右上（修正なし）
        }
        //斜辺距離(er)
        er=sqrtf(powf(dx,2)+powf(dy,2));
        dr=0.0;
        
        while(er>dr){
            inpolPos = CGPointMake(dr*cosf(angle),dr*sinf(angle));
            //Xが右→左で、Yに変化がない(左水平移動)場合に、Xがプラスされるバグを修正
            if(dx<0 && inpolPos.y==0.0f){
                if(inpolPos.x>0){
                    inpolPos.x = -inpolPos.x;
                    //NSLog(@"左移動中・・・ X=%f Y=%f",inpolPos.x,inpolPos.y);
                }
            }
            //pt1から補間分(inpolPos)を加える
            inpolPos.x=pt1.x+inpolPos.x;
            inpolPos.y=pt1.y+inpolPos.y;
            
            inpolVal = [NSValue valueWithCGPoint:inpolPos];
            [tmpArray addObject:inpolVal];
            
            dr=dr+speed;
        }
    }
    return tmpArray;
}

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
