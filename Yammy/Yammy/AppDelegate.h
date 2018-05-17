//
//  AppDelegate.h
//  Yammy
//
//  Created by Alex on 12.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TabBarViewController.h"

@import Firebase;
@import FirebaseMessaging;
@interface AppDelegate : UIResponder <UIApplicationDelegate, FIRMessagingDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (strong, nonatomic) NSDictionary *notification;

@property (assign, nonatomic) BOOL isDidTapNotification;

- (void)saveContext;

- (void)setupTabBarControllerWithSelectIndex:(TabBarSelectIndex)tabBarSelectIndex;

- (void)setupLoginController;

@end

