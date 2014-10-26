//
//  RouteGenerationLayer.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/03.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "RouteGenerationLayer.h"
#import "CCDrawingPrimitives.h"
#import "StageLevel_01.h"
#import "BasicMath.h"
#import "SoundManager.h"

@implementation RouteGenerationLayer

@synthesize player;
@synthesize offsetY;

CGSize winSize;
NSMutableArray* disPosArray;

+ (RouteGenerationLayer *)scene{
    
    return [[self alloc] init];
}

- (id)init
{    
    self = [super init];
    if (!self) return(nil);
    
    self.userInteractionEnabled = YES;
    winSize=[[CCDirector sharedDirector]viewSize];
    //データ初期化
    offsetY=0.0f;
    player.posArray=[[NSMutableArray alloc]init];
    
    return self;
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //効果音
    [SoundManager playerSet:player.groupNum];
    
    player.dr=0;
    player.moveCnt=0;
    player.stopFlg=false;
    player.posArray=[[NSMutableArray alloc]init];
    player.state_PathMake_flg=false;
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint worldLocation;
    CGPoint touchLocation = [touch locationInNode:self];
    worldLocation.x = touchLocation.x;
    worldLocation.y = touchLocation.y + offsetY;
    
    if(![BasicMath RadiusContainsPoint:player.position pointB:worldLocation radius:30]){
        NSValue *value = [NSValue valueWithCGPoint:worldLocation];
        [player.posArray addObject:value];
    }
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    //player.state_PathMake_flg=true;
    [self removeFromParentAndCleanup:YES];
}

-(void)draw{
    
    CGPoint pt1;
    CGPoint pt2;
    NSValue* value1;
    NSValue* value2;
    disPosArray=[[NSMutableArray alloc]init];
    
    if(!player.state_PathMake_flg){
        if(player.posArray.count>1){
            for(int i=0;i<player.posArray.count;i++){
                value1 = [player.posArray objectAtIndex:i];
                if(i==0){
                    value2 = [player.posArray objectAtIndex:i+1];
                    pt1 = [value1 CGPointValue];
                    pt2 = [value2 CGPointValue];
                    float angle = [BasicMath getAngle_To_Radian:pt1 ePos:pt2];
                    value1=[NSValue valueWithCGPoint:CGPointMake(30*cosf(angle) + pt1.x,30*sinf(angle) + pt1.y)];
                }
                [disPosArray addObject:value1];
            }
        }
        
        for(int i=1;i<disPosArray.count;i++){
            
            value1= [disPosArray objectAtIndex:i-1];
            value2= [disPosArray objectAtIndex:i];
            pt1=[value1 CGPointValue];
            pt2=[value2 CGPointValue];
            pt1.y -= offsetY;
            pt2.y -= offsetY;
            
            glLineWidth(10.0f);
            ccDrawColor4F(0.71f, 0.80f, 0.80f, 0.05f);
            ccDrawLine(pt1,pt2);
        }
    }
}

@end
