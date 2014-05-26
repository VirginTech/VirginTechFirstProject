//
//  Fortress.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/26.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "Fortress.h"


@implementation Fortress

CGSize winSize;

-(id)initWithFortress:(CGPoint)pos
{
    winSize=[[CCDirector sharedDirector]viewSize];

    if(self=[super initWithImageNamed:@"fortress.png"]){
    
        self.position=pos;
    
    
    }
    return self;
}

+(id)createFortress:(CGPoint)pos
{
    return [[self alloc] initWithFortress:pos];
}

@end
