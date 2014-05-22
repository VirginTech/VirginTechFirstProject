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

    //ハイスコア
    scoreLabel=[CCLabelTTF labelWithString:@"Score:00000" fontName:@"Verdana-Bold" fontSize:12];
    scoreLabel.color=[CCColor whiteColor];
    scoreLabel.position=ccp(scoreLabel.contentSize.width/2+10, winSize.height-10);
    [self addChild:scoreLabel];

    //コインバー
    CCSprite* coinBar=[CCSprite spriteWithImageNamed:@"coinBar.png"];
    coinBar.position=ccp(coinBar.contentSize.width/2+10, winSize.height-30);
    [self addChild:coinBar];
    
    coinLabel = [CCLabelTTF labelWithString:@"" fontName:@"Verdana-Bold" fontSize:12.0];
    coinLabel.color = [CCColor whiteColor];
    coinLabel.position = ccp(coinBar.contentSize.width/2+15, coinBar.contentSize.height/2);
    [coinBar addChild:coinLabel];

    //ダイアバー
    CCSprite* diaBar=[CCSprite spriteWithImageNamed:@"diaBar.png"];
    diaBar.position=ccp(diaBar.contentSize.width/2+10, winSize.height-50);
    [self addChild:diaBar];
    
    diaLabel = [CCLabelTTF labelWithString:@"" fontName:@"Verdana-Bold" fontSize:12.0];
    diaLabel.color = [CCColor whiteColor];
    diaLabel.position = ccp(diaBar.contentSize.width/2+15, diaBar.contentSize.height/2);
    [diaBar addChild:diaLabel];
    
    [InformationLayer update_CurrencyLabel];
    [InformationLayer update_HighScoreLabel];
    
    return self;
}
+(void)update_HighScoreLabel
{
    scoreLabel.string=[NSString stringWithFormat:@"Score:%05ld",[GameManager load_HighScore]];
}

+(void)update_CurrencyLabel
{
    coinLabel.string=[NSString stringWithFormat:@"%05d",[GameManager load_Currency_Coin]];
    diaLabel.string=[NSString stringWithFormat:@"%04d",[GameManager load_Currency_Dia]];
}

@end
