//
//  MessageLayer.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/08/09.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "MessageLayer.h"


@implementation MessageLayer

CGSize winSize;

+ (MessageLayer *)scene{
    
    return [[self alloc] init];
}

- (id)init:(int)type{
    
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    self.userInteractionEnabled = YES;
    _type=type;
    
    //BGカラー
    //CCNodeColor* background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.5f]];
    //[self addChild:background];
    
    msgBox=[CCSprite spriteWithImageNamed:@"msgBox.png"];
    msgBox.position=ccp(winSize.width/2,winSize.height/2);
    msgBox.scale=0.4;
    [self addChild:msgBox];
    
    title=[[CCLabelTTF alloc]initWithString:@"" fontName:@"Verdana-Bold" fontSize:13];
    title.position=ccp(winSize.width/2,winSize.height/2+20);
    [self addChild:title];
    
    message=[[CCLabelTTF alloc]initWithString:@"" fontName:@"Verdana-Bold" fontSize:15];
    message.position=ccp(winSize.width/2,winSize.height/2-20);
    [self addChild:message];
    
    return self;
}

-(void)setMessageBox:(NSString*)_title message:(NSString*)_message
{
    if(_type==0){//アチーブメント通知
        msgBox.scale=0.4;
        title.position=ccp(winSize.width/2,winSize.height/2+20);
        message.position=ccp(winSize.width/2,winSize.height/2-20);
    }else if(_type==1){//レベルアップ
        msgBox.scaleX=0.4;
        msgBox.scaleY=0.65;
        title.position=ccp(winSize.width/2,winSize.height/2+100);
        message.position=ccp(winSize.width/2,winSize.height/2+10);
    }
    
    title.string=_title;
    message.string=_message;
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(_type==0){//アチーブメント通知
        [self removeFromParentAndCleanup:YES];
    }
}

@end
