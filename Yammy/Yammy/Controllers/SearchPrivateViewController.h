//
//  SearchPrivateViewController.h
//  Yammy
//
//  Created by Alex on 9/4/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchPrivateModel.h"

@protocol SearchPrivateViewControllerDelegate <NSObject>

- (void)privateSearchByParams:(NSDictionary *)params;

@end

@interface SearchPrivateViewController : UIViewController

@property (weak, nonatomic) id<SearchPrivateViewControllerDelegate> delegate;

@property (strong, nonatomic) SearchPrivateModel *searchPrivateModel;

@end

