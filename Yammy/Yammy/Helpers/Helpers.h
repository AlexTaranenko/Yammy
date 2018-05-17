//
//  Helpers.h
//  Yammy
//
//  Created by Alex on 13.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helpers : NSObject

+ (void)setupAppereance;

+ (UIViewController *)createCustomVCByStoryboardName:(NSString *)storyboardName andStoryboardId:(NSString *)storyboardId;

+ (UIToolbar *)createToolbarWithTarget:(id)target WithHandler:(SEL)handler;

+ (void)showSpinner;

+ (void)showSpinnerWithProgress:(float)progress;

+ (void)hideSpinner;

+ (void)saveAccessToken:(NSString *)accessToken;

+ (NSString *)getAccessToken;

+ (CATransition *)setupAnimation;

+ (void)dismissCustomView:(UIView *)customView;

+ (CGRect)sizeOfLabel:(UILabel *)label;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+ (NSString *)prepareDateFormatterByDate:(NSDate *)date andDateFormat:(NSString *)dateFormat;

+ (NSDate *)defaultDate;

+ (void)prepareSexImageIconByImageView:(UIImageView *)imageView withProfileMapping:(ProfileMapping *)profileMapping;

+ (void)startSoundIsEnd:(BOOL)isEnd;

+ (void)prepareStatusBarWithColor:(UIColor *)color;

+ (void)changeNavBarColor:(UINavigationBar *)navBar andColor:(UIColor *)color;

+ (BOOL)isShowHotPageTutorial;

+ (void)saveShowHotPageTutorial;

+ (void)prepareLabelsByProfileMapping:(ProfileMapping *)profileMapping withLabel:(UILabel *)label;

+ (UIColor *)prepareButtonColorIsHasPrivateProfile:(BOOL)isHasPrivateProfile andIsHidden:(BOOL)isHidden;

+ (UIColor *)prepareButtonColorIsHasPrivateProfile:(BOOL)isHasPrivateProfile;

+ (NSString *)prepareButtonIsHasPrivateProfile:(BOOL)isHasPrivateProfile andIsHidden:(BOOL)isHidden;

+ (NSString *)prepareButtonIsHasPrivateProfile:(BOOL)isHasPrivateProfile;

+ (void)prepareStrawberryButtons:(NSArray *)strawberryButtons withProfile:(ProfileMapping *)profileMapping isMyProfile:(BOOL)isMyProfile;

+ (void)showCustomView:(UIView *)customView;

+ (void)resetValues;

+ (BOOL)isShowMyPublicProfileTutorial;

+ (void)saveShowMyPublicProfileTutorial;

+ (BOOL)isShowMyPrivateProfileTutorial;

+ (void)saveShowMyPrivateProfileTutorial;

+ (BOOL)isShowPeoplesTutorial;

+ (void)saveShowPeoplesTutorial;

+ (BOOL)isShowChatTutorial;

+ (void)saveShowChatTutorial;

@end

