//
//  SoundMessageTableViewCell.h
//  Yammy
//
//  Created by Paul Yevchenko on 27/12/2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

- (void)prepareSoundMessageCellByMessageMapping:(MessageMapping *)messageMapping isOutgoing:(BOOL)outgoing;
    
@end
