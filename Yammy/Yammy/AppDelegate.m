//
//  AppDelegate.m
//  Yammy
//
//  Created by Alex on 12.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "FacebookHalper.h"
#import "GooglePlusHelper.h"
#import "VKHelper.h"
#import "OKHelper.h"
#import "SplashViewController.h"
#import "NotificationsHelper.h"
#import <YandexMobileMetrica/YandexMobileMetrica.h>

@import GooglePlaces;

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above.
@interface AppDelegate () <UNUserNotificationCenterDelegate>
@end
#endif

// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  
  [GLobalRealReachability startNotifier];
  
  self.isDidTapNotification = NO;
  self.notification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
  
  [self setupUserNotificationsByApplication:application];
  
  [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
  
  [GMSPlacesClient provideAPIKey:GOOGLE_PLACES_API_KEY];
  
  [[RestKitClient sharedClient] setupRestKitMapping];
    
    //Инициализация AppMetrica SDK
    [YMMYandexMetrica activateWithApiKey:YANDEX_METRICA_API_KEY];
  
  [Helpers setupAppereance];
  [self setupViewController];
  
  return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
  [Helpers hideSpinner];
  if ([GooglePlusHelper handleURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]]) {
    return [GooglePlusHelper handleURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
  } else if ([url.scheme isEqualToString:[[FacebookHalper sharedFacebookHelper] urlSheme]]) {
    return [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url options:options];
  } else if ([VKHelper handleURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsSourceApplicationKey]]) {
    return [VKHelper handleURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsSourceApplicationKey]];
  } else if ([OKHelper handleURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsSourceApplicationKey]]) {
    return [OKHelper handleURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsSourceApplicationKey]];
  } else {
    return YES;
  }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  [Helpers hideSpinner];
  if ([GooglePlusHelper handleURL:url sourceApplication:sourceApplication annotation:annotation]) {
    return [GooglePlusHelper handleURL:url sourceApplication:sourceApplication annotation:annotation];
  } else if ([url.scheme isEqualToString:[[FacebookHalper sharedFacebookHelper] urlSheme]]) {
    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
  } else if ([VKHelper handleURL:url sourceApplication:sourceApplication annotation:annotation]) {
    return [VKHelper handleURL:url sourceApplication:sourceApplication annotation:annotation];
  } else if ([OKHelper handleURL:url sourceApplication:sourceApplication annotation:annotation]) {
    return [OKHelper handleURL:url sourceApplication:sourceApplication annotation:annotation];
  } else {
    return YES;
  }
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  // Saves changes in the application's managed object context before the application terminates.
  [self saveContext];
}





#pragma mark - Setup controllers

- (void)setupViewController {
  [self setupSplashController];
  //  [self setupTabBarController];
}

- (void)setupTabBarControllerWithSelectIndex:(TabBarSelectIndex)tabBarSelectIndex {
  //    UIViewController *oldViewController = self.window.rootViewController;
  TabBarViewController *tabBar = (TabBarViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:TAB_BAR_STORYBOARD_ID];
  tabBar.tabBarSelectIndex = tabBarSelectIndex;
  //    [UIView transitionFromView:oldViewController.view toView:tabBar.view duration:0.1f options:UIViewAnimationOptionAllowAnimatedContent completion:^(BOOL finished) {
  self.window.rootViewController = tabBar;
  [Helpers prepareStatusBarWithColor:RGB(249, 0, 64)];
  
  if(IS_IPHONE_X)
    self.window.rootViewController.view.frame = CGRectMake(self.window.rootViewController.view.frame.origin.x, self.window.rootViewController.view.frame.origin.y, self.window.rootViewController.view.frame.size.width, self.window.rootViewController.view.frame.size.height + 32) ;
  //    }];
}

- (void)setupSplashController {
  UINavigationController *navSplashVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Splash" andStoryboardId:SPLASH_STORYBOARD_ID];
  self.window.rootViewController = navSplashVC;
  [Helpers prepareStatusBarWithColor:RGB(249, 0, 64)];
}

- (void)setupLoginController {
  //  UIViewController *oldViewController = self.window.rootViewController;
  UINavigationController *navLoginVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Login" andStoryboardId:LOGIN_STORYBOARD_ID];
  LoginViewController *loginVC = (LoginViewController *)[navLoginVC topViewController];
  
  //  [UIView transitionFromView:oldViewController.view toView:loginVC.view duration:0.1f options:UIViewAnimationOptionAllowAnimatedContent completion:^(BOOL finished) {
  self.window.rootViewController = navLoginVC;
  [Helpers prepareStatusBarWithColor:RGB(249, 0, 64)];
  //  }];
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
  // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
  @synchronized (self) {
    if (_persistentContainer == nil) {
      _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Yammy"];
      [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
        if (error != nil) {
          // Replace this implementation with code to handle the error appropriately.
          // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
          
          /*
           Typical reasons for an error here include:
           * The parent directory does not exist, cannot be created, or disallows writing.
           * The persistent store is not accessible, due to permissions or data protection when the device is locked.
           * The device is out of space.
           * The store could not be migrated to the current model version.
           Check the error message to determine what the actual problem was.
           */
          NSLog(@"Unresolved error %@, %@", error, error.userInfo);
          abort();
        }
      }];
    }
  }
  
  return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
  NSManagedObjectContext *context = self.persistentContainer.viewContext;
  NSError *error = nil;
  if ([context hasChanges] && ![context save:&error]) {
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
    abort();
  }
}

