//
//  PlayerSelection.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/30.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "PlayerSelection.h"
#import "GameManager.h"
#import "StageLevel_00.h"

@implementation PlayerSelection

CGSize winSize;
CCSprite* bg;
//CCScrollView* scrollview;
NSMutableArray* animalArray2;

+ (PlayerSelection *)scene{
    
    return [[self alloc] init];
}

- (id)init{
    
    animalArray2=[[NSMutableArray alloc]init];

    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"interface_default.plist"];
    bg=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"playerselect.png"]];
    

    CCSprite* animal01=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal01.png"]];
    CCSprite* animal02=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal02.png"]];
    CCSprite* animal03=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal03.png"]];
    CCSprite* animal04=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal04.png"]];
    CCSprite* animal05=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal05.png"]];

    animal01.position=CGPointMake(animal01.contentSize.width/2, animal01.contentSize.height/2+10);
    animal02.position=CGPointMake(animal02.contentSize.width+60, animal02.contentSize.height/2+10);
    animal03.position=CGPointMake(animal03.contentSize.width*2+60, animal03.contentSize.height/2+10);
    animal04.position=CGPointMake(animal04.contentSize.width*3+60, animal04.contentSize.height/2+10);
    animal05.position=CGPointMake(animal05.contentSize.width*4+60, animal05.contentSize.height/2+10);

    animal01.name=@"animal01";
    animal02.name=@"animal02";
    animal03.name=@"animal03";
    animal04.name=@"animal04";
    animal05.name=@"animal05";
    
    [animalArray2 addObject:animal01];
    [animalArray2 addObject:animal02];
    [animalArray2 addObject:animal03];
    [animalArray2 addObject:animal04];
    [animalArray2 addObject:animal05];
    
    [bg addChild:animal01];
    [bg addChild:animal02];
    [bg addChild:animal03];
    [bg addChild:animal04];
    [bg addChild:animal05];
    
    self = [super initWithContentNode:bg];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    self.verticalScrollEnabled=NO;
    
    // Create a colored background (Dark Grey)
    //CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.5f]];
    //[self addChild:background];

    return self;
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
    int i=0;
    CGPoint touchLocation = [touch locationInNode:self];
    touchLocation.x+=self.scrollPosition.x;
    touchLocation.y+=self.scrollPosition.y;
    
    CGRect frmRect;
    for(CCSprite* frame in animalArray2){
        
        i++;
        
        if([GameManager getDevice]==1){
            frmRect=CGRectMake(frame.position.x - frame.contentSize.width/2,
                               frame.position.y + frame.contentSize.height/2,
                               frame.contentSize.width,
                               frame.contentSize.height);
        }else if([GameManager getDevice]==2){
            frmRect=CGRectMake(frame.position.x - frame.contentSize.width/2,
                               frame.position.y + frame.contentSize.height/2,
                               frame.contentSize.width,
                               frame.contentSize.height);
        }else if([GameManager getDevice]==3){
            frmRect=CGRectMake(frame.position.x - frame.contentSize.width/2,
                               frame.position.y + frame.contentSize.height/2,
                               frame.contentSize.width,
                               frame.contentSize.height);
        }else{
            frmRect=CGRectMake(frame.position.x - frame.contentSize.width/2,
                               frame.position.y + frame.contentSize.height/2,
                               frame.contentSize.width,
                               frame.contentSize.height);
        }
        
        if(CGRectContainsPoint(frmRect, touchLocation)){
            //NSLog(@"ヒット！=%@",frame.name);
            [StageLevel_00 setCreatePlayerFlg:true];
            [StageLevel_00 setSelectPlayerNum:i];
            break;
        }else{
            [StageLevel_00 setCreatePlayerFlg:false];
            [StageLevel_00 setSelectPlayerNum:0];//なし
        }
    }
    self.visible=false;
}

@end
