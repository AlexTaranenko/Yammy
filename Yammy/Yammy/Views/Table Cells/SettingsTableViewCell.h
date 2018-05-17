//
//  SettingsTableViewCell.h
//  Yammy
//
//  Created by Alex on 2/8/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kSettingsCellIdentifier = @"settingsCell";

@interface SettingsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
