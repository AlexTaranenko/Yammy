//
//  CircularImageView.h
//  Yammy
//
//  Created by Alex on 8/18/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CircularImageView : UIImageView

@property (nonatomic, copy) UIColor*    borderColor;
@property (nonatomic, copy) NSNumber*   borderWidth;

@end
