//
//  PreferencesLayer.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/14.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "PreferencesLayer.h"


@implementation PreferencesLayer

CGSize winSize;

+(PreferencesLayer *)scene{
    
    return [[self alloc] init];
}

-(id)init{
    
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //BGカラー
    CCNodeColor* background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    //閉じる
    CCButton *closeButton = [CCButton buttonWithTitle:@"[閉じる]" fontName:@"Verdana-Bold" fontSize:18.0f];
    closeButton.positionType = CCPositionTypeNormalized;
    closeButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [closeButton setTarget:self selector:@selector(onCloseClicked:)];
    [self addChild:closeButton];
    
    return self;
}

-(void)onCloseClicked:(id)sender
{
    [self removeFromParentAndCleanup:YES];
}

@end
