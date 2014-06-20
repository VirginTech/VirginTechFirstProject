//
//  ShopView.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/12.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "ShopView.h"
#import "TitleScene.h"
#import "GameManager.h"
#import "InformationLayer.h"
#import "SoundManager.h"

@implementation ShopView

CGSize winSize;
SKProductsRequest *productsRequest;

PaymentManager* paymane;

SKProduct* product01;
SKProduct* product02;
SKProduct* product03;
SKProduct* product04;
SKProduct* product05;

+ (TitleScene *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize = [[CCDirector sharedDirector] viewSize];
    paymane = [[PaymentManager alloc]init];

    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    //インフォメーション z:1
    InformationLayer* infoLayer=[[InformationLayer alloc]init];
    [self addChild:infoLayer];
    
    // Create a back button
    //閉じるボタン
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button_default.plist"];
    CCButton *closeButton = [CCButton buttonWithTitle:@"" spriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"close.png"]];
    closeButton.positionType = CCPositionTypeNormalized;
    closeButton.position = ccp(0.9f, 0.95f); // Top Right of screen
    closeButton.scale=0.3;
    [closeButton setTarget:self selector:@selector(onCloseClicked:)];
    [self addChild:closeButton];
    
    
    return self;
}

//通知センターから呼ばれるメソッド
-(void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

-(void) updateInterfaceWithReachability: (Reachability*) curReach
{
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    if(netStatus == NotReachable)
    {
        //NSLog(@"ネットワーク接続がありません。");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",NULL)
                                                        message:NSLocalizedString(@"Notnetwork",NULL)
                                                        delegate:nil
                                                        cancelButtonTitle:nil
                                                        otherButtonTitles:NSLocalizedString(@"Ok",NULL), nil];
        [alert show];

        return;
        
    }else{
        //NSLog(@"ネットワーク OK !");
    }
}

- (void)onEnter
{
    [super onEnter];
    
    //ネット接続できるか確認
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    [self updateInterfaceWithReachability: internetReach];
    
    //インジケータの準備
    if([indicator isAnimating]==false)
    {
        indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [[[CCDirector sharedDirector] view] addSubview:indicator];
        if([GameManager getDevice]==3){
            indicator.center = ccp(winSize.width, winSize.height);
        }else{
            indicator.center = ccp(winSize.width/2, winSize.height/2);
        }
        [indicator startAnimating];
    }
    //アイテム情報の取得
    [self getItemInfo];
}

