//
//  LanguagesViewController.h
//  Yammy
//
//  Created by Alex on 1/29/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicProfileAboutMeModel.h"
#import "UserSettingsMapping.h"

@protocol LanguagesViewControllerDelegate <NSObject>

@optional

- (void)setupLanguageByMapping:(LanguageMapping *)mapping;

- (void)deleteLanguageByMapping:(LanguageMapping *)mapping;

- (void)changeLanguageByMapping:(LanguageMapping *)mapping;

@end

@interface LanguagesViewController : UIViewController

@property (weak, nonatomic) id<LanguagesViewControllerDelegate> delegate;

@property (strong, nonatomic) PublicProfileAboutMeModel *publicProfileAboutMeModel;

@property (strong, nonatomic) UserSettingsMapping *userSettingsMapping;

@property (strong, nonatomic) NSMutableArray *addedLanguages;

@property (assign, nonatomic) BOOL isChange;

@end

