//
//  GameManager.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/01.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameManager : NSObject{
}

+(void)setDevice:(int)type;// 1:iPhone5 2:iPhone4 3:iPad2
+(int)getDevice;
+(void)setStageLevel:(int)level;
+(int)getStageLevel;
+(void)setPlaying:(bool)flg;
+(bool)getPlaying;
+(void)setPauseing:(bool)flg;
+(bool)getPauseing;
+(void)setPauseStateChange:(bool)flg;
+(bool)getPauseStateChange;

+(NSMutableArray*)load_Currency_All;
+(void)save_Currency_All:(int)coin dia:(int)dia;
+(int)load_Currency_Coin;
+(int)load_Currency_Dia;
+(void)save_Currency_Coin:(int)coin;
+(void)save_Currency_Dia:(int)dia;

+(void)submitScore_GameCenter:(NSInteger)score;

@end
