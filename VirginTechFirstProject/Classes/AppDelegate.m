//
//  AppDelegate.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/25.
//  Copyright VirginTech LLC. 2014年. All rights reserved.
//
// -----------------------------------------------------------------------

#import "AppDelegate.h"
//#import "IntroScene.h"
//#import "HelloWorldScene.h"
#import "TitleScene.h"
#import "GameManager.h"
#import "SoundManager.h"
#import "InitializeManager.h"
#import "NADInterstitial.h"
#import "ImobileSdkAds/ImobileSdkAds.h"

@implementation AppDelegate

// 
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// This is the only app delegate method you need to implement when inheriting from CCAppDelegate.
	// This method is a good place to add one time setup code that only runs when your app is first launched.
	
	// Setup Cocos2D with reasonable defaults for everything.
	// There are a number of simple options you can change.
	// If you want more flexibility, you can configure Cocos2D yourself instead of calling setupCocos2dWithOptions:.
	[self setupCocos2dWithOptions:@{
		// Show the FPS and draw call label.
		//CCSetupShowDebugStats: @(YES),
		
		// More examples of options you might want to fiddle with:
		// (See CCAppDelegate.h for more information)
		
		// Use a 16 bit color buffer: 
//		CCSetupPixelFormat: kEAGLColorFormatRGB565,
		// Use a simplified coordinate system that is shared across devices.
//		CCSetupScreenMode: CCScreenModeFixed,
		// Run in portrait mode.
		CCSetupScreenOrientation: CCScreenOrientationPortrait,
		// Run at a reduced framerate.
//		CCSetupAnimationInterval: @(1.0/30.0),
		// Run the fixed timestep extra fast.
//		CCSetupFixedUpdateInterval: @(1.0/180.0),
		// Make iPad's act like they run at a 2x content scale. (iPad retina 4x)
		CCSetupTabletScale2X: @(YES),
	}];
	
    //GameCenterへ認証
    if ([GameManager getOsVersion]>=6.0f)
    {
        LeaderboardView *lbView = (LeaderboardView *)[UIApplication sharedApplication].keyWindow.rootViewController;
        GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
        localPlayer.authenticateHandler = ^(UIViewController* viewController, NSError* error)
        {
            if(viewController!=nil){
                [lbView presentViewController:viewController animated:YES completion:nil];
            }
        };
    }else
    {
        [[GKLocalPlayer localPlayer]authenticateWithCompletionHandler:^(NSError *error){}];
    }
    
    //AppBankNetworkインタースティシャル読込み (iMobileインタースティシャルと相性悪し)
    //[[NADInterstitial sharedInstance] loadAdWithApiKey:@"bceaad0e1d190fd15b74240b7be000075f580213" spotId:@"216691"];//本番
    //[[NADInterstitial sharedInstance] loadAdWithApiKey:@"308c2499c75c4a192f03c02b2fcebd16dcb45cc9" spotId:@"213208"];//テスト
    
    //iMobileインタースティシャル読込み (AppBankNetworkインタースティシャルと相性悪し)
    [ImobileSdkAds registerWithPublisherID:@"31967" MediaID:@"115572" SpotID:@"276556"];
    [ImobileSdkAds startBySpotID:@"276556"];
    
	return YES;
}

-(CCScene *)startScene //起動が終わったら自動的に移行するシーン
{
	// This method should return the very first scene to be run when your app starts.
	//return [IntroScene scene];

    //サウンド・プリロード
    [SoundManager soundPreload];

    //デバイス登録
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if(screenBounds.size.height==568 || screenBounds.size.width==568){ //iPhone5,6 (568,320px)
        [GameManager setDevice:1];
    }else if(screenBounds.size.height==480 || screenBounds.size.width==480){ //iPhone4 (480,320px)
        [GameManager setDevice:2];
    }else if(screenBounds.size.height==1024 || screenBounds.size.width==1024){ //iPad2 (1024,768px)
        [GameManager setDevice:3];
    }else{
        [GameManager setDevice:0];
    }
    
    //ロケール登録
    NSString* locale = NSLocalizedString(@"Locale",NULL);
    if([locale isEqualToString:@"Locale"]){
        [GameManager setLocale:1];//英語
    }else{
        [GameManager setLocale:2];//日本語
    }
    
    //OSバージョン登録
    [GameManager setOsVersion:[[[UIDevice currentDevice]systemVersion]floatValue]];
    
    //初回データ初期値設定
    [InitializeManager initialize_All];
    
    return [TitleScene scene];
}

@end
