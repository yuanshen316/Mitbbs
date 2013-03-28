//
//  AppDelegate.h
//  Mitbbs
//
//  Created by Yuan Junsheng on 13-3-16.
//  Copyright (c) 2013年 Yuan Junsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RootViewController *rootViewController;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
