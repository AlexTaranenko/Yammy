//
//  TutorialViewController.h
//  Yammy
//
//  Created by Alex on 2/28/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
  HotPageTutorialType = 0,
  MyPublicTutorialType,
  MyPrivateTutorialType,
  PeoplesTutorialType,
  ChatTutorialType
} TutorialType;

@interface TutorialViewController : UIViewController

@property (assign, nonatomic) TutorialType tutorialType;

@end

