//
//  CustomButton.h
//  Yammy
//
//  Created by Alex on 10/9/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CustomButton : UIButton

@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;

@property (assign, nonatomic) IBInspectable CGFloat borderWidth;

@property (strong, nonatomic) IBInspectable UIColor *borderColor;

@end

