//
//  MyTitlePrivateProfileModel.h
//  Yammy
//
//  Created by Alex on 9/19/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
  HideInfoMyTitlePrivateProfile = 0,
  ShowInfoMyTitlePrivateProfile = 1
} MyTitlePrivateProfileEnum;

typedef enum : NSUInteger {
  GallaryTitleBlock = 0,
  TotalInfoTitleBlock,
  PrivateInterestTitleBlock,
  PrivateAssociationTitleBlock,
} MyTitlePrivateProfileBlock;

@interface MyTitlePrivateProfileModel : NSObject

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *titleButton;

@property (strong, nonatomic) NSNumber *isShowInfo;

- (instancetype)initWithTitle:(NSString *)title withIsShowInfo:(NSNumber *)isShowInfo;

- (NSNumber *)updateShowInfoByNumberOfBlock:(NSInteger)numberOfBlock andPrivateProfileMapping:(PrivateProfileMapping *)privateProfileMapping;

- (void)updateTitleButtonByIsShowInfo:(NSNumber *)isShowInfo;

@end

