//
//  Helpers.m
//  Yammy
//
//  Created by Alex on 13.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "Helpers.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <WYPopoverController/WYPopoverController.h>
#import <AudioToolbox/AudioToolbox.h>
#import "DirectConnectionClient.h"

static NSString *kAccessToken = @"Access Token";
static NSString *kEndRecordPath = @"file:///System/Library/Audio/UISounds/end_record.caf";
static NSString *kBeginRecordPath = @"file:///System/Library/Audio/UISounds/begin_record.caf";
static NSString *kSaveShowHotPageTutorial = @"Show HotPage Tutorial";
static NSString *kSaveShowMyPublicTutorial = @"Show My Public Profile Tutorial";
static NSString *kSaveShowMyPrivateTutorial = @"Show My Private Profile Tutorial";
static NSString *kSaveShowPeoplesTutorial = @"Show Peoples Tutorial";
static NSString *kSaveShowChatTutorial = @"Show Chat Tutorial";

@implementation Helpers

+ (void)setupAppereance {
  [[UINavigationBar appearance] setBarTintColor:RGB(249, 0, 64)];
  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
  [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:NOTOSANSDISPLAY_BOLD size:18.0]}];
  
  [[UITabBar appearance] setBarTintColor:RGB(250, 250, 250)];
  [[UITabBar appearance] setTintColor:RGB(249, 0, 64)];
  
  [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
  [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
  
  [[UITabBarItem appearance] setBadgeTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                      NSFontAttributeName : [UIFont fontWithName:NOTOSANSDISPLAY_BOLD size:10.0]
                                                      } forState:UIControlStateNormal];
  [[UITabBarItem appearance] setBadgeColor:RGB(249, 0, 64)];
  
  [[UITabBar appearance] setShadowImage:[UIImage new]];
  [[UITabBar appearance] setBackgroundImage:[UIImage new]];
  
  
  //      UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
  //      view.backgroundColor=[UIColor redColor];
  //      [DELEGATE.window.rootViewController.view addSubview:view];
  
  WYPopoverBackgroundView *popoverAppearance = [WYPopoverBackgroundView appearance];
  [popoverAppearance setArrowHeight:7];
  [popoverAppearance setArrowBase:12];
  
}

+ (UIViewController *)createCustomVCByStoryboardName:(NSString *)storyboardName andStoryboardId:(NSString *)storyboardId {
  return [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:storyboardId];
}

+ (UIToolbar *)createToolbarWithTarget:(id)target WithHandler:(SEL)handler {
  UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 44.0)];
  [toolbar setTranslucent:YES];
  [toolbar setBarTintColor:RGB(204, 204, 204)];
  [toolbar setTintColor:[UIColor whiteColor]];
  
  if (handler && target) {
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Ok" style:UIBarButtonItemStyleDone target:target action:handler];
    UIBarButtonItem *flexibleSeparator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = @[flexibleSeparator, doneButton];
  }
  
  return toolbar;
}

+ (void)showSpinner {
  [self setupCustomSpinner];
  [SVProgressHUD show];
}

