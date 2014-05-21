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

    //コインバー
    CCSprite* coinBar=[CCSprite spriteWithImageNamed:@"coinBar.png"];
    coinBar.position=ccp(coinBar.contentSize.width/2+20, winSize.height-coinBar.contentSize.height-5);
    [self addChild:coinBar];
    
    coinLabel = [CCLabelTTF labelWithString:@"" fontName:@"Verdana-Bold" fontSize:12.0];
    coinLabel.color = [CCColor whiteColor];
    coinLabel.position = ccp(coinBar.contentSize.width/2+15, coinBar.contentSize.height/2);
    [coinBar addChild:coinLabel];

    //ダイアバー
    CCSprite* diaBar=[CCSprite spriteWithImageNamed:@"diaBar.png"];
    diaBar.position=ccp(coinBar.position.x, coinBar.position.y-diaBar.contentSize.height);
    [self addChild:diaBar];
    
    diaLabel = [CCLabelTTF labelWithString:@"" fontName:@"Verdana-Bold" fontSize:12.0];
    diaLabel.color = [CCColor whiteColor];
    diaLabel.position = ccp(diaBar.contentSize.width/2+15, diaBar.contentSize.height/2);
    [diaBar addChild:diaLabel];
    
    [InformationLayer updateCurrencyLabel];
    
    return self;
}

+(void)updateCurrencyLabel
{
    coinLabel.string=[NSString stringWithFormat:@"%05d",[GameManager load_Currency_Coin]];
    diaLabel.string=[NSString stringWithFormat:@"%04d",[GameManager load_Currency_Dia]];
}

@end
