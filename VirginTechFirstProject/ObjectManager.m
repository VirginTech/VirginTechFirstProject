//
//  ObjectManager.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/15.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import "ObjectManager.h"

@implementation ObjectManager

//=========================================
//アビリティの取得（一括） 0:攻撃力 1:防御力 2:移動能力
//=========================================
+(NSMutableArray*)load_Object_Ability:(NSString*)objName
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
	NSMutableArray *array = [[NSMutableArray alloc] init];
    array = [userDefault objectForKey:objName];
    return array;
}
//=========================================
//アビリティのセーブ 0:攻撃力 1:防御力 2:移動能力
//=========================================
+(void)save_Object_Ability:(NSString*)objName
                                            attack:(float)attack
                                            defense:(float)defense
                                            traveling:(float)traveling
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSArray* array=[NSArray arrayWithObjects:[NSString stringWithFormat:@"%f",attack],
                                                            [NSString stringWithFormat:@"%f",defense],
                                                            [NSString stringWithFormat:@"%f",traveling],
                                                            nil];
    [userDefault setObject:array forKey:objName];
	[userDefault synchronize];
}
@end
