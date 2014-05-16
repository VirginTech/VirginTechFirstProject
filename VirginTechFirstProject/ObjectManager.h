//
//  ObjectManager.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/15.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectManager : NSObject

//アビリティ一括ロード
+(NSMutableArray*)load_Object_Ability:(NSString*)objName;
//アビリティ一括セーブ
+(void)save_Object_Ability:(NSString*)objName
                                    attack:(float)attack
                                    defense:(float)defense
                                    traveling:(float)traveling;
//アビリティ個々に取得
+(float)load_Object_Ability_Attack:(NSString*)objName;
+(float)load_Object_Ability_Defense:(NSString*)objName;
+(float)load_Object_Ability_Traveling:(NSString*)objName;
//アビリティ個々に保存
+(void)save_Object_Ability_Attack:(NSString*)objName attack:(float)attack;
+(void)save_Object_Ability_Defense:(NSString*)objName defense:(float)defense;
+(void)save_Object_Ability_Traveling:(NSString*)objName traveling:(float)traveling;

@end
