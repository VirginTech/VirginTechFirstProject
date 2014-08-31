//
//  AdGenerLayer.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/08/31.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ADGManagerViewController.h"

@interface AdGenerLayer : CCScene <ADGManagerViewControllerDelegate>
{
    //UIViewController *adView;
    ADGManagerViewController *adg_;
}

//@property (nonatomic, retain) ADGManagerViewController *adg;

+ (AdGenerLayer *)scene;
- (id)init;

@end
