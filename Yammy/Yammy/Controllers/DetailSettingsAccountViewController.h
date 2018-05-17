//
//  DetailSettingsAccountViewController.h
//  Yammy
//
//  Created by Alex on 2/12/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSettingsMapping.h"

typedef enum : NSUInteger {
  ConfidenceDetailRow = 0,
  NotificationDetailRow,
  LanguageDetailRow,
  VerificationDetailRow,
  DeleteProfileDetailRow
} DetailSettingsAccountRow;


@interface DetailSettingsAccountViewController : UIViewController

@property (strong, nonatomic) NSString *navTitle;

@property (assign, nonatomic) DetailSettingsAccountRow detailSettingsAccountRow;

@property (strong, nonatomic) UserSettingsMapping *userSettingsMapping;

@end

