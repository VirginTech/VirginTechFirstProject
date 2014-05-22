//
//  Information.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/04/30.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface InformationLayer : CCScene
{    
    //int coin;
    //int diamond;
}

//@property int coin;
//@property int diamond;

+ (InformationLayer *)scene;
- (id)init;

+(void)update_CurrencyLabel;
+(void)update_HighScoreLabel;

@end
