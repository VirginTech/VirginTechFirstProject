//
//  ObjectManager.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/15.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const float PLAYER01_ATTACK_RATIO;
extern const float PLAYER01_DEFENSE_RATIO;
extern const float PLAYER01_TRAVELING_RATIO;

extern const float PLAYER02_ATTACK_RATIO;
extern const float PLAYER02_DEFENSE_RATIO;
extern const float PLAYER02_TRAVELING_RATIO;

extern const float PLAYER03_ATTACK_RATIO;
extern const float PLAYER03_DEFENSE_RATIO;
extern const float PLAYER03_TRAVELING_RATIO;

extern const float PLAYER04_ATTACK_RATIO;
extern const float PLAYER04_DEFENSE_RATIO;
extern const float PLAYER04_TRAVELING_RATIO;

extern const float PLAYER05_ATTACK_RATIO;
extern const float PLAYER05_DEFENSE_RATIO;
extern const float PLAYER05_TRAVELING_RATIO;

@interface ObjectManager : NSObject

//アビリティ一括ロード
+(NSMutableArray*)load_Object_Ability_All:(NSString*)objName;
//アビリティ一括セーブ
+(void)save_Object_Ability_All:(NSString*)objName
                                        level:(int)level
                                        attack:(float)attack
                                        defense:(float)defense
                                        traveling:(float)traveling
                                        build:(int)build;
//アビリティ個々に取得
+(int)load_Object_Ability_Level:(NSString*)objName;
+(float)load_Object_Ability_Attack:(NSString*)objName;
+(float)load_Object_Ability_Defense:(NSString*)objName;
+(float)load_Object_Ability_Traveling:(NSString*)objName;
+(int)load_Object_Ability_Build:(NSString*)objName;

//アビリティ個々に保存
+(void)save_Object_Ability_Level:(NSString*)objName level:(int)level;
+(void)save_Object_Ability_Attack:(NSString*)objName attack:(float)attack;
+(void)save_Object_Ability_Defense:(NSString*)objName defense:(float)defense;
+(void)save_Object_Ability_Traveling:(NSString*)objName traveling:(float)traveling;
+(void)save_Object_Ability_Build:(NSString*)objName build:(int)build;

//アビリティ・レベルアップ
+(void)levelUp_Object_Ability:(NSString*)objName;

@end
