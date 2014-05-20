//
//  PlayerSelection.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/30.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCScrollView.h"

@interface PlayerSelection : CCScrollView {
    
    CGPoint createPlayerPos;
}

@property CGPoint createPlayerPos;

+ (PlayerSelection *)scene;
- (id)init;

-(void)setButtonLevel;
-(void)setArrowVisible:(float)offsetY;

@end
