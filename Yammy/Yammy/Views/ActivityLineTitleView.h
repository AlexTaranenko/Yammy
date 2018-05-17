//
//  ActivityLineTitleView.h
//  Yammy
//
//  Created by Alex on 10/5/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
  AllActivityButtonTag = 0,
  LikesActivityButtonTag,
  MatchesActivityButtonTag
} ActivityButtonTag;

@protocol ActivityLineTitleViewDelegate <NSObject>

- (void)selectActivityLineTitleByTag:(NSInteger)buttonTag;

@end

IB_DESIGNABLE
@interface ActivityLineTitleView : UIControl

@property (weak, nonatomic) id<ActivityLineTitleViewDelegate> delegate;

@property (strong, nonatomic) IBInspectable NSString *titleText;

@property (strong, nonatomic) IBInspectable NSString *badgeNumberText;

@property (strong, nonatomic) IBInspectable UIColor *bottomIndicatorColor;

@property (assign, nonatomic) IBInspectable NSInteger buttonTag;

@property (assign, nonatomic) IBInspectable BOOL hidden;

@end

