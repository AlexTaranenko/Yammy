//
//  SoundOutputMessageTableViewCell.h
//  Yammy
//
//  Created by Alex on 11/3/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageMapping.h"
#import "SoundMessageTableViewCell.h"

static NSString *kSoundOutputMessageCellIdentifier = @"soundOutputMessageCell";

@protocol SoundOutputMessageTableViewCellDelegate <NSObject>

@optional

- (void)resendSoundMessage;

@end

@interface SoundOutputMessageTableViewCell : SoundMessageTableViewCell

@property (weak, nonatomic) id<SoundOutputMessageTableViewCellDelegate> delegate;

- (void)changeStatusImageByMessageMapping:(MessageMapping *)messageMapping;

@end

