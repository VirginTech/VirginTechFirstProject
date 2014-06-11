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

@implementation ItemSetupLayer

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

CCLabelTTF* label02_Attack;
CCLabelTTF* label02_Defense;
CCLabelTTF* label02_Traveling;

CCLabelTTF* label03_Attack;
CCLabelTTF* label03_Defense;
CCLabelTTF* label03_Traveling;

CCLabelTTF* label04_Attack;
CCLabelTTF* label04_Defense;
CCLabelTTF* label04_Traveling;

CCLabelTTF* label05_Attack;
CCLabelTTF* label05_Defense;
CCLabelTTF* label05_Traveling;

+ (ItemSetupLayer *)scene
{
    return [[self alloc] init];
}

- (id)init
{    
    self = [super init];
    if (!self) return(nil);
    
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
    CCButton* setBtn01=[CCButton buttonWithTitle:@"LevelUp!" fontName:@"Verdana-Bold" fontSize:15.0f];
    setBtn01.position=ccp(animal01.contentSize.width/2, -80);
    [setBtn01 setTarget:self selector:@selector(onSetBtn01_Clicked:)];
    setBtn01.color=[CCColor blueColor];
    [animal01 addChild:setBtn01];
    
    CCButton* setBtn02=[CCButton buttonWithTitle:@"LevelUp!" fontName:@"Verdana-Bold" fontSize:15.0f];
    setBtn02.position=ccp(animal02.contentSize.width/2, -80);
    [setBtn02 setTarget:self selector:@selector(onSetBtn02_Clicked:)];
    setBtn02.color=[CCColor blueColor];
    [animal02 addChild:setBtn02];
    
    CCButton* setBtn03=[CCButton buttonWithTitle:@"LevelUp!" fontName:@"Verdana-Bold" fontSize:15.0f];
    setBtn03.position=ccp(animal03.contentSize.width/2, -80);
    [setBtn03 setTarget:self selector:@selector(onSetBtn03_Clicked:)];
    setBtn03.color=[CCColor blueColor];
    [animal03 addChild:setBtn03];
    
    CCButton* setBtn04=[CCButton buttonWithTitle:@"LevelUp!" fontName:@"Verdana-Bold" fontSize:15.0f];
    setBtn04.position=ccp(animal04.contentSize.width/2, -80);
    [setBtn04 setTarget:self selector:@selector(onSetBtn04_Clicked:)];
    setBtn04.color=[CCColor blueColor];
    [animal04 addChild:setBtn04];
    
    CCButton* setBtn05=[CCButton buttonWithTitle:@"LevelUp!" fontName:@"Verdana-Bold" fontSize:15.0f];
    setBtn05.position=ccp(animal05.contentSize.width/2, -80);
    [setBtn05 setTarget:self selector:@selector(onSetBtn05_Clicked:)];
    setBtn05.color=[CCColor blueColor];
    [animal05 addChild:setBtn05];

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
    label01_Attack=[CCLabelTTF labelWithString:@"攻撃:0000" fontName:@"Verdana-Bold" fontSize:10.0f];
    label01_Attack.color=[CCColor blackColor];
    label01_Attack.position=CGPointMake(animal01.contentSize.width/2, -10);
    [animal01 addChild:label01_Attack];
    
    label01_Defense=[CCLabelTTF labelWithString:@"防御:0000" fontName:@"Verdana-Bold" fontSize:10.0f];
    label01_Defense.color=[CCColor blackColor];
    label01_Defense.position=CGPointMake(animal01.contentSize.width/2, -25);
    [animal01 addChild:label01_Defense];
    
    label01_Traveling=[CCLabelTTF labelWithString:@"移動:0000" fontName:@"Verdana-Bold" fontSize:10.0f];
    label01_Traveling.color=[CCColor blackColor];
    label01_Traveling.position=CGPointMake(animal01.contentSize.width/2, -40);
    [animal01 addChild:label01_Traveling];
    
    label02_Attack=[CCLabelTTF labelWithString:@"攻撃:0000" fontName:@"Verdana-Bold" fontSize:10.0f];
    label02_Attack.color=[CCColor blackColor];
    label02_Attack.position=CGPointMake(animal01.contentSize.width/2, -10);
    [animal02 addChild:label02_Attack];
    
    label02_Defense=[CCLabelTTF labelWithString:@"防御:0000" fontName:@"Verdana-Bold" fontSize:10.0f];
    label02_Defense.color=[CCColor blackColor];
    label02_Defense.position=CGPointMake(animal01.contentSize.width/2, -25);
    [animal02 addChild:label02_Defense];
    
    label02_Traveling=[CCLabelTTF labelWithString:@"移動:0000" fontName:@"Verdana-Bold" fontSize:10.0f];
    label02_Traveling.color=[CCColor blackColor];
    label02_Traveling.position=CGPointMake(animal01.contentSize.width/2, -40);
    [animal02 addChild:label02_Traveling];

    label03_Attack=[CCLabelTTF labelWithString:@"攻撃:0000" fontName:@"Verdana-Bold" fontSize:10.0f];
    label03_Attack.color=[CCColor blackColor];
    label03_Attack.position=CGPointMake(animal01.contentSize.width/2, -10);
    [animal03 addChild:label03_Attack];
    
    label03_Defense=[CCLabelTTF labelWithString:@"防御:0000" fontName:@"Verdana-Bold" fontSize:10.0f];
    label03_Defense.color=[CCColor blackColor];
    label03_Defense.position=CGPointMake(animal01.contentSize.width/2, -25);
    [animal03 addChild:label03_Defense];
    
    label03_Traveling=[CCLabelTTF labelWithString:@"移動:0000" fontName:@"Verdana-Bold" fontSize:10.0f];
    label03_Traveling.color=[CCColor blackColor];
    label03_Traveling.position=CGPointMake(animal01.contentSize.width/2, -40);
    [animal03 addChild:label03_Traveling];

    label04_Attack=[CCLabelTTF labelWithString:@"攻撃:0000" fontName:@"Verdana-Bold" fontSize:10.0f];
    label04_Attack.color=[CCColor blackColor];
    label04_Attack.position=CGPointMake(animal01.contentSize.width/2, -10);
    [animal04 addChild:label04_Attack];
    
    label04_Defense=[CCLabelTTF labelWithString:@"防御:0000" fontName:@"Verdana-Bold" fontSize:10.0f];
    label04_Defense.color=[CCColor blackColor];
    label04_Defense.position=CGPointMake(animal01.contentSize.width/2, -25);
    [animal04 addChild:label04_Defense];
    
    label04_Traveling=[CCLabelTTF labelWithString:@"移動:0000" fontName:@"Verdana-Bold" fontSize:10.0f];
    label04_Traveling.color=[CCColor blackColor];
    label04_Traveling.position=CGPointMake(animal01.contentSize.width/2, -40);
    [animal04 addChild:label04_Traveling];

    label05_Attack=[CCLabelTTF labelWithString:@"攻撃:0000" fontName:@"Verdana-Bold" fontSize:10.0f];
    label05_Attack.color=[CCColor blackColor];
    label05_Attack.position=CGPointMake(animal01.contentSize.width/2, -10);
    [animal05 addChild:label05_Attack];
    
    label05_Defense=[CCLabelTTF labelWithString:@"防御:0000" fontName:@"Verdana-Bold" fontSize:10.0f];
    label05_Defense.color=[CCColor blackColor];
    label05_Defense.position=CGPointMake(animal01.contentSize.width/2, -25);
    [animal05 addChild:label05_Defense];
    
    label05_Traveling=[CCLabelTTF labelWithString:@"移動:0000" fontName:@"Verdana-Bold" fontSize:10.0f];
    label05_Traveling.color=[CCColor blackColor];
    label05_Traveling.position=CGPointMake(animal01.contentSize.width/2, -40);
    [animal05 addChild:label05_Traveling];
    
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
    CCButton *barterCoinButton = [CCButton buttonWithTitle:@"[ダイア1をコイン50と交換]" fontName:@"Verdana-Bold" fontSize:18.0f];
    barterCoinButton.positionType = CCPositionTypeNormalized;
    barterCoinButton.position = ccp(0.5f, 0.2f); // Top Right of screen
    [barterCoinButton setTarget:self selector:@selector(onBarterCoinClicked:)];
    [self addChild:barterCoinButton];
    
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
    label01_Attack.string=[NSString stringWithFormat:
                           @"攻撃:%04d",(int)roundf([ObjectManager load_Object_Ability_Attack:@"player01"]*100.0)];
    label01_Defense.string=[NSString stringWithFormat:
                           @"防御:%04d",(int)roundf([ObjectManager load_Object_Ability_Defense:@"player01"]*100.0)];
    label01_Traveling.string=[NSString stringWithFormat:
                           @"移動:%04d",(int)roundf([ObjectManager load_Object_Ability_Traveling:@"player01"]*100.0)];
    
    label02_Attack.string=[NSString stringWithFormat:
                           @"攻撃:%04d",(int)roundf([ObjectManager load_Object_Ability_Attack:@"player02"]*100.0)];
    label02_Defense.string=[NSString stringWithFormat:
                            @"防御:%04d",(int)roundf([ObjectManager load_Object_Ability_Defense:@"player02"]*100.0)];
    label02_Traveling.string=[NSString stringWithFormat:
                              @"移動:%04d",(int)roundf([ObjectManager load_Object_Ability_Traveling:@"player02"]*100.0)];
    
    label03_Attack.string=[NSString stringWithFormat:
                           @"攻撃:%04d",(int)roundf([ObjectManager load_Object_Ability_Attack:@"player03"]*100.0)];
    label03_Defense.string=[NSString stringWithFormat:
                            @"防御:%04d",(int)roundf([ObjectManager load_Object_Ability_Defense:@"player03"]*100.0)];
    label03_Traveling.string=[NSString stringWithFormat:
                              @"移動:%04d",(int)roundf([ObjectManager load_Object_Ability_Traveling:@"player03"]*100.0)];
    
    label04_Attack.string=[NSString stringWithFormat:
                           @"攻撃:%04d",(int)roundf([ObjectManager load_Object_Ability_Attack:@"player04"]*100.0)];
    label04_Defense.string=[NSString stringWithFormat:
                            @"防御:%04d",(int)roundf([ObjectManager load_Object_Ability_Defense:@"player04"]*100.0)];
    label04_Traveling.string=[NSString stringWithFormat:
                              @"移動:%04d",(int)roundf([ObjectManager load_Object_Ability_Traveling:@"player04"]*100.0)];
    
    label05_Attack.string=[NSString stringWithFormat:
                           @"攻撃:%04d",(int)roundf([ObjectManager load_Object_Ability_Attack:@"player05"]*100.0)];
    label05_Defense.string=[NSString stringWithFormat:
                            @"防御:%04d",(int)roundf([ObjectManager load_Object_Ability_Defense:@"player05"]*100.0)];
    label05_Traveling.string=[NSString stringWithFormat:
                              @"移動:%04d",(int)roundf([ObjectManager load_Object_Ability_Traveling:@"player05"]*100.0)];
    
    
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
                            [NSString stringWithFormat:@"レベル %d 達成！",
                                       [AchievementManeger load_Achievement_Value:i forKey:@"Achievement_Level"]+1]
                            message:[NSString stringWithFormat:@"ダイヤモンドを %d 入手しました！",
                                        [AchievementManeger load_Achievement_Point:i forKey:@"Achievement_Level"]]
                            delegate:nil
                            cancelButtonTitle:nil
                            otherButtonTitles:@"O K", nil];
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
    afterDia = [GameManager load_Currency_Dia] - 1;
    if(afterDia >= 0){
        [ObjectManager levelUp_Object_Ability:@"player01"];
        [self setButtonLevel];
        [self setAbility];
        [GameManager in_Out_Dia:1 addFlg:false];//ダイア1減
        [InformationLayer update_CurrencyLabel];
        [self setAchievement];
    }else{
        [self showMassage];
    }
}
-(void)onSetBtn02_Clicked:(id)sender
{
    afterDia = [GameManager load_Currency_Dia] - 1;
    if(afterDia >= 0){
        [ObjectManager levelUp_Object_Ability:@"player02"];
        [self setButtonLevel];
        [self setAbility];
        [GameManager in_Out_Dia:1 addFlg:false];//ダイア1減
        [InformationLayer update_CurrencyLabel];
        [self setAchievement];
    }else{
        [self showMassage];
    }
}
-(void)onSetBtn03_Clicked:(id)sender
{
    afterDia = [GameManager load_Currency_Dia] - 1;
    if(afterDia >= 0){
        [ObjectManager levelUp_Object_Ability:@"player03"];
        [self setButtonLevel];
        [self setAbility];
        [GameManager in_Out_Dia:1 addFlg:false];//ダイア1減
        [InformationLayer update_CurrencyLabel];
        [self setAchievement];
    }else{
        [self showMassage];
    }
}
-(void)onSetBtn04_Clicked:(id)sender
{
    afterDia = [GameManager load_Currency_Dia] - 1;
    if(afterDia >= 0){
        [ObjectManager levelUp_Object_Ability:@"player04"];
        [self setButtonLevel];
        [self setAbility];
        [GameManager in_Out_Dia:1 addFlg:false];//ダイア1減
        [InformationLayer update_CurrencyLabel];
        [self setAchievement];
    }else{
        [self showMassage];
    }
}
-(void)onSetBtn05_Clicked:(id)sender
{
    afterDia = [GameManager load_Currency_Dia] - 1;
    if(afterDia >= 0){
        [ObjectManager levelUp_Object_Ability:@"player05"];
        [self setButtonLevel];
        [self setAbility];
        [GameManager in_Out_Dia:1 addFlg:false];//ダイア1減
        [InformationLayer update_CurrencyLabel];
        [self setAchievement];
    }else{
        [self showMassage];
    }
}

-(void)onBarterCoinClicked:(id)sender
{
    afterDia = [GameManager load_Currency_Dia] - 1;
    if(afterDia >= 0){
        [GameManager in_Out_Dia:1 addFlg:false];//ダイア1減
        [GameManager in_Out_Coin:50 addFlg:true];//コイン50増
        [InformationLayer update_CurrencyLabel];
    }else{
        [self showMassage];
    }
}

-(void)onCloseClicked:(id)sender
{
    [GameManager setActive:true];
    [self removeFromParentAndCleanup:YES];
}

-(void)showMassage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ダイアが足りません"
                                                    message:@"ダイアはショップで購入できます。"
                                                    delegate:nil
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:@"O K", nil];
    [alert show];
}

@end
