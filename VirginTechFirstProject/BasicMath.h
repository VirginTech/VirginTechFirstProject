//
//  BasicMath.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/29.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicMath : NSObject

+(BOOL)RadiusContainsPoint:(CGPoint)pointA pointB:(CGPoint)pointB;
+(BOOL)RadiusIntersectsRadius:(CGPoint)pointA pointB:(CGPoint)pointB;

@end
