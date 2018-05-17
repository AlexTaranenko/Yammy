//
//  YaMaxView.h
//  Yammy
//
//  Created by Alex on 10/30/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YaMaxViewDelegate <NSObject>

@required
- (void)dismissYaMaxView;

@end

@interface YaMaxView : UIView

@property (weak, nonatomic) id<YaMaxViewDelegate> delegate;

+ (YaMaxView *)createYaMaxView;

@end

