//
//  ObjectManager.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/15.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectManager : NSObject

+(NSMutableArray*)load_Object_Ability:(NSString*)objName;
+(void)save_Object_Ability:(NSString*)objName
                                    attack:(float)attack
                                    defense:(float)defense
                                    traveling:(float)traveling;

@end
