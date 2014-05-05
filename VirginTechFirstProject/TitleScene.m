//
//  StartScene.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/26.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "TitleScene.h"
//#import "HelloWorldScene.h"
#import "SelectStage.h"
#import "GameManager.h"

@implementation TitleScene

+ (TitleScene *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    //デバイス登録
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if(screenBounds.size.height==568){ //iPhone5 (4インチスクリーン)用のレイアウト
        [GameManager setDevice:1];
    }else if(screenBounds.size.height==480){ //iPhone4 (3.5インチスクリーン)用のレイアウト
        [GameManager setDevice:2];
    }else if(screenBounds.size.height==1024){ //iPad2 (1024px)
        [GameManager setDevice:3];
    }else{
        [GameManager setDevice:0];
    }
    //NSLog(@"デバイスは %d です。",[GameManager getDevice]);
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // タイトル
    CCLabelTTF *label = [CCLabelTTF labelWithString:
                                NSLocalizedString(@"Title",NULL) fontName:@"Chalkduster" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.5f); // Middle of screen
    [self addChild:label];
    
    // Helloworld scene button
    CCButton *helloWorldButton = [CCButton buttonWithTitle:@"[ スタート ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    helloWorldButton.positionType = CCPositionTypeNormalized;
    helloWorldButton.position = ccp(0.5f, 0.35f);
    [helloWorldButton setTarget:self selector:@selector(onSpinningClicked:)];
    [self addChild:helloWorldButton];
    
    // done
	return self;
}

- (void)onSpinningClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[SelectStage scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
    //[[CCDirector sharedDirector] replaceScene:[Level_00 scene]withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

@end
