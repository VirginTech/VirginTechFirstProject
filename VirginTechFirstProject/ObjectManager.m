//
//  ObjectManager.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/15.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import "ObjectManager.h"

const float PLAYER01_ATTACK_RATIO=0.05f;
const float PLAYER01_DEFENSE_RATIO=0.5f;
const float PLAYER01_TRAVELING_RATIO=0.02f;

const float PLAYER02_ATTACK_RATIO=0.05f;
const float PLAYER02_DEFENSE_RATIO=0.25f;
const float PLAYER02_TRAVELING_RATIO=0.03f;

const float PLAYER03_ATTACK_RATIO=0.10f;
const float PLAYER03_DEFENSE_RATIO=0.5f;
const float PLAYER03_TRAVELING_RATIO=0.01f;

const float PLAYER04_ATTACK_RATIO=0.05f;
const float PLAYER04_DEFENSE_RATIO=1.0f;
const float PLAYER04_TRAVELING_RATIO=0.003f;

const float PLAYER05_ATTACK_RATIO=0.25f;
const float PLAYER05_DEFENSE_RATIO=1.5f;
const float PLAYER05_TRAVELING_RATIO=0.001f;

@implementation ObjectManager

//=========================================
//アビリティの取得（配列で一括） 0:レベル 1:攻撃力 2:防御力 3:移動能力 4:生産性
//=========================================
+(NSMutableArray*)load_Object_Ability_All:(NSString*)objName
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
	NSMutableArray *array = [[NSMutableArray alloc] init];
    array = [userDefault objectForKey:objName];
    return array;
}
//=========================================
//アビリティのセーブ（一括保存） 0:レベル 1:攻撃力 2:防御力 3:移動能力 4:生産性
//=========================================
+(void)save_Object_Ability_All:(NSString*)objName
                                            level:(int)level
                                            attack:(float)attack
                                            defense:(float)defense
                                            traveling:(float)traveling
                                            build:(int)build
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSArray* array=[NSArray arrayWithObjects:
                                                            [NSNumber numberWithInt:level],
                                                            [NSNumber numberWithFloat:attack],
                                                            [NSNumber numberWithFloat:defense],
                                                            [NSNumber numberWithFloat:traveling],
                                                            [NSNumber numberWithInt:build],nil];
    [userDefault setObject:array forKey:objName];
	[userDefault synchronize];
}
//=========================================
//　アビリティレベルの取得
//=========================================
+(int)load_Object_Ability_Level:(NSString*)objName
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    array=[self load_Object_Ability_All:objName];
    int level=[[array objectAtIndex:0]intValue];
    return level;
}
//=========================================
//　攻撃 アビリティの取得
//=========================================
+(float)load_Object_Ability_Attack:(NSString*)objName
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    array=[self load_Object_Ability_All:objName];
    float ability=[[array objectAtIndex:1]floatValue];
    return ability;
}
//=========================================
//　防御 アビリティの取得
//=========================================
+(float)load_Object_Ability_Defense:(NSString*)objName
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    array=[self load_Object_Ability_All:objName];
    float ability=[[array objectAtIndex:2]floatValue];
    return ability;
}
//=========================================
//　移動 アビリティの取得
//=========================================
+(float)load_Object_Ability_Traveling:(NSString*)objName
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    array=[self load_Object_Ability_All:objName];
    float ability=[[array objectAtIndex:3]floatValue];
    return ability;
}
//=========================================
//　生産 アビリティの取得
//=========================================
+(int)load_Object_Ability_Build:(NSString*)objName
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    array=[self load_Object_Ability_All:objName];
    int build=[[array objectAtIndex:4]intValue];
    return build;
}
//=========================================
//　アビリティレベルの保存
//=========================================
+(void)save_Object_Ability_Level:(NSString*)objName level:(int)level
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    NSMutableArray* tmpArray=[[NSMutableArray alloc]init];
    tmpArray=[self load_Object_Ability_All:objName];
    for(int i=0;i<tmpArray.count;i++){//コピー
        [array addObject:[tmpArray objectAtIndex:i]];
    }
    [array replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:level]];
    [self save_Object_Ability_All:objName
                                level:[[array objectAtIndex:0]intValue]
                                attack:[[array objectAtIndex:1]floatValue]
                                defense:[[array objectAtIndex:2]floatValue]
                                traveling:[[array objectAtIndex:3]floatValue]
                                build:[[array objectAtIndex:4]intValue]];
}
//=========================================
//　攻撃 アビリティの保存
//=========================================
+(void)save_Object_Ability_Attack:(NSString*)objName attack:(float)attack
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    NSMutableArray* tmpArray=[[NSMutableArray alloc]init];
    tmpArray=[self load_Object_Ability_All:objName];
    for(int i=0;i<tmpArray.count;i++){//コピー
        [array addObject:[tmpArray objectAtIndex:i]];
    }
    [array replaceObjectAtIndex:1 withObject:[NSNumber numberWithFloat:attack]];
    [self save_Object_Ability_All:objName
                                level:[[array objectAtIndex:0]intValue]
                                attack:[[array objectAtIndex:1]floatValue]
                                defense:[[array objectAtIndex:2]floatValue]
                                traveling:[[array objectAtIndex:3]floatValue]
                                build:[[array objectAtIndex:4]intValue]];
}
//=========================================
//　防御 アビリティの保存
//=========================================
+(void)save_Object_Ability_Defense:(NSString*)objName defense:(float)defense
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    NSMutableArray* tmpArray=[[NSMutableArray alloc]init];
    tmpArray=[self load_Object_Ability_All:objName];
    for(int i=0;i<tmpArray.count;i++){//コピー
        [array addObject:[tmpArray objectAtIndex:i]];
    }
    [array replaceObjectAtIndex:2 withObject:[NSNumber numberWithFloat:defense]];
    [self save_Object_Ability_All:objName
                        level:[[array objectAtIndex:0]intValue]
                       attack:[[array objectAtIndex:1]floatValue]
                      defense:[[array objectAtIndex:2]floatValue]
                    traveling:[[array objectAtIndex:3]floatValue]
                        build:[[array objectAtIndex:4]intValue]];
}
//=========================================
//　移動 アビリティの保存
//=========================================
+(void)save_Object_Ability_Traveling:(NSString*)objName traveling:(float)traveling
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    NSMutableArray* tmpArray=[[NSMutableArray alloc]init];
    tmpArray=[self load_Object_Ability_All:objName];
    for(int i=0;i<tmpArray.count;i++){//コピー
        [array addObject:[tmpArray objectAtIndex:i]];
    }
    [array replaceObjectAtIndex:3 withObject:[NSNumber numberWithFloat:traveling]];
    [self save_Object_Ability_All:objName
                        level:[[array objectAtIndex:0]intValue]
                       attack:[[array objectAtIndex:1]floatValue]
                      defense:[[array objectAtIndex:2]floatValue]
                    traveling:[[array objectAtIndex:3]floatValue]
                        build:[[array objectAtIndex:4]intValue]];
}
//=========================================
//　生産 アビリティの保存
//=========================================
+(void)save_Object_Ability_Build:(NSString*)objName build:(int)build
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    NSMutableArray* tmpArray=[[NSMutableArray alloc]init];
    tmpArray=[self load_Object_Ability_All:objName];
    for(int i=0;i<tmpArray.count;i++){//コピー
        [array addObject:[tmpArray objectAtIndex:i]];
    }
    [array replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:build]];
    [self save_Object_Ability_All:objName
                        level:[[array objectAtIndex:0]intValue]
                       attack:[[array objectAtIndex:1]floatValue]
                      defense:[[array objectAtIndex:2]floatValue]
                    traveling:[[array objectAtIndex:3]floatValue]
                        build:[[array objectAtIndex:4]intValue]];
}