+ (void)setupCustomSpinner {
  [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
  [SVProgressHUD setForegroundColor:RGB(214, 0, 65)];
  [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

+ (void)showSpinnerWithProgress:(float)progress {
  [self setupCustomSpinner];
  [SVProgressHUD showProgress:progress];
}

+ (void)hideSpinner {
  [SVProgressHUD dismiss];
}

+ (void)saveAccessToken:(NSString *)accessToken {
  [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:kAccessToken];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getAccessToken {
  return [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken];
}

+ (CATransition *)setupAnimation {
  CATransition* transition = [CATransition animation];
  [transition setDuration:0.2];
  transition.type = kCATransitionMoveIn;
  transition.subtype = kCATransitionFromBottom;
  [transition setFillMode:kCAFillModeBoth];
  [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
  return transition;
}

+ (void)dismissCustomView:(UIView *)customView {
  [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    customView.alpha = 0.0;
  } completion:^(BOOL finished) {
    [customView removeFromSuperview];
  }];
}

+ (CGRect)sizeOfLabel:(UILabel *)label {
  CGSize labelSize = CGSizeMake(label.frame.size.width, MAXFLOAT);
  CGRect requiredSize = [label.text boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: label.font} context:nil];
  return requiredSize;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
  UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
  [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

+ (NSString *)prepareDateFormatterByDate:(NSDate *)date andDateFormat:(NSString *)dateFormat {
  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  dateFormatter.dateFormat = dateFormat;
  return [dateFormatter stringFromDate:date];
}

+ (NSDate *)defaultDate {
  NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
  [components setYear:[components year] - 18];
  NSDate *dateFromComponents = [[NSCalendar currentCalendar] dateFromComponents:components];
  return dateFromComponents;
}

+ (void)prepareSexImageIconByImageView:(UIImageView *)imageView withProfileMapping:(ProfileMapping *)profileMapping {
  NSString *urlPath = profileMapping.Sex.Icon.Url;
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
  CGFloat width = imageView.frame.size.width * 1.5;
  NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
  
  NSURL *urlImage = [NSURL URLWithString:urlString];
  if (urlImage) {
    [imageView sd_setImageWithURL:urlImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
      dispatch_async(dispatch_get_main_queue(), ^{
        imageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
      });
    }];
  } else {
    imageView.image = [UIImage imageNamed:@"placeholder_image"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
  }
}

+ (void)startSoundIsEnd:(BOOL)isEnd {
  SystemSoundID soundID;
  NSURL *pewPewURL = [NSURL URLWithString:isEnd ? kEndRecordPath : kBeginRecordPath];
  AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef)pewPewURL,&soundID);
  AudioServicesPlaySystemSound(soundID);
  if(!isEnd)
  {
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate); // BUG #169: vibrate before recording
  }
}

+ (void)prepareStatusBarWithColor:(UIColor *)color {
  UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
  
  if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
    statusBar.backgroundColor = color;
  }
}

+ (void)changeNavBarColor:(UINavigationBar *)navBar andColor:(UIColor *)color {
  navBar.barTintColor = color;
}

+ (BOOL)isShowHotPageTutorial {
  return [[NSUserDefaults standardUserDefaults] boolForKey:kSaveShowHotPageTutorial];
}

+ (void)saveShowHotPageTutorial {
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSaveShowHotPageTutorial];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)prepareLabelsByProfileMapping:(ProfileMapping *)profileMapping withLabel:(UILabel *)label {
  NSDate *birthdayDate = [NSDate dateWithTimeIntervalSince1970:[profileMapping.BirthDate doubleValue]];
  NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:birthdayDate toDate:[NSDate date] options:0];
  [components setTimeZone:[NSTimeZone defaultTimeZone]];
  if (profileMapping.City != nil) {
    
    NSMutableAttributedString *mutAttrString = [[NSMutableAttributedString alloc]
                                                initWithString:[NSString stringWithFormat:@"%@, %ld", profileMapping.FirstName ?: @"", (long)[components year]]];
    
    [mutAttrString appendAttributedString:[[NSAttributedString alloc]
                                           initWithString:[NSString stringWithFormat:@"\n%@", profileMapping.City]
                                           attributes:@{NSFontAttributeName : [UIFont fontWithName:NOTOSANSDISPLAY_REGULAR size:14.0]}]];
    
    label.attributedText = mutAttrString;
  } else {
    label.text = [NSString stringWithFormat:@"%@, %ld", profileMapping.FirstName ?: @"", (long)[components year]];
  }
}

+ (UIColor *)prepareButtonColorIsHasPrivateProfile:(BOOL)isHasPrivateProfile andIsHidden:(BOOL)isHidden {
  if (isHasPrivateProfile) {
    return RGB(255, 255, 255);
  } else {
    return RGBA(255, 255, 255, 0.4);
  }
}

+ (UIColor *)prepareButtonColorIsHasPrivateProfile:(BOOL)isHasPrivateProfile {
  if (isHasPrivateProfile) {
    return RGB(255, 255, 255);
  } else {
    return RGBA(255, 255, 255, 0.4);
  }
}

+ (NSString *)prepareButtonIsHasPrivateProfile:(BOOL)isHasPrivateProfile andIsHidden:(BOOL)isHidden {
  if (isHasPrivateProfile) {
    if (isHidden) {
      return @"hot_page_strawberry_close";
    } else {
      return @"hot_page_strawberry_open";
    }
  } else {
    return @"hot_page_lock";
  }
}

+ (NSString *)prepareButtonIsHasPrivateProfile:(BOOL)isHasPrivateProfile {
  if (isHasPrivateProfile) {
    return @"hot_page_strawberry_open";
  } else {
    return @"hot_page_lock";
  }
}

