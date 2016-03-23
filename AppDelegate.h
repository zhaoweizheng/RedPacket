//
//  AppDelegate.h
//  RedPacket
//
//  Created by mistong on 16/1/15.
//  Copyright © 2016年 赵伟争. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


-(void)aksInfoMessageFor:(float)duration withMessage:(NSString*) message withFontSize:(int)size ShowTextOnly:(BOOL)showTextOnly IsAnimationRequired:(BOOL)isAnimationRequired ClearPreviousMessages:(BOOL)clear ColorWithR:(int) r G:(int)g B:(int) b IsBlinking:(BOOL)blink IsWritingAnimation:(BOOL)isWritingAnimation Frame:(CGRect) Frame;
-(void)infoMessageFor:(float)duration withMessage:(NSString*) message withFontSize:(int)size ShowTextOnly:(BOOL)showTextOnly IsAnimationRequired:(BOOL)isAnimationRequired ClearPreviousMessages:(BOOL)clear ColorWithR:(int) r G:(int)g B:(int) b IsBlinking:(BOOL)blink IsWritingAnimation:(BOOL)isWritingAnimation Frame:(CGRect) Frame;
@end

