//
//  ItemSetupLayer.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/21.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "ItemSetupLayer.h"
#import "CCScrollView.h"
#import "GameManager.h"
#import "ObjectManager.h"
#import "InformationLayer.h"
#import "AchievementManeger.h"
#import "SoundManager.h"

@implementation ItemSetupLayer

CGSize winSize;
int afterDia;

CCScrollView* scrollView;

CCLabelTTF* label01;
CCLabelTTF* label02;
CCLabelTTF* label03;
CCLabelTTF* label04;
CCLabelTTF* label05;

CCLabelTTF* label01_Attack;
CCLabelTTF* label01_Defense;
CCLabelTTF* label01_Traveling;
CCLabelTTF* label01_UnderWater;

CCLabelTTF* label02_Attack;
CCLabelTTF* label02_Defense;
CCLabelTTF* label02_Traveling;
CCLabelTTF* label02_UnderWater;

CCLabelTTF* label03_Attack;
CCLabelTTF* label03_Defense;
CCLabelTTF* label03_Traveling;
CCLabelTTF* label03_UnderWater;

CCLabelTTF* label04_Attack;
CCLabelTTF* label04_Defense;
CCLabelTTF* label04_Traveling;
CCLabelTTF* label04_UnderWater;

CCLabelTTF* label05_Attack;
CCLabelTTF* label05_Defense;
CCLabelTTF* label05_Traveling;
CCLabelTTF* label05_UnderWater;

+ (ItemSetupLayer *)scene
{
    return [[self alloc] init];
}

