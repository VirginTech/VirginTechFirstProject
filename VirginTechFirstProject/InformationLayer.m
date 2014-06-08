//
//  Information.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/30.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "InformationLayer.h"
#import "GameManager.h"

@implementation InformationLayer

//@synthesize coin;
//@synthesize diamond;

CGSize winSize;
CCLabelTTF *coinLabel;
CCLabelTTF *diaLabel;
CCLabelTTF* scoreLabel;
CCLabelTTF* achieveLabel;

+ (InformationLayer *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //各種通貨の取得
    //coin=[GameManager load_Currency_Coin];
    //diamond=[GameManager load_Currency_Dia];

    //画像読込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"info_default.plist"];
    
    //月桂樹
    CCSprite* laurel= [CCSprite spriteWithSpriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"laurel.png"]];
    laurel.position=ccp(15, winSize.height-10);
    laurel.scale=0.3;
    [self addChild:laurel];
    
    //アチーブメント
    achieveLabel=[CCLabelTTF labelWithString:@"00" fontName:@"Verdana-Bold" fontSize:13];
    achieveLabel.color=[CCColor whiteColor];
    achieveLabel.position=ccp(laurel.contentSize.width/2,laurel.contentSize.height/2);
    achieveLabel.scale=2.7;
    [laurel addChild:achieveLabel];
    
    //ハイスコア
    scoreLabel=[CCLabelTTF labelWithString:@"00000" fontName:@"Chalkduster" fontSize:13];
    scoreLabel.color=[CCColor whiteColor];
    scoreLabel.position=ccp(laurel.position.x+scoreLabel.contentSize.width/2+15, laurel.position.y);
    [self addChild:scoreLabel];

    //コインバー
    CCSprite* coinBar= [CCSprite spriteWithSpriteFrame:
                                [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"coin.png"]];
    coinBar.position=ccp(15, winSize.height-35);
    coinBar.scale=0.2;
    [self addChild:coinBar];
    
    coinLabel = [CCLabelTTF labelWithString:@"0000" fontName:@"Chalkduster" fontSize:13.0];
    coinLabel.color = [CCColor whiteColor];
    coinLabel.position = ccp(coinBar.position.x+coinLabel.contentSize.width/2+15, coinBar.position.y);
    [self addChild:coinLabel];

    //ダイアバー
    CCSprite* diaBar= [CCSprite spriteWithSpriteFrame:
                                [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"diamond.png"]];
    diaBar.position=ccp(15, winSize.height-60);
    diaBar.scale=0.2;
    [self addChild:diaBar];
    
    diaLabel = [CCLabelTTF labelWithString:@"000" fontName:@"Chalkduster" fontSize:13.0];
    diaLabel.color = [CCColor whiteColor];
    diaLabel.position = ccp(diaBar.position.x+diaLabel.contentSize.width/2+15, diaBar.position.y);
    [self addChild:diaLabel];
    
    [InformationLayer update_CurrencyLabel];
    [InformationLayer update_HighScoreLabel];
    
    return self;
}
+(void)update_HighScoreLabel
{
    scoreLabel.string=[NSString stringWithFormat:@"%05ld",[GameManager load_HighScore]];
}

+(void)update_CurrencyLabel
{
    coinLabel.string=[NSString stringWithFormat:@"%04d",[GameManager load_Currency_Coin]];
    diaLabel.string=[NSString stringWithFormat:@"%03d",[GameManager load_Currency_Dia]];
}

@end