-(void)getItemInfo{
    
    NSSet *set = [NSSet setWithObjects:@"VirginTechFirstProject_Jewel10Pack",
                                        @"VirginTechFirstProject_Jewel20Pack",
                                        @"VirginTechFirstProject_Jewel30Pack",
                                        @"VirginTechFirstProject_Jewel50Pack",
                                        @"VirginTechFirstProject_Jewel100Pack",
                                        nil];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    // 無効なアイテムがないかチェック
    if ([response.invalidProductIdentifiers count] > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",NULL)
                                                        message:NSLocalizedString(@"ItemIdIsInvalid",NULL)
                                                        delegate:nil
                                                        cancelButtonTitle:NSLocalizedString(@"Ok",NULL)
                                                        otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    //アイテム情報の取得
    product01=[response.products objectAtIndex:1];// 10Pack
    product02=[response.products objectAtIndex:2];// 20Pack
    product03=[response.products objectAtIndex:3];// 30Pack
    product04=[response.products objectAtIndex:4];// 50Pack
    product05=[response.products objectAtIndex:0];// 100Pack

    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"info_default.plist"];
    
    //ダイアパック
    CCSprite* dia01=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"diamond.png"]];
    dia01.position=ccp(40, winSize.height -130);
    dia01.scale=0.2;
    [self addChild:dia01];

    CCSprite* dia02=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"diamond.png"]];
    dia02.position=ccp(dia01.position.x, dia01.position.y -40);
    dia02.scale=0.2;
    [self addChild:dia02];

    CCSprite* dia03=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"diamond.png"]];
    dia03.position=ccp(dia01.position.x, dia01.position.y -80);
    dia03.scale=0.2;
    [self addChild:dia03];

    CCSprite* dia04=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"diamond.png"]];
    dia04.position=ccp(dia01.position.x, dia01.position.y -120);
    dia04.scale=0.2;
    [self addChild:dia04];

    CCSprite* dia05=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"diamond.png"]];
    dia05.position=ccp(dia01.position.x, dia01.position.y -160);
    dia05.scale=0.2;
    [self addChild:dia05];

    //ラベル
    CCLabelTTF* label01=[CCLabelTTF labelWithString:product01.localizedTitle fontName:@"Verdana-Bold" fontSize:18.0f];
    label01.position = ccp(dia01.position.x+110, dia01.position.y);
    [self addChild:label01];
    
    CCLabelTTF* label02=[CCLabelTTF labelWithString:product02.localizedTitle fontName:@"Verdana-Bold" fontSize:18.0f];
    label02.position = ccp(dia02.position.x+110, dia02.position.y);
    [self addChild:label02];
    
    CCLabelTTF* label03=[CCLabelTTF labelWithString:product03.localizedTitle fontName:@"Verdana-Bold" fontSize:18.0f];
    label03.position = ccp(dia03.position.x+110, dia03.position.y);
    [self addChild:label03];

    CCLabelTTF* label04=[CCLabelTTF labelWithString:product04.localizedTitle fontName:@"Verdana-Bold" fontSize:18.0f];
    label04.position = ccp(dia04.position.x+110, dia04.position.y);
    [self addChild:label04];

    CCLabelTTF* label05=[CCLabelTTF labelWithString:product05.localizedTitle fontName:@"Verdana-Bold" fontSize:18.0f];
    label05.position = ccp(dia05.position.x+110, dia05.position.y);
    [self addChild:label05];
    
    //購入ボタン
    CCButton* button01=[CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    button01.position = ccp(label01.position.x+130, dia01.position.y);
    [button01 setTarget:self selector:@selector(button01_Clicked:)];
    button01.scale=0.6;
    [self addChild:button01];
    CCLabelTTF* labelBtn01=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%@",[product01.priceLocale objectForKey:NSLocaleCurrencySymbol],product01.price] fontName:@"Verdana-Italic" fontSize:18.0f];
    labelBtn01.position=ccp(button01.contentSize.width/2,button01.contentSize.height/2);
    labelBtn01.color=[CCColor whiteColor];
    [button01 addChild:labelBtn01];

    CCButton* button02=[CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    button02.position = ccp(label02.position.x+130, dia02.position.y);
    [button02 setTarget:self selector:@selector(button02_Clicked:)];
    button02.scale=0.6;
    [self addChild:button02];
    CCLabelTTF* labelBtn02=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%@",[product02.priceLocale objectForKey:NSLocaleCurrencySymbol],product02.price] fontName:@"Verdana-Italic" fontSize:18.0f];
    labelBtn02.position=ccp(button02.contentSize.width/2,button02.contentSize.height/2);
    labelBtn02.color=[CCColor whiteColor];
    [button02 addChild:labelBtn02];

    CCButton* button03=[CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    button03.position = ccp(label03.position.x+130, dia03.position.y);
    [button03 setTarget:self selector:@selector(button03_Clicked:)];
    button03.scale=0.6;
    [self addChild:button03];
    CCLabelTTF* labelBtn03=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%@",[product03.priceLocale objectForKey:NSLocaleCurrencySymbol],product03.price] fontName:@"Verdana-Italic" fontSize:18.0f];
    labelBtn03.position=ccp(button03.contentSize.width/2,button03.contentSize.height/2);
    labelBtn03.color=[CCColor whiteColor];
    [button03 addChild:labelBtn03];

    CCButton* button04=[CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    button04.position = ccp(label04.position.x+130, dia04.position.y);
    [button04 setTarget:self selector:@selector(button04_Clicked:)];
    button04.scale=0.6;
    [self addChild:button04];
    CCLabelTTF* labelBtn04=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%@",[product04.priceLocale objectForKey:NSLocaleCurrencySymbol],product04.price] fontName:@"Verdana-Italic" fontSize:18.0f];
    labelBtn04.position=ccp(button04.contentSize.width/2,button04.contentSize.height/2);
    labelBtn04.color=[CCColor whiteColor];
    [button04 addChild:labelBtn04];

    CCButton* button05=[CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    button05.position = ccp(label05.position.x+130, dia05.position.y);
    [button05 setTarget:self selector:@selector(button05_Clicked:)];
    button05.scale=0.6;
    [self addChild:button05];
    CCLabelTTF* labelBtn05=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%@",[product05.priceLocale objectForKey:NSLocaleCurrencySymbol],product05.price] fontName:@"Verdana-Italic" fontSize:18.0f];
    labelBtn05.position=ccp(button05.contentSize.width/2,button05.contentSize.height/2);
    labelBtn05.color=[CCColor whiteColor];
    [button05 addChild:labelBtn05];
    
    //ダイア1をコイン50と交換
    CCSprite* coin01=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"coin.png"]];
    coin01.position=ccp(40, dia01.position.y -230);
    coin01.scale=0.2;
    [self addChild:coin01];
    
    CCLabelTTF* label06=[CCLabelTTF labelWithString:NSLocalizedString(@"Coin50Pack",NULL)
                                                            fontName:@"Verdana-Bold" fontSize:18.0f];
    label06.position = ccp(coin01.position.x+110, coin01.position.y);
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
    coin02.position=ccp(40, dia01.position.y -270);
    coin02.scale=0.2;
    [self addChild:coin02];
    
    CCLabelTTF* label07=[CCLabelTTF labelWithString:NSLocalizedString(@"Coin100Pack",NULL)
                                                            fontName:@"Verdana-Bold" fontSize:18.0f];
    label07.position = ccp(coin02.position.x+110, coin02.position.y);
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
    
    // インジケータを非表示にする
    if([indicator isAnimating])
    {
        [indicator stopAnimating];
        [indicator removeFromSuperview];
    }

}

- (void)onCloseClicked:(id)sender
{
    [SoundManager button_Click];
    //プロダクトリクエストをキャンセル
    [productsRequest cancel];
    // インジケータを非表示にする
    if([indicator isAnimating]){
        [indicator stopAnimating];
        [indicator removeFromSuperview];
    }
    
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

- (void)button01_Clicked:(id)sender
{
    [paymane buyProduct:product01];
}
- (void)button02_Clicked:(id)sender
{
    [paymane buyProduct:product02];
}
- (void)button03_Clicked:(id)sender
{
    [paymane buyProduct:product03];
}
- (void)button04_Clicked:(id)sender
{
    [paymane buyProduct:product04];
}
- (void)button05_Clicked:(id)sender
{
    [paymane buyProduct:product05];
}

-(void)onBarterCoin01Clicked:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.tag=1;
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
    alert.tag=2;
    alert.delegate = self;
    alert.title = NSLocalizedString(@"Coin100Pack",NULL);
    alert.message=NSLocalizedString(@"BarterCoin100",NULL);
    [alert addButtonWithTitle:NSLocalizedString(@"No",NULL)];
    [alert addButtonWithTitle:NSLocalizedString(@"Yes",NULL)];
    [alert show];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    int afterDia;
    switch (buttonIndex){
    case 0:
        break;
    case 1:
        if(alertView.tag==1){
            afterDia = [GameManager load_Currency_Dia] - 1;
            if(afterDia >= 0){
                [GameManager in_Out_Dia:1 addFlg:false];//ダイア1減
                [GameManager in_Out_Coin:50 addFlg:true];//コイン50増
                [InformationLayer update_CurrencyLabel];
            }else{
                [self showLackMassage];
            }
        }else if(alertView.tag==2){
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

-(void)showLackMassage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DiamondShortage",NULL)
                                                    message:NSLocalizedString(@"BuyShop",NULL)
                                                    delegate:nil
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"OK",NULL), nil];
    [alert show];
}

@end
