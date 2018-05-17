//
//  CustomLabel.h
//  Yammy
//
//  Created by Alex on 10/6/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CustomLabel : UILabel

@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;

@property (assign, nonatomic) IBInspectable CGFloat borderWidth;

@property (strong, nonatomic) IBInspectable UIColor *borderColor;

@property (assign, nonatomic) IBInspectable CGFloat leftEdge;

@property (assign, nonatomic) IBInspectable CGFloat rightEdge;

@property (assign, nonatomic) IBInspectable CGFloat topEdge;

@property (assign, nonatomic) IBInspectable CGFloat bottomEdge;

@property (assign, nonatomic) UIEdgeInsets edgeInsets;

@end

