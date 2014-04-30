//
//  RouteDispLayer.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/26.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "RouteDispLayer.h"
#import "CCDrawingPrimitives.h"


@implementation RouteDispLayer

@synthesize posArray;

CGSize winSize;

+ (RouteDispLayer *)scene{
    
    return [[self alloc] init];
}

- (id)init{
    
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    return self;
}

-(void)onEnter{
    
    [super onEnter];
}

-(void)draw{
    
    for(int i=1;i<posArray.count;i++){
        
        NSValue *value1= [posArray objectAtIndex:i-1];
        NSValue *value2= [posArray objectAtIndex:i];
        CGPoint pt1=[value1 CGPointValue];
        CGPoint pt2=[value2 CGPointValue];
        
        glLineWidth(100.0f);
        ccDrawColor4F(1.00f, 1.00f, 1.00f, 0.50f);
        ccDrawLine(pt1,pt2);
        //ccDrawColor4F(1.0f, 1.0f, 1.0f, 1.0f);
        //ccDrawCircle(pt1,1.5,1,10,true);
        
    }
}

@end
