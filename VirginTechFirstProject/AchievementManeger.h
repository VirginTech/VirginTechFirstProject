//
//  AchievementManeger.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/24.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AchievementManeger : NSObject

+(void)save_Achievement_Tank_All:(NSMutableArray*)array;
+(NSMutableArray*)load_Achievement_Tank_All;

+(int)load_Achievement_Tank_Value:(int)index;
+(int)load_Achievement_Tank_Point:(int)index;
+(float)load_Achievement_Tank_Rate:(int)index;
+(void)save_Achievement_Tank_Rate:(int)index;
+(void)save_Achievement_All_Tank_Rate;
+(void)save_Achievement_All_Tank_Rate2;
+(bool)load_Achievement_Tank_Reward:(int)index;
+(void)save_Achievement_Tank_Reward:(int)index reward:(bool)reward;

+(void)reportAchievement_GameCenter:(float)percent;

@end
