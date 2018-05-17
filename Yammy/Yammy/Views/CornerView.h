//
//  CornerView.h
//  Yammy
//
//  Created by Alex on 9/5/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CornerView : UIView

@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;

@property (assign, nonatomic) IBInspectable CGFloat borderWidth;

@property (strong, nonatomic) IBInspectable UIColor *borderColor;

@property (assign, nonatomic) IBInspectable BOOL isAutouRounded;

@end


@interface AutoCornerView : UIView

@property (copy, nonatomic) NSNumber *borderWidth;

@property (copy, nonatomic) UIColor *borderColor;

@property (copy, nonatomic) UIColor *backgroundColor;

@property (copy, nonatomic) NSString *lineCap;

@property (copy, nonatomic) NSArray<NSNumber *> *lineDashPattern;

@end
