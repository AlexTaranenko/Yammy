//
//  HomeCoincidenceHeaderCollectionReusableView.h
//  Yammy
//
//  Created by Alex on 18.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeCoincidenceHeaderCollectionReusableViewDelegate <NSObject>

- (void)showPrivateProfileByView:(UICollectionReusableView *)view;

- (void)showChatByView:(UICollectionReusableView *)view;

@end

@interface HomeCoincidenceHeaderCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) id<HomeCoincidenceHeaderCollectionReusableViewDelegate> delegate;

- (void)prepareHomeCoincidenceByMatchMapping:(MatchMapping *)matchMapping;

@end
