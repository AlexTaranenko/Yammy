//
//  HotPageOtherView.h
//  Yammy
//
//  Created by Alex on 28.10.2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotPageOtherViewDelegate <NSObject>

@required
- (void)dismissHotPageOtherView;

@optional


@end

@interface HotPageOtherView : UIView

@property (weak, nonatomic) id<HotPageOtherViewDelegate> delegate;

+ (HotPageOtherView *)prepareHotPageOtherView;

- (void)prepareMainIconImageByImageName:(NSString *)imageName;

- (void)prepareOtherButtonWithTitle:(NSString *)title;

- (void)prepareTitleLabelByTitle:(NSString *)title;

@end
