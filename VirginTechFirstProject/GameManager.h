//
//  GameManager.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/01.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const int STAGE_LEVEL_MAX;
extern const int COIN_VAL;
extern const int DIA_VAL;

@interface GameManager : NSObject
{
    
}

+(void)setLocale:(int)value;//1:英語 2:日本語
+(int)getLocale;
+(void)setDevice:(int)type;// 1:iPhone5 2:iPhone4 3:iPad2
+(int)getDevice;
+(void)setOsVersion:(float)version;
+(float)getOsVersion;
+(void)setStageLevel:(int)level;
+(int)getStageLevel;
+(void)setWorldSize:(CGSize)size;
+(CGSize)getWorldSize;

+(void)setPlaying:(bool)flg;
+(bool)getPlaying;
+(void)setPauseing:(bool)flg;
+(bool)getPauseing;
+(void)setPauseStateChange:(bool)flg;
+(bool)getPauseStateChange;
+(void)setActive:(bool)flg;
+(bool)getActive;

+(NSMutableArray*)load_Currency_All;
+(void)save_Currency_All:(int)coin dia:(int)dia;
+(int)load_Currency_Coin;
+(int)load_Currency_Dia;
+(void)save_Currency_Coin:(int)coin;
+(void)save_Currency_Dia:(int)dia;

+(void)in_Out_Coin:(int)quantity addFlg:(bool)addFlg;
+(void)in_Out_Dia:(int)quantity addFlg:(bool)addFlg;

+(void)save_HighScore:(long)score;
+(long)load_HighScore;

+(void)submitScore_GameCenter:(NSInteger)score;
+(void)get_HighScore_GameCenter;

+(void)save_Aggregate_All:(int)tank fortress:(int)fortress level:(int)level stage:(int)stage;
+(NSMutableArray*)load_Aggregate_All;
+(int)load_Aggregate_Tank;
+(int)load_Aggregate_Fortress;
+(int)load_Aggregate_Level;
+(int)load_Aggregate_Stage;
+(void)save_Aggregate_Tank:(int)tank;
+(void)save_Aggregate_Fortress:(int)fortress;
+(void)save_Aggregate_Level:(int)level;
+(void)save_Aggregate_Stage:(int)stage;

+(NSDate*)load_Login_Date;
+(void)save_login_Date:(NSDate*)date;

+(void)save_StageClear_State:(int)stageNum rate:(int)rate;
+(int)load_StageClear_State:(int)stageNum;

@end