- (id)init
{    
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    self.userInteractionEnabled = YES;

    //BGカラー
    CCNodeColor* background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"interface_default.plist"];
    
    CCSprite* bgSprite=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"playerselect.png"]];
    
    CCSprite* animal01=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal01.png"]];;
    CCSprite* animal02=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal02.png"]];;
    CCSprite* animal03=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal03.png"]];;
    CCSprite* animal04=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal04.png"]];;
    CCSprite* animal05=[CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"animal05.png"]];;
    
    animal01.position=CGPointMake(80,                               170);
    animal02.position=CGPointMake(bgSprite.contentSize.width/2-150, 170);
    animal03.position=CGPointMake(bgSprite.contentSize.width/2,     170);
    animal04.position=CGPointMake(bgSprite.contentSize.width/2+150, 170);
    animal05.position=CGPointMake(bgSprite.contentSize.width/2+300, 170);
    
    //パワーアップボタン
    CCButton* setBtn01=[CCButton buttonWithTitle:[NSString stringWithFormat:@" ×1%@",NSLocalizedString(@"LevelUp",NULL)]
                        spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"levelupBtn.png"]];
    setBtn01.position=ccp(animal01.contentSize.width/2, -75);
    setBtn01.scale=0.7;
    [setBtn01 setTarget:self selector:@selector(onSetBtn01_Clicked:)];
    [animal01 addChild:setBtn01];
    CCSprite* dia01=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"diamond.png"]];
    dia01.position=ccp(15,setBtn01.contentSize.height/2);
    dia01.scale=0.15;
    [setBtn01 addChild:dia01];
    
    CCButton* setBtn02=[CCButton buttonWithTitle:[NSString stringWithFormat:@" ×1%@",NSLocalizedString(@"LevelUp",NULL)]
                        spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"levelupBtn.png"]];
    setBtn02.position=ccp(animal02.contentSize.width/2, -75);
    setBtn02.scale=0.7;
    [setBtn02 setTarget:self selector:@selector(onSetBtn02_Clicked:)];
    [animal02 addChild:setBtn02];
    CCSprite* dia02=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"diamond.png"]];
    dia02.position=ccp(15,setBtn02.contentSize.height/2);
    dia02.scale=0.15;
    [setBtn02 addChild:dia02];

    CCButton* setBtn03=[CCButton buttonWithTitle:[NSString stringWithFormat:@" ×1%@",NSLocalizedString(@"LevelUp",NULL)]
                        spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"levelupBtn.png"]];
    setBtn03.position=ccp(animal03.contentSize.width/2, -75);
    setBtn03.scale=0.7;
    [setBtn03 setTarget:self selector:@selector(onSetBtn03_Clicked:)];
    [animal03 addChild:setBtn03];
    CCSprite* dia03=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"diamond.png"]];
    dia03.position=ccp(15,setBtn03.contentSize.height/2);
    dia03.scale=0.15;
    [setBtn03 addChild:dia03];
    
    CCButton* setBtn04=[CCButton buttonWithTitle:[NSString stringWithFormat:@" ×1%@",NSLocalizedString(@"LevelUp",NULL)]
                        spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"levelupBtn.png"]];
    setBtn04.position=ccp(animal04.contentSize.width/2, -75);
    setBtn04.scale=0.7;
    [setBtn04 setTarget:self selector:@selector(onSetBtn04_Clicked:)];
    [animal04 addChild:setBtn04];
    CCSprite* dia04=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"diamond.png"]];
    dia04.position=ccp(15,setBtn04.contentSize.height/2);
    dia04.scale=0.15;
    [setBtn04 addChild:dia04];
    
    CCButton* setBtn05=[CCButton buttonWithTitle:[NSString stringWithFormat:@" ×1%@",NSLocalizedString(@"LevelUp",NULL)]
                        spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"levelupBtn.png"]];
    setBtn05.position=ccp(animal05.contentSize.width/2, -75);
    setBtn05.scale=0.7;
    [setBtn05 setTarget:self selector:@selector(onSetBtn05_Clicked:)];
    [animal05 addChild:setBtn05];
    CCSprite* dia05=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"diamond.png"]];
    dia05.position=ccp(15,setBtn05.contentSize.height/2);
    dia05.scale=0.15;
    [setBtn05 addChild:dia05];

    //レベルラベル
    label01=[CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:30.0f];
    label01.color = [CCColor blueColor];
    label01.position=CGPointMake(animal01.contentSize.width/2,animal01.contentSize.height);
    [animal01 addChild:label01];
    
    label02=[CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:30.0f];
    label02.color = [CCColor blueColor];
    label02.position=CGPointMake(animal02.contentSize.width/2,animal02.contentSize.height);
    [animal02 addChild:label02];
    
    label03=[CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:30.0f];
    label03.color = [CCColor blueColor];
    label03.position=CGPointMake(animal03.contentSize.width/2,animal03.contentSize.height);
    [animal03 addChild:label03];
    
    label04=[CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:30.0f];
    label04.color = [CCColor blueColor];
    label04.position=CGPointMake(animal04.contentSize.width/2,animal04.contentSize.height);
    [animal04 addChild:label04];
    
    label05=[CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:30.0f];
    label05.color = [CCColor blueColor];
    label05.position=CGPointMake(animal05.contentSize.width/2,animal05.contentSize.height);
    [animal05 addChild:label05];
    
    [bgSprite addChild:animal01];
    [bgSprite addChild:animal02];
    [bgSprite addChild:animal03];
    [bgSprite addChild:animal04];
    [bgSprite addChild:animal05];

    //レベルセット
    [self setButtonLevel];
    
    //アビリティ表示
    label01_Attack=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@:0000",NSLocalizedString(@"Attack",NULL)] fontName:@"Verdana-Bold" fontSize:10.0f];
    label01_Attack.color=[CCColor blackColor];
    label01_Attack.position=CGPointMake(animal01.contentSize.width/2, -10);
    [animal01 addChild:label01_Attack];
    
    label01_Defense=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@:0000",NSLocalizedString(@"Defense",NULL)] fontName:@"Verdana-Bold" fontSize:10.0f];
    label01_Defense.color=[CCColor blackColor];
    label01_Defense.position=CGPointMake(animal01.contentSize.width/2, -20);
    [animal01 addChild:label01_Defense];
    
    label01_Traveling=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@:0000",NSLocalizedString(@"Move",NULL)] fontName:@"Verdana-Bold" fontSize:10.0f];
    label01_Traveling.color=[CCColor blackColor];
    label01_Traveling.position=CGPointMake(animal01.contentSize.width/2, -30);
    [animal01 addChild:label01_Traveling];
    
    label01_UnderWater=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@:0000",NSLocalizedString(@"Underwater",NULL)] fontName:@"Verdana-Bold" fontSize:10.0f];
    label01_UnderWater.color=[CCColor blackColor];
    label01_UnderWater.position=CGPointMake(animal01.contentSize.width/2, -40);
    [animal01 addChild:label01_UnderWater];
    
    label02_Attack=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@:0000",NSLocalizedString(@"Attack",NULL)] fontName:@"Verdana-Bold" fontSize:10.0f];
    label02_Attack.color=[CCColor blackColor];
    label02_Attack.position=CGPointMake(animal01.contentSize.width/2, -10);
    [animal02 addChild:label02_Attack];
    
    label02_Defense=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@:0000",NSLocalizedString(@"Defense",NULL)] fontName:@"Verdana-Bold" fontSize:10.0f];
    label02_Defense.color=[CCColor blackColor];
    label02_Defense.position=CGPointMake(animal01.contentSize.width/2, -20);
    [animal02 addChild:label02_Defense];
    
    label02_Traveling=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@:0000",NSLocalizedString(@"Move",NULL)] fontName:@"Verdana-Bold" fontSize:10.0f];
    label02_Traveling.color=[CCColor blackColor];
    label02_Traveling.position=CGPointMake(animal01.contentSize.width/2, -30);
    [animal02 addChild:label02_Traveling];

    label02_UnderWater=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@:0000",NSLocalizedString(@"Underwater",NULL)] fontName:@"Verdana-Bold" fontSize:10.0f];
    label02_UnderWater.color=[CCColor blackColor];
    label02_UnderWater.position=CGPointMake(animal01.contentSize.width/2, -40);
    [animal02 addChild:label02_UnderWater];
    
    label03_Attack=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@:0000",NSLocalizedString(@"Attack",NULL)] fontName:@"Verdana-Bold" fontSize:10.0f];
    label03_Attack.color=[CCColor blackColor];
    label03_Attack.position=CGPointMake(animal01.contentSize.width/2, -10);
    [animal03 addChild:label03_Attack];
    
    label03_Defense=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@:0000",NSLocalizedString(@"Defense",NULL)] fontName:@"Verdana-Bold" fontSize:10.0f];
    label03_Defense.color=[CCColor blackColor];
    label03_Defense.position=CGPointMake(animal01.contentSize.width/2, -20);
    [animal03 addChild:label03_Defense];
    
    label03_Traveling=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@:0000",NSLocalizedString(@"Move",NULL)] fontName:@"Verdana-Bold" fontSize:10.0f];
    label03_Traveling.color=[CCColor blackColor];
    label03_Traveling.position=CGPointMake(animal01.contentSize.width/2, -30);
    [animal03 addChild:label03_Traveling];

    label03_UnderWater=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@:0000",NSLocalizedString(@"Underwater",NULL)] fontName:@"Verdana-Bold" fontSize:10.0f];
    label03_UnderWater.color=[CCColor blackColor];
    label03_UnderWater.position=CGPointMake(animal01.contentSize.width/2, -40);
    [animal03 addChild:label03_UnderWater];
    
    label04_Attack=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@:0000",NSLocalizedString(@"Attack",NULL)] fontName:@"Verdana-Bold" fontSize:10.0f];
    label04_Attack.color=[CCColor blackColor];
    label04_Attack.position=CGPointMake(animal01.contentSize.width/2, -10);
    [animal04 addChild:label04_Attack];
    
    label04_Defense=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@:0000",NSLocalizedString(@"Defense",NULL)] fontName:@"Verdana-Bold" fontSize:10.0f];
    label04_Defense.color=[CCColor blackColor];
    label04_Defense.position=CGPointMake(animal01.contentSize.width/2, -20);
    [animal04 addChild:label04_Defense];
    
    label04_Traveling=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@:0000",NSLocalizedString(@"Move",NULL)] fontName:@"Verdana-Bold" fontSize:10.0f];
    label04_Traveling.color=[CCColor blackColor];
    label04_Traveling.position=CGPointMake(animal01.contentSize.width/2, -30);
    [animal04 addChild:label04_Traveling];

    label04_UnderWater=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@:0000",NSLocalizedString(@"Underwater",NULL)] fontName:@"Verdana-Bold" fontSize:10.0f];
    label04_UnderWater.color=[CCColor blackColor];
    label04_UnderWater.position=CGPointMake(animal01.contentSize.width/2, -40);
    [animal04 addChild:label04_UnderWater];
    
    label05_Attack=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@:0000",NSLocalizedString(@"Attack",NULL)] fontName:@"Verdana-Bold" fontSize:10.0f];
    label05_Attack.color=[CCColor blackColor];
    label05_Attack.position=CGPointMake(animal01.contentSize.width/2, -10);
    [animal05 addChild:label05_Attack];
    
    label05_Defense=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@:0000",NSLocalizedString(@"Defense",NULL)] fontName:@"Verdana-Bold" fontSize:10.0f];
    label05_Defense.color=[CCColor blackColor];
    label05_Defense.position=CGPointMake(animal01.contentSize.width/2, -20);
    [animal05 addChild:label05_Defense];
    
    label05_Traveling=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@:0000",NSLocalizedString(@"Move",NULL)] fontName:@"Verdana-Bold" fontSize:10.0f];
    label05_Traveling.color=[CCColor blackColor];
    label05_Traveling.position=CGPointMake(animal01.contentSize.width/2, -30);
    [animal05 addChild:label05_Traveling];

    label05_UnderWater=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@:0000",NSLocalizedString(@"Underwater",NULL)] fontName:@"Verdana-Bold" fontSize:10.0f];
    label05_UnderWater.color=[CCColor blackColor];
    label05_UnderWater.position=CGPointMake(animal01.contentSize.width/2, -40);
    [animal05 addChild:label05_UnderWater];

    [self setAbility];
    
    //スクロールビュー
    scrollView=[[CCScrollView alloc]initWithContentNode:bgSprite];
    scrollView.verticalScrollEnabled=NO;
    scrollView.mode=1;
    [self addChild:scrollView];
    
    //閉じるボタン
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button_default.plist"];
    CCButton *closeButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                    [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"close.png"]];
    closeButton.positionType = CCPositionTypeNormalized;
    closeButton.position = ccp(0.9f, 0.95f); // Top Right of screen
    closeButton.scale=0.3;
    [closeButton setTarget:self selector:@selector(onCloseClicked:)];
    [self addChild:closeButton];
    
    //ダイア1をコイン50と交換
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"info_default.plist"];
    CCSprite* coin01=[CCSprite spriteWithSpriteFrame:
                      [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"coin.png"]];
    coin01.position=ccp(40, winSize.height -380);
    coin01.scale=0.2;
    [self addChild:coin01];
    
    CCLabelTTF* label06=[CCLabelTTF labelWithString:
                         NSLocalizedString(@"Coin50Pack",NULL) fontName:@"Verdana-Bold" fontSize:18.0f];
    label06.position = ccp(coin01.position.x+100, coin01.position.y);
    [self addChild:label06];
    
    CCButton *barterCoinButton01 = [CCButton buttonWithTitle:@""
                                                 spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    barterCoinButton01.position = ccp(label06.position.x+130, coin01.position.y);
    barterCoinButton01.scale=0.6;
    [barterCoinButton01 setTarget:self selector:@selector(onBarterCoin01Clicked:)];
    [self addChild:barterCoinButton01];
    
    CCSprite* dia06=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"diamond.png"]];
    dia06.position=ccp(40,barterCoinButton01.contentSize.height/2);
    dia06.scale=0.2;
    [barterCoinButton01 addChild:dia06];
    
    CCLabelTTF* labelBtn06=[CCLabelTTF labelWithString:@" × 1" fontName:@"Verdana-Bold" fontSize:18];
    labelBtn06.position=ccp(barterCoinButton01.contentSize.width/2+10,barterCoinButton01.contentSize.height/2);
    [barterCoinButton01 addChild:labelBtn06];
    
    //ダイア2をコイン100と交換
    CCSprite* coin02=[CCSprite spriteWithSpriteFrame:
                      [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"coin.png"]];
    coin02.position=ccp(40, coin01.position.y -40);
    coin02.scale=0.2;
    [self addChild:coin02];
    
    CCLabelTTF* label07=[CCLabelTTF labelWithString:
                         NSLocalizedString(@"Coin100Pack",NULL) fontName:@"Verdana-Bold" fontSize:18.0f];
    label07.position = ccp(coin02.position.x+100, coin02.position.y);
    [self addChild:label07];
    
    CCButton *barterCoinButton02 = [CCButton buttonWithTitle:@""
                                                 spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    barterCoinButton02.position = ccp(label07.position.x+130, coin02.position.y);
    barterCoinButton02.scale=0.6;
    [barterCoinButton02 setTarget:self selector:@selector(onBarterCoin02Clicked:)];
    [self addChild:barterCoinButton02];
    
    CCSprite* dia07=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"diamond.png"]];
    dia07.position=ccp(40,barterCoinButton02.contentSize.height/2);
    dia07.scale=0.2;
    [barterCoinButton02 addChild:dia07];
    
    CCLabelTTF* labelBtn07=[CCLabelTTF labelWithString:@" × 2" fontName:@"Verdana-Bold" fontSize:18];
    labelBtn07.position=ccp(barterCoinButton02.contentSize.width/2+10,barterCoinButton02.contentSize.height/2);
    [barterCoinButton02 addChild:labelBtn07];
    
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

