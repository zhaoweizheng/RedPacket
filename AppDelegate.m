//
//  AppDelegate.m
//  RedPacket
//
//  Created by mistong on 16/1/15.
//  Copyright © 2016年 赵伟争. All rights reserved.
//

#import "AppDelegate.h"
#import "AKSInfoMessageView.h"
#import "InfoMessageView.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)aksInfoMessageFor:(float)duration withMessage:(NSString*) message withFontSize:(int)size ShowTextOnly:(BOOL)showTextOnly IsAnimationRequired:(BOOL)isAnimationRequired ClearPreviousMessages:(BOOL)clear ColorWithR:(int) r G:(int)g B:(int) b IsBlinking:(BOOL)blink IsWritingAnimation:(BOOL)isWritingAnimation Frame:(CGRect) Frame
{
    [[AKSInfoMessageView sharedAKSInfoMessageView] aksInfoMessageFor:duration withMessage:message withFontSize:size ShowTextOnly:showTextOnly isAnimationRequired:isAnimationRequired ClearPreviousMessages:clear ColorWithR:r G:g B:b IsBlinking:blink IsWritingAnimation:isWritingAnimation Frame:Frame];
}

-(void)infoMessageFor:(float)duration withMessage:(NSString*) message withFontSize:(int)size ShowTextOnly:(BOOL)showTextOnly IsAnimationRequired:(BOOL)isAnimationRequired ClearPreviousMessages:(BOOL)clear ColorWithR:(int) r G:(int)g B:(int) b IsBlinking:(BOOL)blink IsWritingAnimation:(BOOL)isWritingAnimation Frame:(CGRect) Frame
{
    [[InfoMessageView sharedAKSInfoMessageView] infoMessageFor:duration withMessage:message withFontSize:size ShowTextOnly:showTextOnly isAnimationRequired:isAnimationRequired ClearPreviousMessages:clear ColorWithR:r G:g B:b IsBlinking:blink IsWritingAnimation:isWritingAnimation Frame:Frame];
}

- (UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO; //返回NO表示要显示，返回YES将hiden
}

-(void)cleanupMessages
{
    [[AKSInfoMessageView sharedAKSInfoMessageView] cleanUpEverything];
}
@end
