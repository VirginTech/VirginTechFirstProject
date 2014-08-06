//
//  NendAdLayer.h
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/08/05.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NADView.h"

@interface NendAdLayer : CCScene <NADViewDelegate>  {
    
    NADView* _nadView;
}

@property (nonatomic, retain) NADView * _nadView;

@end