-(void)setAbility
{
    label01_Attack.string=[NSString stringWithFormat:@"%@:%04d",NSLocalizedString(@"Attack",NULL),
                           (int)roundf([ObjectManager load_Object_Ability_Attack:@"player01"]*100.0)];
    label01_Defense.string=[NSString stringWithFormat:@"%@:%04d",NSLocalizedString(@"Defense",NULL),
                            (int)roundf([ObjectManager load_Object_Ability_Defense:@"player01"]*100.0)];
    label01_Traveling.string=[NSString stringWithFormat:@"%@:%04d",NSLocalizedString(@"Move",NULL),
                              (int)roundf([ObjectManager load_Object_Ability_Traveling:@"player01"]*100.0)];
    label01_UnderWater.string=[NSString stringWithFormat:@"%@: ×",NSLocalizedString(@"Underwater",NULL)];
    
    label02_Attack.string=[NSString stringWithFormat:@"%@:%04d",NSLocalizedString(@"Attack",NULL),
                           (int)roundf([ObjectManager load_Object_Ability_Attack:@"player02"]*100.0)];
    label02_Defense.string=[NSString stringWithFormat:@"%@:%04d",NSLocalizedString(@"Defense",NULL),
                            (int)roundf([ObjectManager load_Object_Ability_Defense:@"player02"]*100.0)];
    label02_Traveling.string=[NSString stringWithFormat:@"%@:%04d",NSLocalizedString(@"Move",NULL),
                              (int)roundf([ObjectManager load_Object_Ability_Traveling:@"player02"]*100.0)];
    label02_UnderWater.string=[NSString stringWithFormat:@"%@:%04d",NSLocalizedString(@"Underwater",NULL),
                               (int)roundf([ObjectManager load_Object_Ability_Traveling:@"player02"]*100.0*0.2)];

    label03_Attack.string=[NSString stringWithFormat:@"%@:%04d",NSLocalizedString(@"Attack",NULL),
                           (int)roundf([ObjectManager load_Object_Ability_Attack:@"player03"]*100.0)];
    label03_Defense.string=[NSString stringWithFormat:@"%@:%04d",NSLocalizedString(@"Defense",NULL),
                            (int)roundf([ObjectManager load_Object_Ability_Defense:@"player03"]*100.0)];
    label03_Traveling.string=[NSString stringWithFormat:@"%@:%04d",NSLocalizedString(@"Move",NULL),
                              (int)roundf([ObjectManager load_Object_Ability_Traveling:@"player03"]*100.0)];
    label03_UnderWater.string=[NSString stringWithFormat:@"%@:%04d",NSLocalizedString(@"Underwater",NULL),
                               (int)roundf([ObjectManager load_Object_Ability_Traveling:@"player03"]*100.0*0.4)];
    
    label04_Attack.string=[NSString stringWithFormat:@"%@:%04d",NSLocalizedString(@"Attack",NULL),
                           (int)roundf([ObjectManager load_Object_Ability_Attack:@"player04"]*100.0)];
    label04_Defense.string=[NSString stringWithFormat:@"%@:%04d",NSLocalizedString(@"Defense",NULL),
                            (int)roundf([ObjectManager load_Object_Ability_Defense:@"player04"]*100.0)];
    label04_Traveling.string=[NSString stringWithFormat:@"%@:%04d",NSLocalizedString(@"Move",NULL),
                              (int)roundf([ObjectManager load_Object_Ability_Traveling:@"player04"]*100.0)];
    label04_UnderWater.string=[NSString stringWithFormat:@"%@:%04d",NSLocalizedString(@"Underwater",NULL),
                               (int)roundf([ObjectManager load_Object_Ability_Traveling:@"player04"]*100.0*2.0)];
    
    label05_Attack.string=[NSString stringWithFormat:@"%@:%04d",NSLocalizedString(@"Attack",NULL),
                           (int)roundf([ObjectManager load_Object_Ability_Attack:@"player05"]*100.0)];
    label05_Defense.string=[NSString stringWithFormat:@"%@:%04d",NSLocalizedString(@"Defense",NULL),
                            (int)roundf([ObjectManager load_Object_Ability_Defense:@"player05"]*100.0)];
    label05_Traveling.string=[NSString stringWithFormat:@"%@:%04d",NSLocalizedString(@"Move",NULL),
                              (int)roundf([ObjectManager load_Object_Ability_Traveling:@"player05"]*100.0)];
    label05_UnderWater.string=[NSString stringWithFormat:@"%@:%04d",NSLocalizedString(@"Underwater",NULL),
                               (int)roundf([ObjectManager load_Object_Ability_Traveling:@"player05"]*100.0*5.0)];
    
}

