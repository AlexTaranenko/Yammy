//
//  CustomImageView.h
//  Yammy
//
//  Created by Alex on 8/18/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CustomImageView : UIImageView

@property (assign, nonatomic) IBInspectable CGFloat borderWidth;

@property (strong, nonatomic) IBInspectable UIColor *borderColor;

@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;

@property (assign, nonatomic) IBInspectable BOOL isAutouRounded;

@property (assign, nonatomic) IBInspectable BOOL masksToBounds;

@end