//=========================================
//　アビリティのレベルアップ
//=========================================
+(void)levelUp_Object_Ability:(NSString*)objName
{
    if([objName isEqualToString:@"player01"]){
        [self save_Object_Ability_Level:objName level:[self load_Object_Ability_Level:objName]+1];
        [self save_Object_Ability_Attack:objName attack:[self load_Object_Ability_Attack:objName]+PLAYER01_ATTACK_RATIO];
        [self save_Object_Ability_Defense:objName defense:[self load_Object_Ability_Defense:objName]+PLAYER01_DEFENSE_RATIO];
        [self save_Object_Ability_Traveling:objName traveling:[self load_Object_Ability_Traveling:objName]+PLAYER01_TRAVELING_RATIO];
        [self save_Object_Ability_Build:objName build:[self load_Object_Ability_Build:objName]];
    }else if([objName isEqualToString:@"player02"]){
        [self save_Object_Ability_Level:objName level:[self load_Object_Ability_Level:objName]+1];
        [self save_Object_Ability_Attack:objName attack:[self load_Object_Ability_Attack:objName]+PLAYER02_ATTACK_RATIO];
        [self save_Object_Ability_Defense:objName defense:[self load_Object_Ability_Defense:objName]+PLAYER02_DEFENSE_RATIO];
        [self save_Object_Ability_Traveling:objName traveling:[self load_Object_Ability_Traveling:objName]+PLAYER02_TRAVELING_RATIO];
        [self save_Object_Ability_Build:objName build:[self load_Object_Ability_Build:objName]];
    }else if([objName isEqualToString:@"player03"]){
        [self save_Object_Ability_Level:objName level:[self load_Object_Ability_Level:objName]+1];
        [self save_Object_Ability_Attack:objName attack:[self load_Object_Ability_Attack:objName]+PLAYER03_ATTACK_RATIO];
        [self save_Object_Ability_Defense:objName defense:[self load_Object_Ability_Defense:objName]+PLAYER03_DEFENSE_RATIO];
        [self save_Object_Ability_Traveling:objName traveling:[self load_Object_Ability_Traveling:objName]+PLAYER03_TRAVELING_RATIO];
        [self save_Object_Ability_Build:objName build:[self load_Object_Ability_Build:objName]];
    }else if([objName isEqualToString:@"player04"]){
        [self save_Object_Ability_Level:objName level:[self load_Object_Ability_Level:objName]+1];
        [self save_Object_Ability_Attack:objName attack:[self load_Object_Ability_Attack:objName]+PLAYER04_ATTACK_RATIO];
        [self save_Object_Ability_Defense:objName defense:[self load_Object_Ability_Defense:objName]+PLAYER04_DEFENSE_RATIO];
        [self save_Object_Ability_Traveling:objName traveling:[self load_Object_Ability_Traveling:objName]+PLAYER04_TRAVELING_RATIO];
        [self save_Object_Ability_Build:objName build:[self load_Object_Ability_Build:objName]];
    }else if([objName isEqualToString:@"player05"]){
        [self save_Object_Ability_Level:objName level:[self load_Object_Ability_Level:objName]+1];
        [self save_Object_Ability_Attack:objName attack:[self load_Object_Ability_Attack:objName]+PLAYER05_ATTACK_RATIO];
        [self save_Object_Ability_Defense:objName defense:[self load_Object_Ability_Defense:objName]+PLAYER05_DEFENSE_RATIO];
        [self save_Object_Ability_Traveling:objName traveling:[self load_Object_Ability_Traveling:objName]+PLAYER05_TRAVELING_RATIO];
        [self save_Object_Ability_Build:objName build:[self load_Object_Ability_Build:objName]];
    }
}

@end
