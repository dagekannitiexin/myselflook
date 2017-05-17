//
//  AppDelegate.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/5.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "AppDelegate.h"
#import <Realm.h>
#import "UserDefaultsManager.h"
#import "TabBarViewController.h"
#import <AFNetworkReachabilityManager.h>
#import "UserInfoManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.schemaVersion = 1;
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        if (oldSchemaVersion < 1) {
        }
    };
    [RLMRealmConfiguration setDefaultConfiguration:config];
    [RLMRealm defaultRealm];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    NSString *password = [UserDefaultsManager getUserPassword];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    if (password && ![password isEqualToString:@""] && password.length > 0) {
        [UserInfoManager sharedUserInfoManager].userAccount = [UserDefaultsManager getUserAccount];
        [UserInfoManager sharedUserInfoManager].userMD5Password = password;
        [UserInfoManager sharedUserInfoManager].userServerAddress = [UserDefaultsManager getUserServerAddress];
        UINavigationController *rootNAVI = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"rootNAVI"];
        self.window.rootViewController = rootNAVI;
        
    } else {
        UINavigationController *naviVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNaviVC"];
        self.window.rootViewController = naviVC;
    }
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
