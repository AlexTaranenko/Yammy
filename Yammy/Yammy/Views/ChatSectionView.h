//
//  ChatSectionView.h
//  Yammy
//
//  Created by Alex on 2/15/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatSectionView : UIView

+ (ChatSectionView *)setupChatSectionView;

- (void)prepareTimeLabelByDate:(NSDate *)date;

@end

