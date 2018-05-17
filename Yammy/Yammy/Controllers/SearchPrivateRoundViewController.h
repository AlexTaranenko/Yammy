//
//  SearchPrivateRoundViewController.h
//  Yammy
//
//  Created by Alex on 9/4/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchPrivateModel.h"
#import "PrivateProfileMapping.h"

@protocol SearchPrivateRoundViewControllerDelegate <NSObject>

@optional

- (void)updatePreferencesAtThePrivateProfileByAddedPreferencesArray:(NSArray *)addedPreferences;

- (void)searchProfilesWithParams:(NSDictionary *)params;

@end

@interface SearchPrivateRoundViewController : UIViewController

@property (weak, nonatomic) id <SearchPrivateRoundViewControllerDelegate> delegate;

@property (strong, nonatomic) SearchPrivateModel *searchPrivateModel;

@property (strong, nonatomic) PrivateProfileMapping *privateProfileMapping;

@end

