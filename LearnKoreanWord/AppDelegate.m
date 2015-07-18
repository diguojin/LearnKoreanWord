//
//  AppDelegate.m
//  LearnKoreanWord
//
//  Created by diguojin on 15/6/27.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import "AppDelegate.h"

#import "LexiconViewController.h"
#import "MyPageViewController.h"
#import "ReviewViewController.h"

@interface AppDelegate ()
@property (nonatomic, strong)DB *mydb;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    LexiconViewController *lexiconVC1 = [[LexiconViewController alloc]init];
    MyPageViewController *myPageVC2 = [[MyPageViewController alloc]init];
    ReviewViewController *reviewVC3 = [[ReviewViewController alloc]init];
    
    UINavigationController *naVC1 = [[UINavigationController alloc]initWithRootViewController:lexiconVC1];
    UINavigationController *naVC2 = [[UINavigationController alloc]initWithRootViewController:myPageVC2];
    UINavigationController *naVC3 = [[UINavigationController alloc]initWithRootViewController:reviewVC3];
    
    UITabBarController *TBC = [[UITabBarController alloc]init];
    TBC.viewControllers = @[naVC1 ,naVC2 ,naVC3];
    
    naVC1.tabBarItem = [[UITabBarItem alloc]initWithTitle: @"词库" image:[UIImage imageNamed:@"iconfont-book"] selectedImage:[UIImage imageNamed:@"iconfont-book"]];
    
    //TBC.tabBar.barTintColor = [UIColor colorWithRed:147/255.0 green:224/255.0 blue:225/255.0 alpha:1];

    naVC2.tabBarItem = [[UITabBarItem alloc]initWithTitle: @"统计" image:[UIImage imageNamed:@"iconfont-tongji"] selectedImage:[UIImage imageNamed:@"iconfont-tongji"]];
    
    naVC3.tabBarItem = [[UITabBarItem alloc]initWithTitle: @"复习" image:[UIImage imageNamed:@"iconfont-fuxi"] selectedImage:[UIImage imageNamed:@"iconfont-fuxi"]];
    
    self.window.rootViewController = TBC;
    [DB setDBfileFromResourceFileName:kResourceDBFile targetName:kTargetDBFile];

    _mydb = [DB sharedDBWithName:kTargetDBFile];
    
    //[_mydb updateEbbinghausRemParam];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[_mydb updateEbbinghausRemParam];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