#pragma mark - Notifications

NSString *const kGCMMessageIDKey = @"866378984645";

- (void)setupUserNotificationsByApplication:(UIApplication *)application {
  // [START configure_firebase]
  [FIRApp configure];
  // [END configure_firebase]
  
  // [START set_messaging_delegate]
  [FIRMessaging messaging].delegate = self;
  // [END set_messaging_delegate]
  
  // Register for remote notifications. This shows a permission dialog on first run, to
  // show the dialog at a more appropriate time move this registration accordingly.
  if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
    // iOS 7.1 or earlier. Disable the deprecation warnings.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIRemoteNotificationType allNotificationTypes = (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge);
    [application registerForRemoteNotificationTypes:allNotificationTypes];
#pragma clang diagnostic pop
  } else {
    // iOS 8 or later
    // [START register_for_notifications]
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
      UIUserNotificationType allNotificationTypes = (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
      UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
      [application registerUserNotificationSettings:settings];
    } else {
      // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
      // For iOS 10 display notification (sent via APNS)
      [UNUserNotificationCenter currentNotificationCenter].delegate = self;
      UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
      [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions
                                                                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                                                            // TODO: !granted -> alert
                                                                          }];
#endif
    }
    
    [application registerForRemoteNotifications];
    // [END register_for_notifications]
  }
}


// [START receive_message]
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
  // If you are receiving a notification message while your app is in the background,
  // this callback will not be fired till the user taps on the notification launching the application.
  // TODO: Handle data of notification
  
  // With swizzling disabled you must let Messaging know about the message, for Analytics
  [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
  
  [[NotificationsHelper shared] appDidReceiveRemoteNotification:userInfo];
  
  // Print full message.
  NSLog(@"%@", userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  // If you are receiving a notification message while your app is in the background,
  // this callback will not be fired till the user taps on the notification launching the application.
  // TODO: Handle data of notification
  
  // With swizzling disabled you must let Messaging know about the message, for Analytics
  [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
  
  [[NotificationsHelper shared] appDidReceiveRemoteNotification:userInfo];
  
  completionHandler(UIBackgroundFetchResultNewData);
}
// [END receive_message]

// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
  NSDictionary *userInfo = notification.request.content.userInfo;
  
  // With swizzling disabled you must let Messaging know about the message, for Analytics
  [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
  
  [[NotificationsHelper shared] appDidReceiveRemoteNotification:userInfo];
  // Change this to your preferred presentation option
  completionHandler(UNNotificationPresentationOptionNone);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response
#if defined(__IPHONE_11_0)
         withCompletionHandler:(void(^)(void))completionHandler {
#else
withCompletionHandler:(void(^)())completionHandler {
#endif
  NSDictionary *userInfo = response.notification.request.content.userInfo;
  [[NotificationsHelper shared] userDidTapRemoteNotification:userInfo];
  completionHandler();
}
#endif
  // [END ios_10_message_handling]
  
  - (void)applicationReceivedRemoteMessage:(nonnull FIRMessagingRemoteMessage *)remoteMessage {
    [[NotificationsHelper shared] appDidReceiveRemoteNotification:remoteMessage.appData];
  }
  
  // [START refresh_token]
  - (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    [[NotificationsHelper shared] setDeviceToken:fcmToken];
  }
  // [END refresh_token]
  
  // [START ios_10_data_message]
  // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
  // To enable direct data messages, you can set [Messaging messaging].shouldEstablishDirectChannel to YES.
  - (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    [[NotificationsHelper shared] appDidReceiveRemoteNotification:remoteMessage.appData];
  }
  // [END ios_10_data_message]
  
  - (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[NotificationsHelper shared] setDeviceToken:nil];
    // TODO: show alert error
    NSLog(@"Unable to register for remote notifications: %@", error);
  }
  
  // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
  // If swizzling is disabled then this function must be implemented so that the APNs device token can be paired to
  // the FCM registration token.
  - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[FIRMessaging messaging] setAPNSToken:deviceToken];
    NSString *fcmToken = [[FIRMessaging messaging] FCMToken];
    [[NotificationsHelper shared] setDeviceToken:fcmToken];
  }
  
  /// This method will be called whenever FCM receives a new, default FCM token for your
  /// Firebase project's Sender ID.
  /// You can send this token to your application server to send notifications to this device.
  - (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken
  {
    [[NotificationsHelper shared] setDeviceToken:fcmToken];
  }
  
  
  
  @end
  
  

