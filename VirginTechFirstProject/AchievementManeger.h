//
//  AchievementManeger.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/24.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AchievementManeger : NSObject

+(void)save_Achievement_All:(NSMutableArray*)array forKey:(NSString*)forKey;
+(NSMutableArray*)load_Achievement_All:(NSString*)forKey;

+(int)load_Achievement_Value:(int)index forKey:(NSString*)forKey;
+(int)load_Achievement_Point:(int)index forKey:(NSString*)forKey;
+(float)load_Achievement_Rate:(int)index forKey:(NSString*)forKey;
+(void)save_Achievement_Rate:(int)index forKey:(NSString*)forKey;
+(void)save_Achievement_All_Rate:(NSString*)forKey;
+(void)save_Achievement_All_Rate2:(NSString*)forKey;
+(bool)load_Achievement_Reward:(int)index forKey:(NSString*)forKey;
+(void)save_Achievement_Reward:(int)index reward:(bool)reward forKey:(NSString*)forKey;

+(void)reportAchievement_GameCenter:(float)percent identifier:(NSString*)identifier;

@end
