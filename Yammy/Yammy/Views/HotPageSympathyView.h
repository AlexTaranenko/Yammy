//
//  HotPageSympathyView.h
//  Yammy
//
//  Created by Alex on 10/3/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotPageSympathyViewDelegate <NSObject>

@optional
- (void)pushToChat;

@end

@interface HotPageSympathyView : UIView

@property (weak, nonatomic) id<HotPageSympathyViewDelegate> delegate;

+ (HotPageSympathyView *)prepareHotPageSympathyView;

@end