//=====================
//　アチーブメント保存
//=====================
-(void)setAchievement
{
    //基礎集計（レベル）セーブ
    int level=0;
    for(int i=1;i<=5;i++){//タンク種類数決め打ち
        NSString* objName=[NSString stringWithFormat:@"player%02d",i];
        if([ObjectManager load_Object_Ability_Level:objName]>level){
            [GameManager save_Aggregate_Level:[ObjectManager load_Object_Ability_Level:objName]-1];
            level=[ObjectManager load_Object_Ability_Level:objName];
        }
    }
    //アチーブメント（レベル）セーブ
    [AchievementManeger save_Achievement_All_Rate2:@"Achievement_Level"];
    
    //達成報酬付与
    NSMutableArray* achiveArray=[[NSMutableArray alloc]init];
    achiveArray=[AchievementManeger load_Achievement_All:@"Achievement_Level"];
    for(int i=0;i<achiveArray.count;i++){
        if([[[achiveArray objectAtIndex:i]objectAtIndex:2]floatValue]>=100){//100%以上だったら
            if(![[[achiveArray objectAtIndex:i]objectAtIndex:4]boolValue]){
                //フラグを立てる（報酬済み）
                [AchievementManeger save_Achievement_Reward:i reward:true forKey:@"Achievement_Level"];
                //ダイア付与
                [GameManager in_Out_Dia:
                 [AchievementManeger load_Achievement_Point:i forKey:@"Achievement_Level"] addFlg:true];
                //ダイア表示更新
                [InformationLayer update_CurrencyLabel];
                //メッセージボックス
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:
                            [NSString stringWithFormat:@"%@ %d %@",
                                        NSLocalizedString(@"Level",NULL),
                                       [AchievementManeger load_Achievement_Value:i forKey:@"Achievement_Level"]+1,
                                        NSLocalizedString(@"Achievement",NULL)]
                                      
                            message:[NSString stringWithFormat:@"%@ %d %@",
                                        NSLocalizedString(@"Diamond",NULL),
                                        [AchievementManeger load_Achievement_Point:i forKey:@"Achievement_Level"],
                                        NSLocalizedString(@"Get",NULL)]
                            delegate:nil
                            cancelButtonTitle:nil
                            otherButtonTitles:NSLocalizedString(@"OK",NULL), nil];
                [alert show];
            }
        }
    }
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    scrollView.scrollViewDeacceleration=0.3;
}

