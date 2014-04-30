//
//  BasicMath.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/29.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import "BasicMath.h"

@implementation BasicMath

+(BOOL)RadiusContainsPoint:(CGPoint)pointA pointB:(CGPoint)pointB radius:(float)radius{
    
    BOOL flg=false;
    
    if(sqrtf(powf((pointB.x-pointA.x),2)+powf((pointB.y-pointA.y),2))<=radius){
        flg=true;
    }
    return  flg;
}

+(BOOL)RadiusIntersectsRadius:(CGPoint)pointA pointB:(CGPoint)pointB
                                                radius1:(float)radius1 radius2:(float)radius2{
    
    BOOL flg=false;

    if(sqrtf(powf((pointB.x-pointA.x),2)+powf((pointB.y-pointA.y),2))<=radius1+radius2){
        flg=true;
    }
    return  flg;
}


@end
