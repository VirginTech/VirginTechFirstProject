//
//  MessageLayer.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/08/09.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MessageLayer : CCScene {
    
    CCSprite* msgBox;
    CCLabelTTF* title;
    CCLabelTTF* message;
}

+ (MessageLayer *)scene;
- (id)init;

-(void)setMessageBox:(NSString*)_title message:(NSString*)_message;

@end
