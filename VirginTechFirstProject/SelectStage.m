//
//  SelectStage.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/02.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "SelectStage.h"
#import "StageLevel_00.h"
#import "StageLevel_01.h"
#import "GameManager.h"
#import "TitleScene.h"

@implementation SelectStage

+ (SelectStage *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];

    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    // Helloworld scene button
    CCButton *button1 = [CCButton buttonWithTitle:@"[ステージレベル１]" fontName:@"Verdana-Bold" fontSize:18.0f];
    button1.positionType = CCPositionTypeNormalized;
    button1.position = ccp(0.5f, 0.7f);
    [button1 setTarget:self selector:@selector(onSpinningClicked1:)];
    [self addChild:button1];
    
    CCButton *button2 = [CCButton buttonWithTitle:@"[ステージレベル２]" fontName:@"Verdana-Bold" fontSize:18.0f];
    button2.positionType = CCPositionTypeNormalized;
    button2.position = ccp(0.5f, 0.6f);
    [button2 setTarget:self selector:@selector(onSpinningClicked2:)];
    //[self addChild:button2];
    
    // done
	return self;
}

- (void)onSpinningClicked1:(id)sender
{
    // start spinning scene with transition
    [GameManager setStageLevel:1];
    [[CCDirector sharedDirector] replaceScene:[StageLevel_01 scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

- (void)onSpinningClicked2:(id)sender
{
    // start spinning scene with transition
    //[[CCDirector sharedDirector] replaceScene:[StageLevel_02 scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    //[[CCDirector sharedDirector] replaceScene:[TitleScene scene]withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

@end
