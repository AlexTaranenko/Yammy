//
//  MotivationYaStarView.h
//  Yammy
//
//  Created by Alex on 5/8/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MotivationYaStarViewDelegate <NSObject>

- (void)closeMotivationYaStarView;

- (void)showServicesMotivationYaStarView;

@end

@interface MotivationYaStarView : UIView

@property (weak, nonatomic) id<MotivationYaStarViewDelegate> delegate;

+ (MotivationYaStarView *)createMotivationYaStarView;

@end
