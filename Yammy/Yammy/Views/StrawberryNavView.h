//
//  StrawberryNavView.h
//  Yammy
//
//  Created by Alex on 26.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StrawberryNavViewDelegate <NSObject>

- (void)changePublicToPrivateVC;

@end

@interface StrawberryNavView : UIView

@property (assign, nonatomic) id<StrawberryNavViewDelegate> delegate;

+ (StrawberryNavView *)setupStrawberryNavView;

@end

