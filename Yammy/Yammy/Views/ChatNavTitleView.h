//
//  ChatNavTitleView.h
//  Yammy
//
//  Created by Alex on 02.11.2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileMapping.h"

@interface ChatNavTitleView : UIView

+ (ChatNavTitleView *)createChatNavTitleView;

- (void)prepareChatNavTitleViewByProfileMapping:(ProfileMapping *)profileMapping;

@end