-(void)onSetBtn01_Clicked:(id)sender
{
    if([ObjectManager load_Object_Ability_Level:@"player01"]<[GameManager load_Aggregate_Stage]){
        [self showLevelUpMessageAlert:1];
    }else{
        [self showNotLevelUpAlert];
    }
}
-(void)onSetBtn02_Clicked:(id)sender
{
    if([ObjectManager load_Object_Ability_Level:@"player02"]<[GameManager load_Aggregate_Stage]){
        [self showLevelUpMessageAlert:2];
    }else{
        [self showNotLevelUpAlert];
    }
}
-(void)onSetBtn03_Clicked:(id)sender
{
    if([ObjectManager load_Object_Ability_Level:@"player03"]<[GameManager load_Aggregate_Stage]){
        [self showLevelUpMessageAlert:3];
    }else{
        [self showNotLevelUpAlert];
    }
}
-(void)onSetBtn04_Clicked:(id)sender
{
    if([ObjectManager load_Object_Ability_Level:@"player04"]<[GameManager load_Aggregate_Stage]){
        [self showLevelUpMessageAlert:4];
    }else{
        [self showNotLevelUpAlert];
    }
}
-(void)onSetBtn05_Clicked:(id)sender
{
    if([ObjectManager load_Object_Ability_Level:@"player05"]<[GameManager load_Aggregate_Stage]){
        [self showLevelUpMessageAlert:5];
    }else{
        [self showNotLevelUpAlert];
    }
}

