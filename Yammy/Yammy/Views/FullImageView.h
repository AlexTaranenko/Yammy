//
//  FullImageView.h
//  Yammy
//
//  Created by Alex on 27.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageMapping.h"

@protocol FullImageViewDelegate <NSObject>

@optional
- (void)dismissFullImageView;

- (void)deleteImageWithImageMapping:(ImageMapping *)imageMapping;

- (void)setupAvatarImageWithImageMapping:(ImageMapping *)imageMapping;

- (void)moveImageWithImageMapping:(ImageMapping *)imageMapping;

@end

@interface FullImageView : UIView

@property (strong, nonatomic) ImageMapping *imageMapping;

@property (assign, nonatomic) BOOL isMyPublicPhoto;

@property (weak, nonatomic) id<FullImageViewDelegate> delegate;

+ (FullImageView *)prepareFullImageView;

- (void)preparePhotoImageView;

- (void)preparePhotoImageViewByMessageMapping:(MessageMapping *)messageMapping;

- (void)preparePhotoImageViewByImageMapping:(ImageMapping *)imageMapping;

@end