+ (void)prepareStrawberryButtons:(NSArray *)strawberryButtons withProfile:(ProfileMapping *)profileMapping isMyProfile:(BOOL)isMyProfile {
  NSInteger index = 0;
  NSString *nameImage = nil;
  UIColor *color = RGBA(255, 255, 255, 0.4);
  
  for (CustomButton *button in strawberryButtons) {
    button.tag = 10 + index;
    
    if (button.tag == OneStrawberryButtonTag) {
      if (profileMapping) {
        if (isMyProfile) {
          nameImage = [Helpers prepareButtonIsHasPrivateProfile:[profileMapping.HasPrivateProfile boolValue]];
          color = [Helpers prepareButtonColorIsHasPrivateProfile:[profileMapping.HasPrivateProfile boolValue]];
        } else {
          nameImage = [Helpers prepareButtonIsHasPrivateProfile:[profileMapping.HasPrivateProfile boolValue]
                                                    andIsHidden:[profileMapping.IsPrivateProfileHidden boolValue]];
          color = [Helpers prepareButtonColorIsHasPrivateProfile:[profileMapping.HasPrivateProfile boolValue]
                                                     andIsHidden:[profileMapping.IsPrivateProfileHidden boolValue]];
        }
      }
    } else if (button.tag == TwoStrawberryButtonTag) {
      if (profileMapping) {
        if (isMyProfile) {
          nameImage = [Helpers prepareButtonIsHasPrivateProfile:[profileMapping.HasPrivateProfileGeneralInfo boolValue]];
          color = [Helpers prepareButtonColorIsHasPrivateProfile:[profileMapping.HasPrivateProfileGeneralInfo boolValue]];
        } else {
          nameImage = [Helpers prepareButtonIsHasPrivateProfile:[profileMapping.HasPrivateProfileGeneralInfo boolValue]
                                                    andIsHidden:[profileMapping.IsPrivateProfileGeneralInfoHidden boolValue]];
          color = [Helpers prepareButtonColorIsHasPrivateProfile:[profileMapping.HasPrivateProfileGeneralInfo boolValue]
                                                     andIsHidden:[profileMapping.IsPrivateProfileGeneralInfoHidden boolValue]];
        }
      }
    } else if (button.tag == ThreeStrawberryButtonTag) {
      if (profileMapping) {
        if (isMyProfile) {
          nameImage = [Helpers prepareButtonIsHasPrivateProfile:[profileMapping.HasPrivateProfilePrivateInteresets boolValue]];
          color = [Helpers prepareButtonColorIsHasPrivateProfile:[profileMapping.HasPrivateProfilePrivateInteresets boolValue]];
        } else {
          nameImage = [Helpers prepareButtonIsHasPrivateProfile:[profileMapping.HasPrivateProfilePrivateInteresets boolValue]
                                                    andIsHidden:[profileMapping.IsPrivateProfilePrivateInteresetsHidden boolValue]];
          color = [Helpers prepareButtonColorIsHasPrivateProfile:[profileMapping.HasPrivateProfilePrivateInteresets boolValue]
                                                     andIsHidden:[profileMapping.IsPrivateProfilePrivateInteresetsHidden boolValue]];
        }
      }
    } else {
      if (profileMapping) {
        if (isMyProfile) {
          nameImage = [Helpers prepareButtonIsHasPrivateProfile:[profileMapping.HasPrivateProfilePrivatePreferences boolValue]];
          color = [Helpers prepareButtonColorIsHasPrivateProfile:[profileMapping.HasPrivateProfilePrivatePreferences boolValue]];
        } else {
          nameImage = [Helpers prepareButtonIsHasPrivateProfile:[profileMapping.HasPrivateProfilePrivatePreferences boolValue]
                                                    andIsHidden:[profileMapping.IsPrivateProfilePrivatePreferencesHidden boolValue]];
          color = [Helpers prepareButtonColorIsHasPrivateProfile:[profileMapping.HasPrivateProfilePrivatePreferences boolValue]
                                                     andIsHidden:[profileMapping.IsPrivateProfilePrivatePreferencesHidden boolValue]];
        }
      }
    }
    
    [button setImage:[UIImage imageNamed:nameImage] forState:UIControlStateNormal];
    [button setBackgroundColor:color];
    index += 1;
  }
}

+ (void)showCustomView:(UIView *)customView {
  [UIView transitionWithView:[UIApplication sharedApplication].keyWindow.rootViewController.view
                    duration:0.5
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^ {
                    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:customView]; }
                  completion:nil];
}

+ (void)resetValues {
  [Helpers saveAccessToken:nil];
  [ServerManager sharedManager].myProfileMapping = nil;
  [[DirectConnectionClient shared] disconnect];
  [DELEGATE setupLoginController];
}

+ (BOOL)isShowMyPublicProfileTutorial {
  return [[NSUserDefaults standardUserDefaults] boolForKey:kSaveShowMyPublicTutorial];
}

+ (void)saveShowMyPublicProfileTutorial {
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSaveShowMyPublicTutorial];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isShowMyPrivateProfileTutorial {
  return [[NSUserDefaults standardUserDefaults] boolForKey:kSaveShowMyPrivateTutorial];
}

+ (void)saveShowMyPrivateProfileTutorial {
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSaveShowMyPrivateTutorial];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isShowPeoplesTutorial {
  return [[NSUserDefaults standardUserDefaults] boolForKey:kSaveShowPeoplesTutorial];
}

+ (void)saveShowPeoplesTutorial {
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSaveShowPeoplesTutorial];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isShowChatTutorial {
  return [[NSUserDefaults standardUserDefaults] boolForKey:kSaveShowChatTutorial];
}

+ (void)saveShowChatTutorial {
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSaveShowChatTutorial];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

