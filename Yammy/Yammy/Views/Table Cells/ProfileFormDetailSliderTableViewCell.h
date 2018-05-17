//
//  ProfileFormDetailSliderTableViewCell.h
//  Yammy
//
//  Created by Alex on 3/21/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kProfileFormDetailSliderCellIdentifier = @"profileFormDetailSliderCell";

@protocol ProfileFormDetailSliderTableViewCellDelegate <NSObject>

@optional

- (void)saveResultValue:(NSNumber *)value;

@end

@interface ProfileFormDetailSliderTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ProfileFormDetailSliderTableViewCellDelegate> delegate;

@property (strong, nonatomic) NSNumber *value;

- (void)setupPrivateSlider:(BOOL)isPenis;

- (void)setupSlider:(BOOL)isHeight;

@end
