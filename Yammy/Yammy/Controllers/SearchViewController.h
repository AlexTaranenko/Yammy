//
//  SearchViewController.h
//  Yammy
//
//  Created by Alex on 30.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchModel.h"

@protocol SearchViewControllerDelegate <NSObject>

@optional

- (void)getSearchGeneralWithParams:(NSDictionary *)params;

- (void)privateSearchByParams:(NSDictionary *)params;

- (void)updatePreferencesAtThePrivateProfileByAddedPreferencesArray:(NSArray *)addedPreferences;

@end

@interface SearchViewController : UIViewController

@property (weak, nonatomic) id<SearchViewControllerDelegate> delegate;

@property (strong, nonatomic) SearchModel *searchModel;

@property (strong, nonatomic) PrivateProfileMapping *privateProfileMapping;

@end

