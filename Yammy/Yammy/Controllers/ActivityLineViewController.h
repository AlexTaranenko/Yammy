//
//  ActivityLineViewController.h
//  Yammy
//
//  Created by Alex on 13.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityLineViewController : UIViewController

@property (assign, nonatomic) NSInteger currentIndex;

- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated;

@end
