//
//  TabBarViewController.h
//  Yammy
//
//  Created by Alex on 13.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
  HomeTabBarIndex = 0,
  HotPageTabBarIndex,
  ActivityLineTabBarIndex,
  ChatListTabBarIndex,
  MyProfileTabBarIndex
} TabBarSelectIndex;

@interface TabBarViewController : UITabBarController

@property (assign, nonatomic) TabBarSelectIndex tabBarSelectIndex;

- (void)loadBadges;

@end