-(void)showLevelUpMessageAlert:(int)type
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.tag=type;
    alert.delegate = self;
    alert.title = NSLocalizedString(@"LevelUp",NULL);
    alert.message= [NSString stringWithFormat:
                    @"\n%@ \n\n%@:%.2f%@ \n%@:%.2f%@ \n%@:%.2f%@ \n%@:%.2f%@ \n\n%@",
                    NSLocalizedString(@"levelUpItem",NULL),
                    
                    NSLocalizedString(@"Attack",NULL),
                    [self levelUp_Quantity:type key:0],
                    NSLocalizedString(@"Up",NULL),
                    
                    NSLocalizedString(@"Defense",NULL),
                    [self levelUp_Quantity:type key:1],
                    NSLocalizedString(@"Up",NULL),
                    
                    NSLocalizedString(@"Move",NULL),
                    [self levelUp_Quantity:type key:2],
                    NSLocalizedString(@"Up",NULL),

                    NSLocalizedString(@"Underwater",NULL),
                    [self levelUp_Quantity:type key:3],
                    NSLocalizedString(@"Up",NULL),
                    
                    NSLocalizedString(@"IsItOk",NULL)
                    ];
    
    [alert addButtonWithTitle:NSLocalizedString(@"No",NULL)];
    [alert addButtonWithTitle:NSLocalizedString(@"Yes",NULL)];
    [alert show];

}

