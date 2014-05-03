//
//  RouteGenerationLayer.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/03.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "RouteGenerationLayer.h"


@implementation RouteGenerationLayer

CGSize winSize;

+ (RouteGenerationLayer *)scene{
    
    return [[self alloc] init];
}

- (id)init{
    
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    

    
    return self;
}

@end
