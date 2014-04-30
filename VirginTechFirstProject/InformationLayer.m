//
//  Information.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/30.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "InformationLayer.h"
#import "CCDrawingPrimitives.h"

@implementation InformationLayer

CGSize winSize;

+ (InformationLayer *)scene{
    
    return [[self alloc] init];
}

- (id)init{
    
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    return self;
}

-(void)draw{
    
    //陣地ライン
    glLineWidth(10.0f);
    ccDrawColor4F(0.13f, 0.55f, 0.13f, 1.00f);
    ccDrawLine(CGPointMake(0.0, winSize.height/4), CGPointMake(winSize.width, winSize.height/4));
}

@end
