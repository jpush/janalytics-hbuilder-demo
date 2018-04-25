//
//  DCADManager.h
//  libPDRCore
//
//  Created by X on 2018/2/6.
//  Copyright © 2018年 DCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCADLaunch.h"

@interface DCADManager : NSObject
@property(nonatomic, strong)NSDictionary *adsSetting;
+ (DCADManager*)adManager;
- (DCADLaunch*)getLaunchAD;
- (void)clickLaunchAD:(DCADLaunch*)launchAD;
- (void)impLaunchAD:(DCADLaunch*)launchAD;
- (void)destroy;
@end
