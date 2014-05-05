//
//  GameManager.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/05/01.
//  Copyright (c) 2014年 VirginTech LLC. All rights reserved.
//

#import "GameManager.h"

@implementation GameManager

int deviceType;// 1:iPhone5 2:iPhone4 3:iPad2
int stageLevel;//ステージレベル

//デバイス取得／登録
+(void)setDevice:(int)type{
    deviceType=type;
}
+(int)getDevice{
    return deviceType;
}

//ステージレベル取得／登録
+(void)setStageLevel:(int)level{
    stageLevel=level;
}
+(int)getStageLevel{
    return stageLevel;
}

@end
