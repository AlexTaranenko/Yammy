//
//  TitlePrivateProfileTableViewCell.h
//  Yammy
//
//  Created by Alex on 12.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitlePrivateProfileTableViewCell : UITableViewCell

- (void)prepareTitlePrivateProfileTableViewCellByTitle:(NSString *)title andImageIcon:(UIImage *)iconImage;

- (void)changePhotoImageContentMode:(UIViewContentMode)contentMode;

@end
