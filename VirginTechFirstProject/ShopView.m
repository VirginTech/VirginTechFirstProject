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

@implementation ShopView

CGSize winSize;
SKProductsRequest *productsRequest;

PaymentManager* paymane;

SKProduct* product01;
SKProduct* product02;
SKProduct* product03;

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
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                        message:@"ネットワーク接続がありません。"
                                                        delegate:nil
                                                        cancelButtonTitle:nil
                                                        otherButtonTitles:@"OK", nil];
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
                                        nil];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{

    if ([response.invalidProductIdentifiers count] > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                        message:@"アイテムが無効です。"
                                                        delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    //アイテム情報の取得
    product01=[response.products objectAtIndex:0];// 10Pack
    product02=[response.products objectAtIndex:1];// 20Pack
    product03=[response.products objectAtIndex:2];// 30Pack

    CCButton *button01 = [CCButton buttonWithTitle:product01.localizedTitle fontName:@"Verdana-Bold" fontSize:18.0f];
    button01.position = ccp(winSize.width/2, winSize.height/2 + 30);
    [button01 setTarget:self selector:@selector(button01_Clicked:)];
    [self addChild:button01];

    CCButton *button02 = [CCButton buttonWithTitle:product02.localizedTitle fontName:@"Verdana-Bold" fontSize:18.0f];
    button02.position = ccp(winSize.width/2, winSize.height/2);
    [button02 setTarget:self selector:@selector(button02_Clicked:)];
    [self addChild:button02];

    CCButton *button03 = [CCButton buttonWithTitle:product03.localizedTitle fontName:@"Verdana-Bold" fontSize:18.0f];
    button03.position = ccp(winSize.width/2, winSize.height/2 - 30);
    [button03 setTarget:self selector:@selector(button03_Clicked:)];
    [self addChild:button03];

    // インジケータを非表示にする
    if([indicator isAnimating])
    {
        [indicator stopAnimating];
        [indicator removeFromSuperview];
    }

}

- (void)onBackClicked:(id)sender
{
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
@end
