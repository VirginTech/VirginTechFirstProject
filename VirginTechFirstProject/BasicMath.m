//
//  BasicMath.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/29.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import "BasicMath.h"

@implementation BasicMath

+(BOOL)RadiusContainsPoint:(CGPoint)pointA pointB:(CGPoint)pointB{
    
    BOOL flg=false;
    float radius=30.0;
    if(sqrtf(powf((pointB.x-pointA.x),2)+powf((pointB.y-pointA.y),2))<=radius){
        flg=true;
    }
    return  flg;
}

+(BOOL)RadiusIntersectsRadius:(CGPoint)pointA pointB:(CGPoint)pointB{
    
    BOOL flg=false;
    float radius1=20.0;
    float radius2=20.0;
    if(sqrtf(powf((pointB.x-pointA.x),2)+powf((pointB.y-pointA.y),2))<=radius1+radius2){
        flg=true;
    }
    return  flg;
}


@end
