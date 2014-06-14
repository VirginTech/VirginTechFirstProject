//
//  PlayerSelection.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/30.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "PlayerSelection.h"
#import "GameManager.h"
#import "ObjectManager.h"
#import "StageLevel_01.h"
#import "TutorialLevel.h"
#import "BasicMath.h"

@implementation PlayerSelection

@synthesize createPlayerPos;

CGSize winSize;
CCSprite* bgSprite;
CCSprite* arrow;
int afterCoin;
int serialCount1;
int serialCount2;

CCScrollView* scrollView;

CCLabelTTF* label01;
CCLabelTTF* label02;
CCLabelTTF* label03;
CCLabelTTF* label04;
CCLabelTTF* label05;

+ (PlayerSelection *)scene{
    
    return [[self alloc] init];
}

- (id)init{
    
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    self.userInteractionEnabled = YES;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"interface_default.plist"];
    bgSprite=[CCSprite spriteWithSpriteFrame:
                    [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"playerselect.png"]];

    CCButton* animal01=[CCButton buttonWithTitle:@""
                    spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal01.png"]];
    CCButton* animal02=[CCButton buttonWithTitle:@""
                    spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal02.png"]];
    CCButton* animal03=[CCButton buttonWithTitle:@""
                    spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal03.png"]];
    CCButton* animal04=[CCButton buttonWithTitle:@""
                    spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal04.png"]];
    CCButton* animal05=[CCButton buttonWithTitle:@""
                    spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal05.png"]];

    [animal01 setTarget:self selector:@selector(onAnimal01_Clicked:)];
    [animal02 setTarget:self selector:@selector(onAnimal02_Clicked:)];
    [animal03 setTarget:self selector:@selector(onAnimal03_Clicked:)];
    [animal04 setTarget:self selector:@selector(onAnimal04_Clicked:)];
    [animal05 setTarget:self selector:@selector(onAnimal05_Clicked:)];
    
    animal01.position=CGPointMake(80,                               120);
    animal02.position=CGPointMake(bgSprite.contentSize.width/2-150, 120);
    animal03.position=CGPointMake(bgSprite.contentSize.width/2,     120);
    animal04.position=CGPointMake(bgSprite.contentSize.width/2+150, 120);
    animal05.position=CGPointMake(bgSprite.contentSize.width/2+300, 120);

    [bgSprite addChild:animal01];
    [bgSprite addChild:animal02];
    [bgSprite addChild:animal03];
    [bgSprite addChild:animal04];
    [bgSprite addChild:animal05];
    
    //レベルラベル
    label01=[CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:30.0f];
    label01.color = [CCColor blueColor];
    label01.position=CGPointMake(animal01.contentSize.width/2,animal01.contentSize.height+20);
    [animal01 addChild:label01];
    
    label02=[CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:30.0f];
    label02.color = [CCColor blueColor];
    label02.position=CGPointMake(animal02.contentSize.width/2,animal02.contentSize.height+20);
    [animal02 addChild:label02];

    label03=[CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:30.0f];
    label03.color = [CCColor blueColor];
    label03.position=CGPointMake(animal03.contentSize.width/2,animal03.contentSize.height+20);
    [animal03 addChild:label03];

    label04=[CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:30.0f];
    label04.color = [CCColor blueColor];
    label04.position=CGPointMake(animal04.contentSize.width/2,animal04.contentSize.height+20);
    [animal04 addChild:label04];

    label05=[CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:30.0f];
    label05.color = [CCColor blueColor];
    label05.position=CGPointMake(animal05.contentSize.width/2,animal05.contentSize.height+20);
    [animal05 addChild:label05];

    //スクロールビュー
    scrollView=[[CCScrollView alloc]initWithContentNode:bgSprite];
    scrollView.verticalScrollEnabled=NO;
    scrollView.mode=1;
    [self addChild:scrollView];
    
    //ラベル表示
    [self setButtonLevel];
    
    //チュートリアル
    if([GameManager getStageLevel]==0)
    {
        velocity = 1.5;
        touchCount=0;
        targetPos=CGPointMake(150, 150);
        
        finger=[CCSprite spriteWithSpriteFrame:
                            [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"finger.png"]];
        finger.position=CGPointMake(winSize.width/2, winSize.height/2+50);
        [self addChild:finger];
        [self schedule:@selector(finger_Rotation_Schedule:)interval:0.01];
    }
    
    //矢印初期化
    arrow=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"arrow.png"]];
    [self addChild:arrow];
    
    //連続カウント初期化
    serialCount1=0;
    serialCount2=0;
    
    return self;
}

-(void)setButtonLevel
{
    label01.string=[NSString stringWithFormat:@"Lv.%d",[ObjectManager load_Object_Ability_Level:@"player01"]];
    label02.string=[NSString stringWithFormat:@"Lv.%d",[ObjectManager load_Object_Ability_Level:@"player02"]];
    label03.string=[NSString stringWithFormat:@"Lv.%d",[ObjectManager load_Object_Ability_Level:@"player03"]];
    label04.string=[NSString stringWithFormat:@"Lv.%d",[ObjectManager load_Object_Ability_Level:@"player04"]];
    label05.string=[NSString stringWithFormat:@"Lv.%d",[ObjectManager load_Object_Ability_Level:@"player05"]];
}

-(void)setArrowVisible:(float)offsetY
{    
    //arrow.rotation=180;
    arrow.position=CGPointMake(createPlayerPos.x, createPlayerPos.y - offsetY - arrow.contentSize.height/2);
    //arrow.visible=true;
}

-(void)finger_Move_Schedule:(CCTime)dt
{
    CGPoint nextPos;
    float targetAngle;
    float targetDistance;
    
    //方角セット
    targetAngle = [BasicMath getAngle_To_Radian:finger.position ePos:targetPos];
    //総距離セット
    targetDistance = sqrtf(powf(finger.position.x - targetPos.x,2) + powf(finger.position.y - targetPos.y,2));
    //次位置セット
    nextPos=CGPointMake(velocity*cosf(targetAngle),velocity*sinf(targetAngle));
    finger.position=CGPointMake(finger.position.x+nextPos.x, finger.position.y+nextPos.y);
    
    if(targetDistance < 5.0){
        [self unschedule:@selector(finger_Move_Schedule:)];
        [self schedule:@selector(finger_Rotation_Schedule:)interval:0.01];
    }
}

-(void)finger_Rotation_Schedule:(CCTime)dt
{
    if(finger.rotation<15){
        finger.rotation=finger.rotation+0.3;
    }else{
        finger.rotation=0;
    }
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    scrollView.scrollViewDeacceleration=0.3;
}

//-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
//
//}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
    CGPoint touchLocation = [touch locationInNode:self];
    if(touchLocation.y<winSize.height-bgSprite.contentSize.height ||
                                                touchLocation.y>bgSprite.contentSize.height){
        [self removeFromParentAndCleanup:YES];
        if([GameManager getStageLevel]==0){
            [TutorialLevel setFinger];
        }
    }
}

-(void)playerSet:(int)type
{
    CGPoint tmpPos=createPlayerPos;
    if(serialCount1==0){
        if([GameManager getStageLevel]==0){
            [TutorialLevel createPlayer:tmpPos playerNum:type];
        }else{
            [StageLevel_01 createPlayer:tmpPos playerNum:type];
        }
    }else if(serialCount1%2==0){
        tmpPos.x=createPlayerPos.x - (serialCount2*50);
        if(tmpPos.x > 30.0f){
            if([GameManager getStageLevel]==0){
                [TutorialLevel createPlayer:tmpPos playerNum:type];
            }else{
                [StageLevel_01 createPlayer:tmpPos playerNum:type];
            }
        }else{
            [self removeFromParentAndCleanup:YES];
        }
    }else if(serialCount1%2!=0){
        serialCount2++;
        tmpPos.x=createPlayerPos.x + (serialCount2*50);
        if(tmpPos.x < winSize.width-30){
            if([GameManager getStageLevel]==0){
                [TutorialLevel createPlayer:tmpPos playerNum:type];
            }else{
                [StageLevel_01 createPlayer:tmpPos playerNum:type];
            }
        }else{
            [self removeFromParentAndCleanup:YES];
        }
    }
    serialCount1++;
}

-(void)onAnimal01_Clicked:(id)sender
{
    if([GameManager getStageLevel]==0){
        [self playerSet:1];
        touchCount++;
        if(touchCount>=3){
            [self unschedule:@selector(finger_Rotation_Schedule:)];
            [self schedule:@selector(finger_Move_Schedule:)interval:0.01];
        }
    }else{
        afterCoin = [GameManager load_Currency_Coin] - 1;
        if(afterCoin >= 0){
            [self playerSet:1];
        }else{
            [self showMassage];
        }
    }
}
-(void)onAnimal02_Clicked:(id)sender
{
    if([GameManager getStageLevel]==0){
        [self playerSet:2];
        touchCount++;
        if(touchCount>=3){
            [self unschedule:@selector(finger_Rotation_Schedule:)];
            [self schedule:@selector(finger_Move_Schedule:)interval:0.01];
        }
    }else{
        afterCoin = [GameManager load_Currency_Coin] - 2;
        if(afterCoin >= 0){
            [self playerSet:2];
        }else{
            [self showMassage];
        }
    }
}
-(void)onAnimal03_Clicked:(id)sender
{
    if([GameManager getStageLevel]==0){
        [self playerSet:3];
        touchCount++;
        if(touchCount>=3){
            [self unschedule:@selector(finger_Rotation_Schedule:)];
            [self schedule:@selector(finger_Move_Schedule:)interval:0.01];
        }
    }else{
        afterCoin = [GameManager load_Currency_Coin] - 3;
        if(afterCoin >= 0){
            [self playerSet:3];
        }else{
            [self showMassage];
        }
    }
}
-(void)onAnimal04_Clicked:(id)sender
{
    if([GameManager getStageLevel]==0){
        [self playerSet:4];
        touchCount++;
        if(touchCount>=3){
            [self unschedule:@selector(finger_Rotation_Schedule:)];
            [self schedule:@selector(finger_Move_Schedule:)interval:0.01];
        }
    }else{
        afterCoin = [GameManager load_Currency_Coin] - 4;
        if(afterCoin >= 0){
            [self playerSet:4];
        }else{
            [self showMassage];
        }
    }
}
-(void)onAnimal05_Clicked:(id)sender
{
    if([GameManager getStageLevel]==0){
        [self playerSet:5];
        touchCount++;
        if(touchCount>=3){
            [self unschedule:@selector(finger_Rotation_Schedule:)];
            [self schedule:@selector(finger_Move_Schedule:)interval:0.01];
        }
    }else{
        afterCoin = [GameManager load_Currency_Coin] - 5;
        if(afterCoin >= 0){
            [self playerSet:5];
        }else{
            [self showMassage];
        }
    }
}

-(void)showMassage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CoinShortage",NULL)
                                                    message:NSLocalizedString(@"BarterCoin",NULL)
                                                    delegate:nil
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"OK",NULL),
                                                    nil];
    [alert show];
}

@end
