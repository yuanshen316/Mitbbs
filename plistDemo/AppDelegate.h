//
//  AppDelegate.h
//  plistDemo
//
//  Created by Yuan Junsheng on 13-2-26.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *_navigationController;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RootViewController *rootViewController;

@end
