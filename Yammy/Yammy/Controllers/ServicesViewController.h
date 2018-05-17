//
//  ServicesViewController.h
//  Yammy
//
//  Created by Alex on 10/19/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ServicesViewControllerDelegate <NSObject>

- (void)reloadMyPublicProfileServices;

@end

@interface ServicesViewController : UIViewController

@property (weak, nonatomic) id<ServicesViewControllerDelegate> delegate;

@end

