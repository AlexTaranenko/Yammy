//
//  HomeMotivationCollectionReusableView.h
//  Yammy
//
//  Created by Alex on 5/6/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kHomeMotivationReusableViewIdentifier = @"homeMotivationReusableView";

@protocol HomeMotivationCollectionReusableViewDelegate <NSObject>

- (void)showMyProfile;

- (void)selectPhotoFromGallery;

- (void)openCamera;

@end

@interface HomeMotivationCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) id<HomeMotivationCollectionReusableViewDelegate> delegate;

- (void)prepareHomeMotivationByType:(AdTypes)adTypes;

@end