-(void)showNotLevelUpAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Experience",NULL)
                                                    message:NSLocalizedString(@"Experience",NULL)
                                                    delegate:nil
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"OK",NULL), nil];
    [alert show];
}

-(float)levelUp_Quantity:(int)type key:(int)key //0:攻撃 1:防御 2:移動 3:水泳
{
    float quantity;
    if(type==1){
        if(key==0){
            quantity=0.05*100;
        }else if(key==1){
            quantity=0.5*100;
        }else if(key==2){
            quantity=0.03*100;
        }else if(key==3){
            quantity=0.0;
        }
    }else if(type==2){
        if(key==0){
            quantity=0.05*100;
        }else if(key==1){
            quantity=0.25*100;
        }else if(key==2){
            quantity=0.05*100;
        }else if(key==3){
            quantity=0.05*100*0.2;
        }
    }else if(type==3){
        if(key==0){
            quantity=0.1*100;
        }else if(key==1){
            quantity=0.5*100;
        }else if(key==2){
            quantity=0.01*100;
        }else if(key==3){
            quantity=0.01*100*0.4;
        }
    }else if(type==4){
        if(key==0){
            quantity=0.175*100;
        }else if(key==1){
            quantity=1.0*100;
        }else if(key==2){
            quantity=0.003*100;
        }else if(key==3){
            quantity=0.003*100*2.0;
        }
    }else if(type==5){
        if(key==0){
            quantity=0.25*100;
        }else if(key==1){
            quantity=1.5*100;
        }else if(key==2){
            quantity=0.001*100;
        }else if(key==3){
            quantity=0.001*100*5.0;
        }
    }
    return quantity;
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex){
    case 0:
        break;
    case 1:
        if(alertView.tag>=1 && alertView.tag<=5){
            afterDia = [GameManager load_Currency_Dia] - 1;
            if(afterDia >= 0){
                [ObjectManager levelUp_Object_Ability:[NSString stringWithFormat:@"player%02d",(int)alertView.tag]];
                [self setButtonLevel];
                [self setAbility];
                [GameManager in_Out_Dia:1 addFlg:false];//ダイア1減
                [InformationLayer update_CurrencyLabel];
                [self setAchievement];
            }else{
                [self showLackMassage];
            }
        }else if(alertView.tag==6){
            afterDia = [GameManager load_Currency_Dia] - 1;
            if(afterDia >= 0){
                [GameManager in_Out_Dia:1 addFlg:false];//ダイア1減
                [GameManager in_Out_Coin:50 addFlg:true];//コイン50増
                [InformationLayer update_CurrencyLabel];
            }else{
                [self showLackMassage];
            }
        }else if(alertView.tag==7){
            afterDia = [GameManager load_Currency_Dia] - 2;
            if(afterDia >= 0){
                [GameManager in_Out_Dia:2 addFlg:false];//ダイア2減
                [GameManager in_Out_Coin:100 addFlg:true];//コイン100増
                [InformationLayer update_CurrencyLabel];
            }else{
                [self showLackMassage];
            }
        }
        break;
    }
}

-(void)onBarterCoin01Clicked:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.tag=6;
    alert.delegate = self;
    alert.title = NSLocalizedString(@"Coin50Pack",NULL);
    alert.message=NSLocalizedString(@"BarterCoin50",NULL);
    [alert addButtonWithTitle:NSLocalizedString(@"No",NULL)];
    [alert addButtonWithTitle:NSLocalizedString(@"Yes",NULL)];
    [alert show];
}

-(void)onBarterCoin02Clicked:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.tag=7;
    alert.delegate = self;
    alert.title = NSLocalizedString(@"Coin100Pack",NULL);
    alert.message=NSLocalizedString(@"BarterCoin100",NULL);
    [alert addButtonWithTitle:NSLocalizedString(@"No",NULL)];
    [alert addButtonWithTitle:NSLocalizedString(@"Yes",NULL)];
    [alert show];
}

-(void)onCloseClicked:(id)sender
{
    [SoundManager button_Click];
    [GameManager setActive:true];
    [self removeFromParentAndCleanup:YES];
}

-(void)showLackMassage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DiamondShortage",NULL)
                                                    message:NSLocalizedString(@"BuyShop",NULL)
                                                    delegate:nil
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"OK",NULL), nil];
    [alert show];
}

@end
