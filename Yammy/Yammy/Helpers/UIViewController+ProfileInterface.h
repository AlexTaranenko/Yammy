//
//  UIViewController+ProfileInterface.h
//  Yammy
//
//  Created by Alex on 11/16/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicProfileAboutMeModel.h"

@interface UIViewController (ProfileInterface)

- (void)presentNameAlertWithName:(NSString *)name withCompletion:(void(^)(NSString *outputText))completion;

- (void)presentBirthdayAlertByDate:(NSDate *)date withCompletion:(void(^)(NSDate *date))completion;

- (NSDictionary *)paramsForUpdateAboutMeWithPublicProfileAboutMeModel:(PublicProfileAboutMeModel *)publicProfileAboutMeModel;

@end

