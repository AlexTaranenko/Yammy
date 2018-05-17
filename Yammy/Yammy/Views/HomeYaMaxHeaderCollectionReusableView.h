//
//  HomeYaMaxHeaderCollectionReusableView.h
//  Yammy
//
//  Created by Alex on 5/6/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kHomeYaMaxHeaderReusableViewIdentifier = @"homeYaMaxHeaderReusableView";

@protocol HomeYaMaxHeaderCollectionReusableViewDelegate <NSObject>

- (void)openServicesScreen;

@end

@interface HomeYaMaxHeaderCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) id<HomeYaMaxHeaderCollectionReusableViewDelegate> delegate;

@end
