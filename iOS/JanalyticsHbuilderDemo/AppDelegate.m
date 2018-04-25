//
//  AppDelegate.m
//  Pandora
//
//  Created by Mac Pro_C on 12-12-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "PDRCore.h"
#import "PDRCommonString.h"
#import "ViewController.h"
#import "PDRCoreApp.h"
#import "DCSplashAdObserver.h"
#import "PDRCoreAppManager.h"

// 示例默认带开屏广告，如果不需要广告，可注释下面一行
//#define dcSplashAd

@interface AppDelegate()
@end

@implementation AppDelegate

@synthesize window = _window;
#pragma mark -
#pragma mark app lifecycle
/*
 * @Summary:程序启动时收到push消息
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    BOOL ret = [PDRCore initEngineWihtOptions:launchOptions
                                  withRunMode:PDRCoreRunModeNormal];
    
#ifdef dcSplashAd
    // 获取广告所在的VC对象，如果对象存在说明可以显示广告，否则不显示splash广告
    DCH5ScreenAdvertising *adViewContoller = [DCSplashAdObserver splashAdViewController];
    if(adViewContoller){
        // 显示splash广告必须使用NavigationController作为当前应用的RootController，否则广告无法显示
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_window.rootViewController];
        navigationController.navigationBarHidden = YES;
        _window.rootViewController = navigationController;
        [navigationController pushViewController:adViewContoller animated:NO];
        // 必须监听当前广告关闭的事件，在事件触发时弹出当前的SplashAdVC，显示5+所在的VC
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(splashAdScreenWillClose) name:kDCSplashScreenCloseEvent object:nil];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [[PDRCore Instance] showLoadingPage];
            [[PDRCore Instance] start];
        });
    }
#else
    dispatch_async(dispatch_get_main_queue(), ^{
        [[PDRCore Instance] showLoadingPage];
        [[PDRCore Instance] start];
    });
#endif
    
    return ret;
}

#pragma mark -

#ifdef dcSplashAd
// splash广告关闭事件，用户可监听此事件关闭广告页面显示指定的VC
- (void)splashAdScreenWillClose{
//    [_window.rootViewController popToRootViewControllerAnimated:NO];
  [(UINavigationController *)_window.rootViewController popToRootViewControllerAnimated:NO];
}

#endif

#pragma mark - 系统事件通知
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
  completionHandler:(void(^)(BOOL succeeded))completionHandler{
    [PDRCore handleSysEvent:PDRCoreSysEventPeekQuickAction withObject:shortcutItem];
    completionHandler(true);
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    [PDRCore handleSysEvent:PDRCoreSysEventBecomeActive withObject:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application{
    [PDRCore handleSysEvent:PDRCoreSysEventResignActive withObject:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    [PDRCore handleSysEvent:PDRCoreSysEventEnterBackground withObject:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    [PDRCore handleSysEvent:PDRCoreSysEventEnterForeGround withObject:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application{
    [PDRCore destoryEngine];
}

#pragma mark -
#pragma mark URL

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    [self application:application handleOpenURL:url];
    return YES;
}

/*
 * @Summary:程序被第三方调用，传入参数启动
 *
 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [PDRCore handleSysEvent:PDRCoreSysEventOpenURL withObject:url];
    return YES;
}


/*
 * @Summary:远程push注册成功收到DeviceToken回调
 *
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"application--didRegisterForRemoteNotificationsWithDeviceToken[%@]", deviceToken);
    [PDRCore handleSysEvent:PDRCoreSysEventRevDeviceToken withObject:deviceToken];
}

/*
 * @Summary: 远程push注册失败
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [PDRCore handleSysEvent:PDRCoreSysEventRegRemoteNotificationsError withObject:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PDRCore handleSysEvent:PDRCoreSysEventRevRemoteNotification withObject:userInfo];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [self application:application didReceiveRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}


/*
 * @Summary:程序收到本地消息
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [PDRCore handleSysEvent:PDRCoreSysEventRevLocalNotification withObject:notification];
}


- (void)dealloc{
//    [super dealloc];
}
@end
